#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/kdev_t.h> 			            
#include <linux/device.h> 			            
#include <linux/cdev.h>
#include <linux/uaccess.h>                      
#include <linux/types.h>                        
#include <linux/slab.h>		                         
#include <linux/fs.h>                         
#include <linux/module.h>                       
#include <linux/of_address.h>                   
#include <linux/platform_device.h>              
#include <linux/of.h>                           
#include <linux/io.h>                           
#include <linux/interrupt.h>                    
#include <linux/delay.h>                        
		            
#include <linux/ioctl.h>
#include <linux/i2c.h>
#include <linux/i2c-dev.h>

#include "../inc/BBB_I2C_reg.h"
#include "../inc/my_i2c_driver.h"
#include "../inc/MPU6050.h"
//#include "../src/my_i2c_driver_mpu6050.c"

/***SUMM
	• Alloc device- {cdev_alloc}
	• Get Minor number using {alloc_chrdev_region}
	• Match the File Operations pointer to cdev structure {cdev_init}
	• Create struct class pointer that format the struct and get it ready for device_create, that receives the struct class that create_class has formatted. {class_create}
	• Creates the entry in the sysfs and register to the specified class {device_create}
	• Platform_driver_register. Register the platform driver as a whole {platform_driver_register
END*/

//

// Set initial input parameters

int Gscale = GFS_250DPS;
int Ascale = AFS_2G;
int Aaxis = AXIS_X;

// ioctl
volatile int i2c_wkup = 0;
int read_count = 0;
wait_queue_head_t queue_in = __WAIT_QUEUE_HEAD_INITIALIZER(queue_in);
wait_queue_head_t queue = __WAIT_QUEUE_HEAD_INITIALIZER(queue);
static void __iomem *cmper_baseAddr, *ctlmod_baseAddr, *i2c2_baseAddr;
volatile int virq;
uint8_t *FIFO_Buff;
volatile uint16_t rx_cant = 0;

static struct of_device_id i2c_of_device_ids[] = {
	{
		.compatible = COMPATIBLE,
	},
	{}};

MODULE_DEVICE_TABLE(of, i2c_of_device_ids);



//Show platform driver where file operations functions are
static struct platform_driver i2c_pd = {
	.probe = i2c_probe,
	.remove = i2c_remove,
	.driver = {
		.name = COMPATIBLE, 
		.of_match_table = of_match_ptr(i2c_of_device_ids)},
};

static int __init i2c_init(void)
{
	int oper_result = 0;
	pr_alert("%s: Allocating CDev\n", MyMsg);

	// Allocates and returns a cdev structure, or NULL on failure. https://www.kernel.org/doc/htmldocs/kernel-api/API-cdev-alloc.html
	device.cdev = cdev_alloc();

	if (!(device.cdev))
	{
		pr_alert("%s: Cdev couldn't be allocate\n", MyMsg);
		cdev_del(device.cdev);
	}
	/*Allocates a range of char device numbers. The major number will be chosen dynamically, 
	and returned (along with the first minor number) in dev. Returns zero or a negative error code.*/
	// https://www.kernel.org/doc/htmldocs/kernel-api/API-alloc-chrdev-region.html
	// int alloc_chrdev_region (	dev_t * dev, unsigned baseminor,unsigned count, const char * name);

	if ((oper_result = alloc_chrdev_region(&device.myi2c, MINOR_, MAX_QUANT, NAME)) < 0)
	{
		pr_alert("%s: Getting mayor went wrong!\n", MyMsg);
		cdev_del(device.cdev);
		return oper_result;
	}

	pr_alert("%s: Mayor number assinged (HEXA) %d 0x%X\n", MyMsg, MAJOR(device.myi2c), MAJOR(device.myi2c));
	// Matches cdev structure with File Operations structure
	//void cdev_init(struct cdev * cdev, const struct file_operations * fops);
	//void answer, no failure check is possible. Sry dude.

	cdev_init(device.cdev, &i2c_ops);

	// https://www.kernel.org/doc/htmldocs/kernel-api/API-cdev-add.html
	//cdev_add adds the device represented by p to the system, making it live immediately. A negative error code is returned on failure.
	// int cdev_add (	struct cdev * p, dev_t dev, unsigned count);

	if ((oper_result = cdev_add(device.cdev, device.myi2c, MAX_QUANT)) < 0)
	{
		unregister_chrdev_region(device.myi2c, MAX_QUANT);
		pr_alert("%s: chrdev register has failed\n", MyMsg);
		return oper_result;
	}

	// https://manned.org/class_create/e9da076a
	// This is used to create a struct class pointer that can then be used in calls to device_create
	// struct class * class_create(struct module * owner, const char * name);
	// Non struct answer is considered a fail op result
	// This is just to have the struct in the right format to exec device_create
	if ((device.class = class_create(THIS_MODULE, CLASS_NAME)) == NULL)
	{
		pr_alert("%s: Cannot create the struct class for device\n", MyMsg);
		cdev_del(device.cdev);
		unregister_chrdev_region(device.myi2c, MAX_QUANT);
		return -1;
	}

	// Change permission /dev/My_i2c_TD3 to R/W -- 666 perm assigned

	device.class->dev_uevent = cdev_RW;

	// https://manpages.debian.org/jessie/linux-manual-3.16/device_create.9.en.html
	// This function can be used by char device classes. A struct device will be created in sysfs, registered to the specified class.
	// struct device * device_create(struct class * class, struct device * parent, dev_t devt, void * drvdata, const char * fmt, ...);
	if ((device_create(device.class, NULL, device.myi2c, NULL, COMPATIBLE)) == NULL)
	{
		pr_alert("%s: Cannot create the Device\n", MyMsg);
		cdev_del(device.cdev);
		unregister_chrdev_region(device.myi2c, MAX_QUANT);
		class_destroy(device.class);
		return -1;
	}
	pr_alert("%s: Succesful operation\n", MyMsg);

	// https://www.kernel.org/doc/Documentation/driver-model/platform.txt
	// register a driver for platform-level devices : platform driver structure
	// This function ends up all the structres previously set. In particular, all structures inside device.*
	// As this ends, i2c_probe is called as callback **PROBE**
	if ((oper_result = platform_driver_register(&i2c_pd)) < 0)
	{
		pr_alert("%s: platformDevice registration failed\n", MyMsg);
		cdev_del(device.cdev);
		unregister_chrdev_region(device.myi2c, MAX_QUANT); // This executes i2c_remove!
		device_destroy(device.class, device.myi2c);
		class_destroy(device.class);
		return oper_result;
	}

	return 0;
}

static void __exit i2c_exit(void)
{
	pr_alert("%s: Closing driver\n", MyMsg);
	cdev_del(device.cdev);
	unregister_chrdev_region(device.myi2c, MAX_QUANT);
	device_destroy(device.class, device.myi2c);
	class_destroy(device.class);
	platform_driver_unregister(&i2c_pd);
	pr_alert("%s: Exit finished\n", MyMsg);
}

static int i2c_probe(struct platform_device *i2c_pd)
{
	int oper_result = 0;
	int aux;
	uint8_t rx;

	pr_alert("%s: MyLogMsg i2c probe starting PROBE\n", MyMsg);

	// Map register to a base address
	// CM_PER -> Control Module Periph.
	if ((cmper_baseAddr = ioremap(CM_PER, CM_PER_LEN)) == NULL)
	{
		pr_alert("%s: Mapping was not succesful CM_PER\n", MyMsg);
		return 1;
	}
	pr_info("%s: MyLogMsg cmper_baseAddr: 0x%X\n", MyMsg, (unsigned int)cmper_baseAddr);

	// Control Module mapping
	if ((ctlmod_baseAddr = ioremap(CTRL_MODULE_BASE, CTRL_MODULE_LEN)) == NULL)
	{
		pr_alert("%s: MyLogMsg Control Module mapping has failed\n", MyMsg);
		iounmap(cmper_baseAddr);
		return 1;
	}
	pr_info("%s: MyLogMsg ctlmod_baseAddr: 0x%X\n", MyMsg, (unsigned int)ctlmod_baseAddr);

	//I2C Clock enable
	aux = ioread32(cmper_baseAddr + CM_PER_I2C2_CLKCTRL);
	aux |= 0x02;
	iowrite32(aux, cmper_baseAddr + CM_PER_I2C2_CLKCTRL);
	msleep(10); // Wait for clock

	// SDA & SCL pins P1515
	iowrite32(0x33, ctlmod_baseAddr + CTRL_MODULE_UART1_CTSN);
	iowrite32(0x33, ctlmod_baseAddr + CTRL_MODULE_UART1_RTSN);

	// I2C register mapping
	if ((i2c2_baseAddr = ioremap(I2C2, I2C2_LEN)) == NULL)
	{
		pr_alert("%s: MyLogMsg I2C mapping has failed\n", MyMsg);
		iounmap(cmper_baseAddr);
		iounmap(ctlmod_baseAddr);
		cdev_del(device.cdev);
		device_destroy(device.class, device.myi2c);
		class_destroy(device.class);
		unregister_chrdev_region(device.myi2c, MAX_QUANT);
		return 1;
	}
	pr_info("%s: MyLogMsg i2c2_baseAddr: 0x%X\n", MyMsg, (unsigned int)i2c2_baseAddr);


	//Request IRQ Number
	// Virtual IRQ shall be activated each time an interrupt ocurrs
	if ((virq = platform_get_irq(i2c_pd, 0)) < 0)
	{
		pr_alert("%s: Virtual IRQ assingment failed\n", MyMsg);
		iounmap(cmper_baseAddr);
		iounmap(ctlmod_baseAddr);
		iounmap(i2c2_baseAddr);
		cdev_del(device.cdev);
		device_destroy(device.class, device.myi2c);
		class_destroy(device.class);
		unregister_chrdev_region(device.myi2c, MAX_QUANT);
		return 1;
	}

	// VIRQ Handler assignment
	if (request_irq(virq, (irq_handler_t)i2c_irq_handler, IRQF_TRIGGER_RISING, COMPATIBLE, NULL))
	{
		pr_alert("%s: Virtual IRQ binding failed\n", MyMsg);
		iounmap(cmper_baseAddr);
		iounmap(ctlmod_baseAddr);
		iounmap(i2c2_baseAddr);
		return 1;
	}
	pr_info("%s: IRQ number %d\n", MyMsg, virq);

	// Configure register -> disable I2C2
	iowrite32(0x0000, i2c2_baseAddr + I2C_CON);
	// configure prescaler to 24MHz
	iowrite32(0x03, i2c2_baseAddr + I2C_PSC);
	// Configure SCL to 400kHz
	iowrite32(0x08, i2c2_baseAddr + I2C_SCLL);
	iowrite32(0x14, i2c2_baseAddr + I2C_SCLH);
	// Set a random own address
	iowrite32(0x85, i2c2_baseAddr + I2C_OA);
	// configure SYSC
	// Slave address -> MPU6050
	iowrite32(SLAVE0_ADDR, i2c2_baseAddr + I2C_SA);
	// Configure register -> ENABLE & MASTER & RX & STOP
	iowrite32(0x8000, i2c2_baseAddr + I2C_CON);
	// // disable interrupts

	MyWriteByte(WHO_AM_I, 0x00, READ_OP);
	rx = MyReadByte();
	pr_info("%s: MPU6050 -> INIT WHO_AM_I: 0x%x\n", MyMsg, rx);
	initMPU6050();

	pr_info("%s: Probe is done ..\n", MyMsg);
	return oper_result;
}

static int i2c_remove(struct platform_device *i2c_pd)
{
	int oper_result = 0;

	//Unmaps ios
	pr_alert("%s: Starting remove\n", MyMsg);
	iounmap(cmper_baseAddr);
	iounmap(ctlmod_baseAddr);
	iounmap(i2c2_baseAddr);
	free_irq(virq, NULL);
	pr_alert("%s: Finishing remove\n", MyMsg);
	return oper_result;
}

static int MyOpen(struct inode *inode, struct file *file)
{

	pr_alert("%s: MyOPEN\n", MyMsg);
	pr_alert("%s: Everything was done at probe, before hand\n", MyMsg);

	return 0;
}

static int MyRelease(struct inode *inode, struct file *file)
{
	pr_alert("%s: RELEASE file operation\n", MyMsg);
	return 0;
}

static long Myioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	return EFAULT;
}

static ssize_t MyWrite(struct file *filep, const char __user *buffer, size_t len, loff_t *offset)
{
	return EFAULT;
}

static ssize_t MyRead(struct file *filep, char __user *buffer, size_t len, loff_t *offset)
{

	uint16_t FIFOCounter;
	uint8_t BufferFIFO[2];

	pr_alert("%s: |MyRead| I2C driver read\n", MyMsg);

	if (access_ok(VERIFY_WRITE, buffer, len) == 0)
	{
		pr_alert("%s: |MyRead| User buffer failed\n", MyMsg);
		return -1;
	}


	// Length should be fewer than 1022
	if (len > 1022)
	{
		len = 1022; 
	}
	if (len % 14 != 0)
	{
		pr_alert("%s: |MyRead| Not multiplot of 14\n", MyMsg);
		return -1;
	}

	FIFO_Buff = (uint8_t *)kmalloc(len * sizeof(uint8_t), GFP_KERNEL);
	if (FIFO_Buff == NULL)
	{
		pr_alert("%s: |MyRead| Kernel memory failed\n", MyMsg);
		return -1;
	}

	//bit 6 FIFO_EN 	a 1
	//bit 2 FIFO_RESET	a 1
	MyWriteByte(USER_CTRL, 0x44, WRITE_OP); // Reset FIFO
	do
	{
		// leo quant de datos FIFO
		MyWriteByte(FIFO_COUNTH, 0x00, READ_OP);
		BufferFIFO[0] = MyReadByte();

		MyWriteByte(FIFO_COUNTL, 0x00, READ_OP);
		BufferFIFO[1] = MyReadByte();
		FIFOCounter = (uint16_t)((BufferFIFO[0] << 8) | BufferFIFO[1]);
		
	} while (FIFOCounter < len);

	MyWriteByte(FIFO_R_W, 0x00, READ_OP);
	MyReadFIFO(len);

	if (copy_to_user(buffer, FIFO_Buff, len) > 0) //en copia correcta devuelve 0
	{
		pr_alert("%s:|MyRead| Copy buffer to userspace failed\n", MyMsg);
		return -1;
	}

	kfree(FIFO_Buff);

	return 0;
}

irqreturn_t i2c_irq_handler(int irq, void *dev_id, struct pt_regs *regs)
{
	uint32_t irq_status;
	uint32_t auxRegister;
	uint32_t reg_value;

	// Check IRQ staus
	irq_status = ioread32(i2c2_baseAddr + I2C_IRQSTATUS);

	//I2C ACK
	if (irq_status & I2C_IRQENABLE_CLR_ACK)
	{
		pr_alert("%s: |IRQ| IRQ handler ACK\n", MyMsg);
	}

	// I2C RX
	if (irq_status & I2C_IRQSTATUS_RRDY)
	{
			//pr_alert("%s: |IRQ| RRDY rxcant: %d DataCount %d\n", MyMsg, rx_cant, Myi2cStruct.dataCount);
		if (rx_cant > 1)
		{
			FIFO_Buff[Myi2cStruct.dataCount] = ioread8(i2c2_baseAddr + I2C_DATA);
			//pr_alert("%s: |IRQ| FIFO handler source -> RX[%d]: 0x%x\n", MyMsg, Myi2cStruct.dataCount, FIFO_Buff[Myi2cStruct.dataCount]);
		}
		else
		{
			Myi2cStruct.rxData = ioread8(i2c2_baseAddr + I2C_DATA);
			//pr_alert("%s: |IRQ| -> RX 0x%x\n", MyMsg, Myi2cStruct.rxData);	
		}
		Myi2cStruct.dataCount++;
		if (Myi2cStruct.dataCount == rx_cant)
		{
			Myi2cStruct.dataCount = 0;
			rx_cant = 0;
			//Rx interrupt disable
			reg_value = ioread32(i2c2_baseAddr + I2C_IRQENABLE_CLR);
			reg_value |= I2C_IRQSTATUS_RRDY;
			iowrite32(reg_value, i2c2_baseAddr + I2C_IRQENABLE_CLR);
			// Wake up read
			i2c_wkup = 1;
			wake_up_interruptible(&queue);
		}

		// IRQ Flags clean
		auxRegister = ioread32(i2c2_baseAddr + I2C_IRQSTATUS);
		auxRegister |= 0x27;
		iowrite32(auxRegister, i2c2_baseAddr + I2C_IRQSTATUS);
	}
	// I2C_TX
	if (irq_status & I2C_IRQSTATUS_XRDY)
	{
		if (Myi2cStruct.operation == READ_OP)
		{
			// Write byte at I2C_DATA iot transmitt
			iowrite8(Myi2cStruct.txData[0], i2c2_baseAddr + I2C_DATA);
			// Wake up waiting process
			i2c_wkup = 1;
			wake_up(&queue_in);
		}
		if (Myi2cStruct.operation == WRITE_OP)
		{
			if (Myi2cStruct.dataCount > 0)
			{			
				// Write data itself
				iowrite8(Myi2cStruct.txData[1], i2c2_baseAddr + I2C_DATA);
				Myi2cStruct.dataCount = 0;
				// Wake up waiting process
				//Tx interrupt disable
				auxRegister = ioread32(i2c2_baseAddr + I2C_IRQENABLE_CLR);
				auxRegister |= I2C_IRQSTATUS_XRDY;
				iowrite32(auxRegister, i2c2_baseAddr + I2C_IRQENABLE_CLR);
				i2c_wkup = 1;
				wake_up(&queue_in);
			}
			else
			{	//Write address data
				iowrite8(Myi2cStruct.txData[0], i2c2_baseAddr + I2C_DATA);
				Myi2cStruct.dataCount++;
			}
		}
		// Clean IRQ flags
		auxRegister = ioread32(i2c2_baseAddr + I2C_IRQSTATUS);
		auxRegister |= 0x36;
		iowrite32(auxRegister, i2c2_baseAddr + I2C_IRQSTATUS);
	}

	// Clean all flag
	irq_status = ioread32(i2c2_baseAddr + I2C_IRQSTATUS);
	irq_status |= 0x3F;
	iowrite32(irq_status, i2c2_baseAddr + I2C_IRQSTATUS);
	return (irqreturn_t)IRQ_HANDLED;
}
module_init(i2c_init);
module_exit(i2c_exit);

void initMPU6050(void)
{

	printk(KERN_INFO " MyLogMsg : Initializing MPU6050...\n");
	MyWriteByte(PWR_MGMT_1, 0x01, WRITE_OP); 
	// Gryo & Accelerometer
	// DLPF_CFG = 2:0 = 010; Set sampling at 1kHz
	MyWriteByte(CONFIG, 0x03, WRITE_OP);
	// Sample rate = Gyro output rate/(1 + SMPLRT_DIV)
	MyWriteByte(SMPLRT_DIV, 0x63, WRITE_OP); 
	// Gyro cfg
	MyWriteByte(GYRO_CONFIG, 0x00, WRITE_OP);
	// Acc cfg
	MyWriteByte(ACCEL_CONFIG, 0x00, WRITE_OP);
	// Cf interrupt & bypass enable
	MyWriteByte(INT_PIN_CFG, 0x02, WRITE_OP);
	// Enable data interrupt at bit 0
	MyWriteByte(INT_ENABLE, 0x01, WRITE_OP);
	//Enable fifo - Bit 6
	//Enable fifo reset - Bit 1
	MyWriteByte(USER_CTRL, 0x44, WRITE_OP);
	//Config FIFO
	//Habilito FIFO para Temp, Acel y Gyro
	MyWriteByte(FIFO_EN, 0xF8, WRITE_OP);
	msleep(100); // Wait for some samples
	printk(KERN_INFO " MyLogMsg : MPU6050 initialization OK\n");
}

