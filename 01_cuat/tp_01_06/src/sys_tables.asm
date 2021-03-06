EXTERN  EXCEPTION_DUMMY
GLOBAL  CS_SEL_16
GLOBAL  CS_SEL_32
GLOBAL  DS_SEL
GLOBAL  _gdtr
GLOBAL _idtr
GLOBAL _gdtr_fault

SECTION .sys_tables_progbits

%define BOOT_SEG 0xF0000
EXTERN  EXCEPTION_DUMMY
EXTERN __SYS_TABLES_LMA
GLOBAL  CS_SEL_16
GLOBAL  CS_SEL_32
GLOBAL  DS_SEL
GLOBAL  _gdtr

SECTION .sys_tables_progbits

%define BOOT_SEG 0xF0000



GDT:
NULL_SEL    equ $-GDT
    dq 0x0
CS_SEL_16   equ $-GDT
    dw 0xFFFF           ;Limit 15-0
    dw 0x0000         ;Base 15-0
    db 0xFF         ;Base 23-16
    db 10011001b         ;Attributes:
                ;P
                ;DPL
                ;S
                ;D/C
                ;ED/C
                ;R/w
                ;A
    db 01000000b         ;Limit
                ;G
                ;D/B
                ;L
                ;AVL
    db 0xFF         ;Base
CS_SEL_32   equ $-GDT
    dw 0xFFFF         ;Limit 15-0
    dw 0x0000         ;Base 15-0
    db 0x00         ;Base 23-16
    db 10011001b         ;Attributes:
                ;P
                ;DPL
                ;S
                ;D/C
                ;ED/C
                ;R/w
                ;A
    db 11001111b         ;Limit
                ;G
                ;D/B
                ;L
                ;AVL
    db 0x00         ;Base
DS_SEL   equ $-GDT
    dw 0xFFFF         ;Limit 15-0
    dw 0x0000         ;Base 15-0
    db 0x00         ;Base 23-16
    db 10010010b         ;Attributes:
                ;P
                ;DPL
                ;S
                ;D/C
                ;ED/C
                ;R/w
                ;A
    db 11001111b         ;Limit
                ;G
                ;D/B
                ;L
                ;AVL
    db 0x00         ;Base
GDT_LENGTH EQU $-GDT


_gdtr:
    dw GDT_LENGTH-1
    dd __SYS_TABLES_LMA



GLOBAL  CS_SEL_16_FAULT
GLOBAL  CS_SEL_32_FAULT
GLOBAL  DS_SEL_FAULT

GDT_FAULT:

CS_SEL_16_FAULT   equ $-GDT_FAULT
    dw 0xFFFF           ;Limit 15-0
    dw 0x0000         ;Base 15-0
    db 0xFF         ;Base 23-16
    db 11111111b         ;Attributes:
                ;P
                ;DPL
                ;S
                ;D/C
                ;ED/C
                ;R/w
                ;A
    db 01000000b         ;Limit
                ;G
                ;D/B
                ;L
                ;AVL
    db 0xFF         ;Base
CS_SEL_32_FAULT   equ $-GDT_FAULT
    dw 0xFFFF         ;Limit 15-0
    dw 0x0000         ;Base 15-0
    db 0x00         ;Base 23-16
    db 11111001b         ;Attributes:
                ;P
                ;DPL
                ;S
                ;D/C
                ;ED/C
                ;R/w
                ;A
    db 11001111b         ;Limit
                ;G
                ;D/B
                ;L
                ;AVL
    db 0x00         ;Base
DS_SEL_FAULT   equ $-GDT_FAULT
    dw 0xFFFF         ;Limit 15-0
    dw 0x0000         ;Base 15-0
    db 0x00         ;Base 23-16
    db 11111110b         ;Attributes:
                ;P
                ;DPL
                ;S
                ;D/C
                ;ED/C
                ;R/w
                ;A
    db 11001111b         ;Limit
                ;G
                ;D/B
                ;L
                ;AVL
    db 0x00         ;Base
GDT_LENGTH_FAULT EQU $-GDT_FAULT

_gdtr_fault:
    dw GDT_LENGTH-1
    dd 0xFFFFFFFFF