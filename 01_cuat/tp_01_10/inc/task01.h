#include "../inc/functions.h"

void __Keyboard_Buffer_func( Keyboard_buffer*, byte);
void Load_KeyBoardTable(Table_Buffer*, Keyboard_buffer* );
void buffer_Clear(Keyboard_buffer* key_buffer);
byte buffer_Pop(Keyboard_buffer* key_buffer);
void _64bits_average_func(Table_Buffer*,_64bits_average* );
bits64_v division_64(bits64_v Addprom, bits16_v div);


const byte global_rodata = 1; //.rodata