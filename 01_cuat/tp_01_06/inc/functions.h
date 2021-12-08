#define ERROR_DEFECTO 0
#define EXITO 1
#define Keyb_buffer_size 16
#define Keyboard_Table_size 10

typedef unsigned char byte;
typedef unsigned long dword;

byte __fast_memcpy_rom(   dword*, dword *,dword);
byte __fast_memcpy(   dword*, dword *,dword);
byte IDT_handler_loader(dword *,dword *cs,dword *,dword *,dword *);

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
    bits64_v table[Keyboard_Table_size];
    byte table_index;

}Table_Buffer;

void __Keyboard_Buffer_func( Keyboard_buffer*, byte);
void Load_KeyBoardTable(Table_Buffer*, Keyboard_buffer* );
void buffer_Clear(Keyboard_buffer* key_buffer);
byte buffer_Pop(Keyboard_buffer* key_buffer); 