void MyWriteByte(uint8_t registers, uint8_t value, uint8_t OPERATION)
{
	/*
      21.3.15.6 Transmit Data

      Poll the transmit data ready interrupt flag bit (XRDY) in the I2C status register
      (I2C_IRQSTATUS_RAW), use the XRDY interrupt (I2C_IRQENABLE_SET.XRDY_IE set) or use 
      the DMA TX (I2C_BUF.XDMA_EN set together with I2C_DMATXENABLE_SET) 
      to write data into 
      the data transmit register (I2C_DATA). Use draining feature (I2C_IRQSTATUS_RAW.XDR 
      enabled by I2C_IRQENABLE_SET.XDR_IE)) if the transfer length is not equal with FIFO 
      threshold.
   */
	uint32_t i = 0;
	uint32_t reg_value = 0;
	//printk(KERN_INFO "|writebyte|  MyMsg : Sending byte...\n");
	// check if busy
	reg_value = ioread32(i2c2_baseAddr + I2C_IRQSTATUS_RAW);
	while ((reg_value >> 12) & 1)
	{
		msleep(200);
		printk(KERN_ERR "|writebyte| [ERROR] MyMsg : Device busy\n");
		i++;
		if (i == 3)
		{
			printk(KERN_ERR "|writebyte| [ERROR] MyMsg : busy (%s %d)\n", __FUNCTION__, __LINE__);
			return;
		}
		reg_value = ioread32(i2c2_baseAddr + I2C_IRQSTATUS_RAW);
	}
	Myi2cStruct.dataCount = 0;
	if (OPERATION == READ_OP)
	{
		Myi2cStruct.operation = READ_OP;
		Myi2cStruct.txData[0] = registers;
		iowrite32(0x01, i2c2_baseAddr + I2C_CNT);
	}
	if (OPERATION == WRITE_OP)
	{
		Myi2cStruct.operation = WRITE_OP;
		Myi2cStruct.txData[0] = registers;
		Myi2cStruct.txData[1] = value;
		iowrite32(0x02, i2c2_baseAddr + I2C_CNT);
	}

	// configure register -> ENABLE & MASTER & TX & STOP
	reg_value = ioread32(i2c2_baseAddr + I2C_CON);
	reg_value |= 0x600;
	iowrite32(reg_value, i2c2_baseAddr + I2C_CON);

	// Enable tx interrupt
	iowrite32(I2C_IRQSTATUS_XRDY, i2c2_baseAddr + I2C_IRQENABLE_SET);
	// Configuration register START [1:0] = 01 b
	reg_value = ioread32(i2c2_baseAddr + I2C_CON);
	reg_value |= I2C_CON_START;
	iowrite32(reg_value, i2c2_baseAddr + I2C_CON);

	// Wait until transmission ends UN-INTERRUPTIBLE
	wait_event(queue_in, i2c_wkup > 0);

	i2c_wkup = 0;

	//printk(KERN_INFO "|writebyte|  MyLogMsg : TX OK\n");

	// Configuration register -> STOP [1:0] = 10 b
	reg_value = ioread32(i2c2_baseAddr + I2C_CON);
	reg_value &= 0xFFFFFFFE;
	reg_value |= I2C_CON_STOP;
	iowrite32(reg_value, i2c2_baseAddr + I2C_CON);
	msleep(1);
	//printk(KERN_INFO "|writebyte|  MyLogMsg : Byte transmission OK\n");
}

