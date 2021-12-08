
;; CHECK P. 101 de los PDF de paginacion
section .kernel32
USE32
GLOBAL kernel32_code_size
GLOBAL kernel32_init
GLOBAL kernel32_loop

EXTERN __SYS_TABLES_IDT
EXTERN __SYS_TABLES_GDT

;Global Variables
EXTERN buffer_Clear
EXTERN KEYBOARD_BUFFER_ITSELF
EXTERN DIGIT_TABLE_KERNEL
EXTERN _64BITS_AVERAGE_FUNC
EXTERN SCREEN_WRITING
EXTERN SCREEN_POINTER
EXTERN DIGIT_TABLE_AVERAGE
VIDEO_BUFFER_ADDR EQU 0x000B8000
;Function references
EXTERN init_timer0
EXTERN task01

kernel32_code_size EQU (kernel32_end-kernel32_init)



kernel32_init:

    sti; 

kernel32_loop:
    hlt
    jmp kernel32_loop ; Waiting for interrupts endless cycle

kernel32_end: