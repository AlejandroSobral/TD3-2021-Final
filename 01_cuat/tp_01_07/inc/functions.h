//Coding
#define OK_CODE 1
#define ERROR_CODE 0

//Buffer KEY & VIDEO
#define Keyb_buffer_size 16
#define Keyboard_Table_size 10
#define Keyboard_table_total_size Keyb_buffer_size*Keyboard_Table_size
#define VIDEO_BUFFER_SIZE 4000
#define ASCII_OFFSET_LETTERNUMBER 7

//My own definitions
typedef unsigned char byte;
typedef unsigned long bits32_v;
typedef unsigned short bits16_v;   
typedef unsigned long long bits64_v;//64 bits



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



//Keyboard protos.
void __Keyboard_Buffer_func( Keyboard_buffer*, byte);
void Load_KeyBoardTable(Table_Buffer*, Keyboard_buffer* );
void buffer_Clear(Keyboard_buffer* key_buffer);
byte buffer_Pop(Keyboard_buffer* key_buffer);
void _64bits_average_func(Table_Buffer*,_64bits_average* );
bits64_v division_64(bits64_v Addprom, bits16_v div);

//uP protos
byte __fast_memcpy_rom(   bits32_v*, bits32_v *,bits32_v);
byte __fast_memcpy(   bits32_v*, bits32_v *,bits32_v);
byte IDT_handler_loader(bits32_v *,bits32_v*,bits32_v *,bits32_v *,bits32_v *);
//Video
void Screen_Writing(Video_Buffer* , _64bits_average* , bits16_v , bits16_v );