uint8_t MyReadByte(void)
{
	
	uint32_t reg_value = 0;
	uint32_t status = 0;
	uint8_t newdata;

	//pr_info(KERN_INFO "|readbyte|  MyLogMsg : Reading byte...\n");
	reg_value = ioread32(i2c2_baseAddr + I2C_IRQSTATUS_RAW);
	if((reg_value >> 12) & 1)
	{
		//printk(KERN_ERR "|readbyte| [ERROR] MyLogMsg : Device busy\n");
		return -1;
	}

	Myi2cStruct.dataCount=0;
	rx_cant = 1;
	iowrite32(1, i2c2_baseAddr + I2C_CNT);
	// Configure register -> ENABLE & MASTER & RX & STOP
	reg_value = ioread32(i2c2_baseAddr + I2C_CON);
	reg_value = 0x8400;
	iowrite32(reg_value, i2c2_baseAddr + I2C_CON);
	// Enable rx interrupt
	iowrite32(I2C_IRQSTATUS_RRDY, i2c2_baseAddr + I2C_IRQENABLE_SET);
	// Configuration register -> START [1:0] = 01 b
	reg_value = ioread32(i2c2_baseAddr + I2C_CON);
	reg_value &= 0xFFFFFFFC;
	reg_value |= I2C_CON_START;
	iowrite32(reg_value, i2c2_baseAddr + I2C_CON);

	// Wait until reception ends
	if ((status = wait_event_interruptible(queue, i2c_wkup > 0)) < 0)
	{
		i2c_wkup = 0;
		printk(KERN_ERR "|readbyte| [ERROR] MyLogMsg : read (%s %d)\n", __FUNCTION__, __LINE__);
		return status;
	}

	i2c_wkup = 0;
	//printk(KERN_INFO "|readbyte|  MyLogMsg : RX OK\n");
	// Configure register -> STOP [1]
	reg_value = ioread32(i2c2_baseAddr + I2C_CON);
	reg_value &= 0xFFFFFFFE;
	reg_value |= I2C_CON_STOP;
	iowrite32(reg_value, i2c2_baseAddr + I2C_CON);

	newdata = Myi2cStruct.rxData;
	//printk(KERN_INFO "|readbyte|  MyLogMsg : Byte reception OK\n");
	return newdata;
}

static int cdev_RW(struct device *dev, struct kobj_uevent_env *env)
{
	add_uevent_var(env, "DEVMODE=%#o", 0666);
	return 0;
}

int8_t MyReadFIFO(uint16_t quant)
{
	uint32_t i = 0;
	uint32_t reg_value = 0;
	uint32_t estado = 0;

	// Check if line is Busy
	reg_value = ioread32(i2c2_baseAddr + I2C_IRQSTATUS_RAW);
	while ((reg_value >> 12) & 1)
	{
		msleep(200);

		pr_alert("%s: readFIFO ERROR Device busy\n", MyMsg);
		i++;
		if (i >= 4)
		{
			return -1;
		}
		reg_value = ioread32(i2c2_baseAddr + I2C_IRQSTATUS_RAW);
	}

	//pr_alert("%s: readFIFO\n", MyMsg);
	// data = n byte
	rx_cant = quant;
	iowrite32(quant, i2c2_baseAddr + I2C_CNT);

	// Config register -> ENABLE & MASTER & RX
	reg_value = ioread32(i2c2_baseAddr + I2C_CON);
	reg_value = 0x8400;
	iowrite32(reg_value, i2c2_baseAddr + I2C_CON);

	// Enable RX interrupt
	iowrite32(I2C_IRQSTATUS_RRDY, i2c2_baseAddr + I2C_IRQENABLE_SET);

	// Start condition
	reg_value = ioread32(i2c2_baseAddr + I2C_CON);
	reg_value &= 0xFFFFFFFC;
	reg_value |= I2C_CON_START;
	iowrite32(reg_value, i2c2_baseAddr + I2C_CON);

	// Wait RX ends
	if ((estado = wait_event_interruptible(queue, i2c_wkup > 0)) < 0)
	{
		i2c_wkup = 0;
		pr_alert("%s: readFIFO ERROR read\n", MyMsg);
		return estado;
	}
	i2c_wkup = 0;

	// Stop condition
	reg_value = ioread32(i2c2_baseAddr + I2C_CON);
	reg_value &= 0xFFFFFFFE;
	reg_value |= I2C_CON_STOP;
	iowrite32(reg_value, i2c2_baseAddr + I2C_CON);
	//pr_alert("%s: readFIFO OK\n", MyMsg);

	return 0;
}