
%define PORT_A_8042    0x60
%define CTRL_PORT_8042 0x64
%define KEYB_DIS       0xAD
%define KEYB_EN        0xAE
%define READ_OUT_8042  0xD0
%define WRITE_OUT_8042 0xD1


%define _KEY_1     0x02
%define _KEY_2     0x03
%define _KEY_3     0x04
%define _KEY_4     0x05
%define _KEY_5     0x06
%define _KEY_6     0x07
%define _KEY_7     0x08
%define _KEY_8     0x09
%define _KEY_9     0x0A
%define _KEY_0     0x0B

%define _KEY_ENTER 0x1C

%define _KEY_A     0x1E
%define _KEY_B     0x30
%define _KEY_C     0x2E
%define _KEY_D     0x20
%define _KEY_E     0x12
%define _KEY_F     0x21
%define _KEY_G     0x22
%define _KEY_H     0x23
%define _KEY_I     0x17
%define _KEY_J     0x24
%define _KEY_K     0x25
%define _KEY_L     0x26
%define _KEY_M     0x32
%define _KEY_N     0x31
%define _KEY_O     0x18
%define _KEY_P     0x19
%define _KEY_Q     0x10
%define _KEY_R     0x13
%define _KEY_S     0x1F
%define _KEY_T     0x14
%define _KEY_U     0x16
%define _KEY_V     0x2F
%define _KEY_W     0x11
%define _KEY_X     0x2D
%define _KEY_Y     0x15
%define _KEY_Z     0x2C

SYS_CALL_HALT     EQU     0
SYS_CALL_READ     EQU     1
SYS_CALL_WRITE    EQU     2
SYS_CALL_SCREEN   EQU     3

 