

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

wait_for_key:
        nop
        jmp wait_for_key ; Waiting for interrupts endless cycle




kernel32_end: