SECTION .sys_tables_progbits

%define BOOT_SEG 0xF0000
EXTERN  EXCEPTION_DUMMY
EXTERN __SYS_TABLES_LMA
GLOBAL  CS_SEL_16
GLOBAL  CS_SEL_32
GLOBAL CS_SEL_11
GLOBAL DS_SEL_11
GLOBAL  DS_SEL
GLOBAL TSS_SEL
GLOBAL gdtr_32
GLOBAL gdtr_16

SECTION .sys_tables_progbits

%define BOOT_SEG 0xF0000

;https://en.wikipedia.org/wiki/Global_Descriptor_Table#/media/File:SegmentDescriptor.svg
;https://wiki.osdev.org/GDT_Tutorial

GDT:
NULL_SEL    equ $-GDT
    dq 0x0
CS_SEL_32   equ $-GDT
    dw 0xFFFF       ;Limit 15-0
    dw 0x0000       ;Base 15-0
    db 0x00         ;Base 23-16
    db 10011001b    ;Attributes:
                    ;P
                    ;DPL
                    ;S
                    ;D/C
                    ;ED/C
                    ;R/w
                    ;A
    db 11001111b    ;Limit
                    ;G
                    ;D/B
                    ;L
                    ;AVL
    db 0x00         ;Base
DS_SEL   equ $-GDT
    dw 0xFFFF       ;Limit 15-0
    dw 0x0000       ;Base 15-0
    db 0x00         ;Base 23-16
    db 10010010b    ;Attributes:
                    ;P
                    ;DPL
                    ;S
                    ;D/C
                    ;ED/C
                    ;R/w
                    ;A
    db 11001111b    ;Limit
                    ;G
                    ;D/B
                    ;L
                    ;AVL
    db 0x00         ;Base

CS_SEL_11 equ $-GDT          
    dw  0xFFFF               
    dw  0                    
    db  0                    
    db  0xFA                 
    db  0xCF                 
    db  0x00                 

DS_SEL_11 equ $-GDT          
    dw  0xFFFF               
    dw  0                    
    db  0                    
    db  0xF2                 
    db  0xCF                 
    db  0x00  

TSS_SEL equ $-GDT          
    dw  0x0067             
    dw  0x1000             
    db  0                  
    db  10001001b          
    db  01000000b          
    db  0                  
GDT_LENGTH EQU $-GDT


gdtr_32:
    dw GDT_LENGTH-1
    dd GDT


     

