
//https://drive.google.com/file/d/17rkUO6gu7quXWNaNnaJK1ktYu0u3vuaH/view?usp=sharing
// Ti datasheet, Sitara, BBB.
#define CM_PER 0x44E00000 // Page 179
#define CM_PER_LEN 0x00000400 // 1K
#define CM_PER_I2C2_CLKCTRL 0x00000044 // Page 1270


// Control Module Cfg 
#define I2C2 0x4819C000 // Page 183
#define I2C2_LEN 0x00001000 // 4k

// I2C Registers
#define I2C_IRQSTATUS 0x00000028      // Page 4612
#define I2C_IRQSTATUS_RRDY 0x00000008 // Page 4613
#define I2C_IRQSTATUS_XRDY 0x00000010 // Page 4613
#define I2C_IRQSTATUS_ARDY 0x00000004 // Page 4613
#define I2C_IRQSTATUS_RAW 0x00000024  // Page 4606
#define I2C_IRQENABLE_SET 0x0000002C  // Page 4614
#define I2C_IRQENABLE_CLR 0x00000030  // Page 4616
#define I2C_IRQENABLE_CLR_ACK 0x00000004
#define I2C_CNT 0x00000098  // Page 4632
#define I2C_DATA 0x0000009C // Page 4633

// Control Module cfg Page 180
#define CTRL_MODULE_BASE 0x44E10000
#define CTRL_MODULE_LEN 0x00002000        //
#define CTRL_MODULE_UART1_CTSN 0x00000978 //PIN 20 sda  Page 1461
#define CTRL_MODULE_UART1_RTSN 0x0000097C //PIN 19 scl  Page 1461

// I2C INIT
#define I2C_CON 0x000000A4 // Page 4634
#define I2C_CON_START 0x00000001 // Page 4636
#define I2C_CON_STOP 0x00000002  // Page 4636
#define I2C_OA 0x000000A8        // Page 4637
#define I2C_SA 0x000000AC        // Page 4638
#define I2C_PSC 0x000000B0 // Page 4639, SystemClock 48MHz
#define I2C_SCLL 0x000000B4 // Page 4640
#define I2C_SCLH 0x000000B8 // Page 4641
#define I2C_SYSC 0x00000010
