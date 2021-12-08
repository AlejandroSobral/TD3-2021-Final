GLOBAL Keyboard_Buffer_Itself
GLOBAL Load_Keyboard_table_Itself
GLOBAL TIMER_COUNTER
GLOBAL Keyboard_counter
GLOBAL Digit_Table_Average
GLOBAL Screen_pointer
GLOBAL Flag_Task_1

;Mem Section
SECTION .TABLE_KEYBOARD
Load_Keyboard_table_Itself resb 190 ;
Keyboard_Buffer_Itself resb 19   ;
Keyboard_counter db 0x00; Count how many keys were pressed
 
SECTION .__DATA__
TIMER_COUNTER db 0x00
Screen_pointer resb 4; 
Digit_Table_Average resb 19 ;
Flag_Task_1 db 0x00
