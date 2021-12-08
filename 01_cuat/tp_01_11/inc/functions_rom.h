

//Coding
#define OK_CODE 1
#define ERROR_CODE 0

//Buffer KEY & VIDEO
#define Keyb_buffer_size 16
#define Keyboard_Table_size 10
#define Keyboard_table_total_size Keyb_buffer_size*Keyboard_Table_size
#define VIDEO_BUFFER_SIZE 4000
#define ASCII_OFFSET_LETTERNUMBER 7

//General string
#define MAX_LENGTH_STRING 50;

//My own definitions
typedef unsigned char byte;
typedef unsigned long bits32_v;
typedef unsigned short bits16_v;   
typedef unsigned long long bits64_v;//64 bits

extern long unsigned __DATA_VMA; //Set something at .bss
extern long unsigned __VIDEO_VMA;


//Paging ROM
bits32_v Get_Entry_DTP_rom(bits32_v ); // Get DTP Entry Add from VMA 31-22b
bits32_v Get_Entry_TP_rom(bits32_v ); // Get TP Entry Add from VMA 21-22b
void __load_DTP_entry_rom(bits32_v ,bits32_v ,byte ,byte ,byte ,byte ,byte ,byte ,byte );
void __load_TP_entry_rom(bits32_v,bits32_v, bits32_v, byte, byte, byte, byte, byte, byte, byte, byte, byte );
bits32_v LOAD_CR3_ROM (bits32_v init_dpt, byte _pcd, byte _pwt); //Set CR3 registers & attrbs
void set_dtp_pt_merged_rom (bits32_v init_phy_dtp, bits32_v VMA, bits32_v dir_PHY, byte ATR);