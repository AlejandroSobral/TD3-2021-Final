

section .kernel32
USE32
GLOBAL kernel32_code_size
GLOBAL kernel32_init

EXTERN __SYS_TABLES_IDT
EXTERN __SYS_TABLES_GDT

;Global Variables
EXTERN buffer_Clear
EXTERN Keyboard_Buffer_Itself
EXTERN Load_Keyboard_table_Itself
EXTERN _64bits_average_func
EXTERN Screen_Writing
EXTERN Screen_pointer
EXTERN Digit_Table_Average
EXTERN Flag_Task_1;
VIDEO_BUFFER_ADDR EQU 0x000B8000
;Function references
EXTERN init_timer0

GDT_LENGTH EQU (4); 4 descriptors of 32kb each one


kernel32_code_size EQU (kernel32_end-kernel32_init)

_idtr   dw ((0x21*8)+(0x2*8))
        dd __SYS_TABLES_IDT

_gdtr   dw (4*8)-1;4 descriptors of 32kb each one
        dd __SYS_TABLES_GDT

kernel32_init:


    lidt[_idtr] ;Load IDT
    lgdt [_gdtr];Load GDT
    call init_timer0; Init Timer Channel 0 after setting the IDT table

    push dword Keyboard_Buffer_Itself; Clear the keyboard buffer before start
    call buffer_Clear;
    push dword Load_Keyboard_table_Itself; Clear the keyboard table buffer before start
    call buffer_Clear;
 
    xchg bx,bx
    sti; Set on interrupts

wait_for_flag:
    mov eax, dword [Flag_Task_1]
    cmp eax, 0x01;
    je Average_on;
    jmp wait_for_flag; No task
    nop

Average_on:
    mov eax, 0x00
    mov dword [Flag_Task_1], eax;Reset task flag

    mov eax, VIDEO_BUFFER_ADDR
    mov [Screen_pointer],eax;  Reload the screen pointer    

    push dword Digit_Table_Average
    push dword Load_Keyboard_table_Itself
    call _64bits_average_func
    add esp,8
 

    push 64 
    push 0     
    push dword Digit_Table_Average     
    push dword [Screen_pointer]
    call Screen_Writing
    add esp, 16        
    jmp wait_for_flag ; Waiting for interrupts endless cycle

kernel32_end: