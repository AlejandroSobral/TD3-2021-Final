GLOBAL Keyboard_Buffer_Itself
GLOBAL Load_Keyboard_table_Itself
GLOBAL TIMER_COUNTER
GLOBAL Keyboard_counter

;Mem Section
SECTION .TABLE_KEYBOARD ; 
Keyboard_Buffer_Itself resb 19   ;
Keyboard_counter db 0x00; Count how many keys were pressed

SECTION .DATA_EXEC
Load_Keyboard_table_Itself resb 190 ; 
TIMER_COUNTER db 0x00
