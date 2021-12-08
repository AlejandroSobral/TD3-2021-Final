void initMPU6050(void);
void MyWriteByte(uint8_t value, uint8_t registers, uint8_t OPERATION);
uint8_t MyReadByte(void);

#define READ_OP 2
#define WRITE_OP 1


/* MPU6050 */
/*
        Register Name       Addr            Serial    |  Bit7  |  Bit6  |  Bit5  |  Bit4  |  Bit3  |  Bit2  |  Bit1  |  Bit0  |
                            (Hex)           I/F
*/
#define SELF_TEST_X 0x0D  // R/W    |     XA_TEST[4-2]         |              XG_TEST[4-0]                  |
#define SELF_TEST_Y 0x0E  // R/W    |     YA_TEST[4-2]         |              YG_TEST[4-0]                  |
#define SELF_TEST_Z 0x0F  // R/W    |     ZA_TEST[4-2]         |              ZG_TEST[4-0]                  |
#define SELF_TEST_A 0x10  // R/W    |     RESERVED    |   XA_TEST[1-0]  |  YA_TEST[1-0]  |  ZA_TEST[1-0]    |
#define SMPLRT_DIV 0x19   // R/W    |                         SMPLRT_DIV[7:0]                               |
#define CONFIG 0x1A       // R/W    |    -   |   -    | EXT_SYNC_SET[2:0]        |     DLPF_CFG[2:0]        |
#define GYRO_CONFIG 0x1B  // R/W    |    -   |   -    |   -    |   FS_SEL [1:0]  |   -    |   -    |   -    |
#define ACCEL_CONFIG 0x1C // R/W    | XA_ST  | YA_ST  |  ZA_ST |   AFS_SEL[1:0]  |   -    |   -    |   -    |

#define FIFO_EN 0x23 // R/W    | TEMP   |   XG   |   YG   |   ZG   | ACCEL  |  SLV2  |  SLV1  |  SLV0  | 
                     //        |_FIFO_EN|_FIFO_EN|_FIFO_EN|_FIFO_EN|_FIFO_EN|_FIFO_EN|_FIFO_EN|_FIFO_EN|


#define INT_PIN_CFG 0x37 // R/W    |INT_LEVEL|INT_OPEN| LATCH | INT_RD | FSYNC_ |  FSYNC |  I2C   |   -    | 
                         //        |    -   |   -    | _INT_EN| _CLEAR |INT_LEVEL|_INT_EN|_BYPASS_EN|   -    |

#define INT_ENABLE 0x38 // R/W    |    -   |   -    |   -    |  FIFO  | I2C_MST |   -    |   -    | DATA   | 
                        //        |    -   |   -    |   -    |_OFLOW_EN| _INT_EN|   -    |   -    | _RDY_EN|
#define ACCEL_XOUT_H 0x3B // R      |                             ACCEL_XOUT[15:8]                          |
#define ACCEL_XOUT_L 0x3C // R      |                             ACCEL_XOUT[7:0]                           |
#define ACCEL_YOUT_H 0x3D // R      |                             ACCEL_YOUT[15:8]                          |
#define ACCEL_YOUT_L 0x3E // R      |                             ACCEL_YOUT[7:0]                           |
#define ACCEL_ZOUT_H 0x3F // R      |                             ACCEL_ZOUT[15:8]                          |
#define ACCEL_ZOUT_L 0x40 // R      |                             ACCEL_ZOUT[7:0]                           |
#define TEMP_OUT_H 0x41   // R      |                             TEMP_OUT[15:8]                            |
#define TEMP_OUT_L 0x42   // R      |                             TEMP_OUT[7:0]                             |
#define GYRO_XOUT_H 0x43  // R      |                             GYRO_XOUT[15:8]                           |
#define GYRO_XOUT_L 0x44  // R      |                             GYRO_XOUT[7:0]                            |
#define GYRO_YOUT_H 0x45  // R      |                             GYRO_YOUT[15:8]                           |
#define GYRO_YOUT_L 0x46  // R      |                             GYRO_YOUT[7:0]                            |
#define GYRO_ZOUT_H 0x47  // R      |                             GYRO_ZOUT[15:8]                           |
#define GYRO_ZOUT_L 0x48  // R      |                             GYRO_ZOUT[7:0]                            |

#define SLAVE0_ADDR 0x68 // R/W    |    -   |   -    |   -    |   -    |   -    |  GYRO  |  ACCEL | TEMP   | 
                               //                          |        |        |        | _RESET | _RESET | _RESET |
#define USER_CTRL 0x6A // R/W    |    -   | FIFO_EN| 2C_MST |  2C_IF |   -    |  FIFO  | I2C_MST|SIG_COND| 
                       //                          |   _EN  |  _DIS  |        | _RESET | _RESET | _RESET |
#define PWR_MGMT_1 0x6B // R/W    | DEVICE |  SLEEP |  CYCLE |   -    |TEMP_DIS|        CLKSEL[2:0]       | 
                        //        | _RESET |
#define FIFO_COUNTH 0x72 // R/W    |                             FIFO_COUNT[15:8]                          |
#define FIFO_COUNTL 0x73 // R/W    |                             FIFO_COUNT[7:0]                           |
#define FIFO_R_W 0x74    // R/W    |                             FIFO_DATA[7:0]                            |
#define WHO_AM_I 0x75    // R      |    -   |                     WHO_AM_I[6:1]                   |   -    |


enum Ascale
{
	AFS_2G = 0,
	AFS_4G,
	AFS_8G,
	AFS_16G
};

enum Gscale
{
	GFS_250DPS = 0,
	GFS_500DPS,
	GFS_1000DPS,
	GFS_2000DPS
};

enum Aaxis
{
	AXIS_X = 1,
	AXIS_Y,
	AXIS_Z
};