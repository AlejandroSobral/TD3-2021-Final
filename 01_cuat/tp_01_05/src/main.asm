section .kernel32
USE32
GLOBAL kernel32_code_size
GLOBAL kernel32_init
EXTERN __SYS_TABLES_IDT
EXTERN __SYS_TABLES_GDT
GDT_LENGTH EQU (4); 4 descriptors of 32kb each one


kernel32_code_size EQU (kernel32_end-kernel32_init)

_idtr   dw (34*8)-1
        dd __SYS_TABLES_IDT

_gdtr   dw (4*8)-1;4 descriptors of 32kb each one
        dd __SYS_TABLES_GDT

kernel32_init:


    lidt[_idtr];

    lgdt [_gdtr]
    xchg bx,bx
     sti; PRENDE LAS INTERUPCIONES SINO NO FUNCIONA CAPOOO
wait_for_key:
        nop
        jmp wait_for_key ; Waiting for interrupts endless cycle




kernel32_end: