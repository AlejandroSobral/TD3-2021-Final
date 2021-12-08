EXTERN  IDT_handler_loader
EXTERN CS_SEL_32
EXTERN __SYS_TABLES_IDT


; Exceptions & Interrupt labeling;
EXTERN EXCEPTION_DE     ;0
EXTERN EXCEPTION_DB     ;1
EXTERN EXCEPTION_NMI    ;2
EXTERN EXCEPTION_BE     ;3
EXTERN EXCEPTION_OF     ;4
EXTERN EXCEPTION_BR     ;5
EXTERN EXCEPTION_UD     ;6
EXTERN EXCEPTION_NM     ;7
EXTERN EXCEPTION_DF     ;8
EXTERN EXCEPTION_CoS    ;9
EXTERN EXCEPTION_TS     ;10
EXTERN EXCEPTION_NP     ;11
EXTERN EXCEPTION_SS     ;12
EXTERN EXCEPTION_GP     ;13
EXTERN EXCEPTION_PF     ;14
EXTERN EXCEPTION_MF     ;16
EXTERN EXCEPTION_AC     ;17
EXTERN EXCEPTION_MC     ;18
EXTERN EXCEPTION_XM     ;19
EXTERN IRQ00__Key_Handler;
EXTERN IRQ01__TIMER0;

;IDT Attributes
ATTR_EXC EQU 0x0000008F
ATTR_INT EQU 0x0000008E

section .init_IDT

GLOBAL init_IDT
init_IDT:


; Divide Error Exception #DE 
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_DE)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x00)                ; Excp. Number
    call IDT_handler_loader
    leave


 ; Debug #DB
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_DB)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x01)                ; Excp. Number
    call IDT_handler_loader
    leave

 ;  #NMI 
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)     ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_NMI)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x02)                ; Excp. Number
    call IDT_handler_loader
    leave

 ; #BE
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_BE)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x03)                ; Excp. Number
    call IDT_handler_loader
    leave
 
 ; #OF 
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_OF)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x04)                ; Excp. Number
    call IDT_handler_loader
    leave

;  #BR 
    push ebp
    mov ebp, esp    ;enter

    push dword(__SYS_TABLES_IDT)     ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_BR)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x05)                ; Excp. Number
    call IDT_handler_loader
    leave

 ; #UD
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)     ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_UD)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x06)                ; Excp. Number
    call IDT_handler_loader
    leave

 ;  #NM
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)     ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_NM)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x07)                ; Excp. Number
    call IDT_handler_loader
    leave

  ; #DF 
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_DF)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x08)                ; Excp. Number
    call IDT_handler_loader
    leave

 ; #DB
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_CoS)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x09)                ; Excp. Number
    call IDT_handler_loader
    leave

 ; #TS
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_TS)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x0A)                ; Excp. Number
    call IDT_handler_loader
    leave

 ; #NP
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_NP)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x0B)                ; Excp. Number
    call IDT_handler_loader
    leave
 
 ; #SS
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_SS)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x0C)                ; Excp. Number
    call IDT_handler_loader
    leave

 ; #GP
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_GP)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x0D)                ; Excp. Number
    call IDT_handler_loader
    leave

;  #PF
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_PF)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x0E)                ; Excp. Number
    call IDT_handler_loader
    leave

 ; #MF
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_MF)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x10)                ; Excp. Number
    call IDT_handler_loader
    leave

; #AC
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_AC)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x11)                ; Excp. Number
    call IDT_handler_loader
    leave

; #MC
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_MC)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x12)                ; Excp. Number
    call IDT_handler_loader
    leave

 ; #XM
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)    ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(EXCEPTION_XM)        ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x13)                ; Excp. Number
    call IDT_handler_loader
    leave

     ;Load IDT w/  Keyboard handler 
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)     ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(IRQ00__Key_Handler)  ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x21)                ; Excp. Number
    call IDT_handler_loader
    leave


   ;Load IDT w/ Timer0 Handler 

    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; IDT Addres
    push dword(ATTR_EXC)            ; Attributes
    push dword(IRQ01__TIMER0)  ;Function offset - address at lma
    push dword(CS_SEL_32)           ; Section w/ it belong
    push dword(0x20)                ; Excp. Number
    call IDT_handler_loader

    leave


    
ret

    