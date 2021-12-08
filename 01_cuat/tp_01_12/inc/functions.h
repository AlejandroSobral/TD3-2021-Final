//Coding
#define OK_CODE 1
#define ERROR_CODE 0
#define MAX_VALUE 0xFFFFFFFFFFFFFFFF
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

typedef struct Keyboard_buffer
{
    byte Buffer_info[Keyb_buffer_size]; //Keyboard buffer
    byte Loaded_elements; // Number of incoming numbers
    byte in_index;   // In index...
    byte out_index; //  Out index.. for further implementations
}Keyboard_buffer;

typedef struct Table_Buffer
{
    bits64_v table[Keyboard_table_total_size];
    byte table_index;

}Table_Buffer;

typedef struct _64bits_average
{
    bits64_v avrg;
    bits64_v Add;
    bits64_v aux;
}_64bits_average;

typedef struct Video_Buffer
{
    byte buffer[VIDEO_BUFFER_SIZE];    
}Video_Buffer;


//uP protos
byte __fast_memcpy_rom(   bits32_v*, bits32_v *,bits32_v);
byte __fast_memcpy(   bits32_v*, bits32_v *,bits32_v);
byte IDT_handler_loader(bits32_v *,bits32_v*,bits32_v *,bits32_v *,bits32_v *);
//Video
void Screen_Writing(Video_Buffer* , _64bits_average* , bits16_v , bits16_v );
bits32_v Screen_write_string (char* );
bits32_v __screen_writing_pf (bits16_v error_code);

//DATA
void Load_KeyBoardTable(Table_Buffer*, Keyboard_buffer* );
void buffer_Clear(Keyboard_buffer* key_buffer);
byte buffer_Pop(Keyboard_buffer* key_buffer);

//Paging
bits32_v Get_Entry_DTP(bits32_v ); // Get DTP Entry Add from VMA 31-22b
bits32_v Get_Entry_TP(bits32_v ); // Get TP Entry Add from VMA 21-22b
void __load_DTP_entry(bits32_v ,bits32_v ,byte ,byte ,byte ,byte ,byte ,byte ,byte );
void __load_TP_entry(bits32_v,bits32_v, bits32_v, byte, byte, byte, byte, byte, byte, byte, byte, byte );
bits32_v LOAD_CR3 (bits32_v init_dpt, byte _pcd, byte _pwt); //Set CR3 registers & attrbs





             
     
      
     
     
     
     
     
     
     
     
     
      
     
    
