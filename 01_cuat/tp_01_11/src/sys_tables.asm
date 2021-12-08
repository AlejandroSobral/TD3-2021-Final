SECTION .sys_tables_progbits

%define BOOT_SEG 0xF0000
EXTERN  EXCEPTION_DUMMY
EXTERN __SYS_TABLES_LMA
GLOBAL  CS_SEL_16
GLOBAL  CS_SEL_32
GLOBAL  DS_SEL
GLOBAL TSS_SEL
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

TSS_SEL equ $-GDT          ;Base 0x00001000 Limite 0x00000067
    dw  0x0067                          ;Limite del segmento(bits 15 -0)
    dw  0x1000                          ;Base del segmento(bits 15-0)
    db  0                               ;Base del segmento(bits 23-16)
    db  10001001b                       ;P=1 / DPL=00 / bit3=1 seg.cod/bit2=0/bit1=1 (R/W)
    db  01000000b                       ;G=0/D=1 32 bits/Limite(bits 19:16)
    db  0                               ;Base del segmento(bits 31-24)     
GDT_LENGTH EQU $-GDT


_gdtr:
    dw GDT_LENGTH-1
    dd __SYS_TABLES_LMA



