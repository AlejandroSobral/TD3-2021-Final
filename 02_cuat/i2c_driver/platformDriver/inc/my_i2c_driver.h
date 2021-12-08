#define MINOR_          0
#define MAX_QUANT      1
#define MyMsg    	   "MyMsg"
#define CLASS_NAME     "My_i2c_TD3_class" 
#define COMPATIBLE	   "My_i2c_TD3"
#define NAME			COMPATIBLE


// Prototipes
static int i2c_probe(struct platform_device * i2c_pd);
static int i2c_remove(struct platform_device * i2c_pd);
static int MyOpen(struct inode *inode, struct file *file);
static int MyRelease(struct inode *inode, struct file *file);
static ssize_t MyRead (struct file * , char __user * , size_t , loff_t * );
static ssize_t MyWrite (struct file * , const char __user * , size_t , loff_t * );
static long Myioctl(struct file *file, unsigned int cmd, unsigned long arg);
irqreturn_t i2c_irq_handler(int irq, void *dev_id, struct pt_regs *regs);
static int  cdev_RW(struct device *dev, struct kobj_uevent_env *env);
int8_t MyReadFIFO(uint16_t quant);

struct file_operations i2c_ops = {
	.owner = THIS_MODULE,
	.open = MyOpen,
	.read = MyRead,
	.write = MyWrite,
	.release = MyRelease,
	.unlocked_ioctl = Myioctl
};

static struct {
	dev_t myi2c;

	struct class * class;
	struct cdev * cdev;
	struct i2c_client *client;

} device;

struct MPU6050_REGS
{
    int accel_xout;
    int accel_yout;
    int accel_zout;
    int temp_out;
    int gyro_xout;
    int gyro_yout;
    int gyro_zout;
};


static struct {
	uint8_t rxData;
	uint8_t txData[2];
	int dataCount;
	int operation;

} Myi2cStruct; 



MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("Alejandro Sobral - TD3");
MODULE_VERSION("1.0");
MODULE_DESCRIPTION("Linux Kernel Module");