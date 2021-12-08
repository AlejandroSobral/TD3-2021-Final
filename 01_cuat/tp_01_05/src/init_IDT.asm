EXTERN  IDT_handler_loader
EXTERN CS_SEL_32
EXTERN __SYS_TABLES_IDT


EXTERN EXCEPTION_DE     ; Tipo 0
EXTERN EXCEPTION_DB     ; Tipo 1
EXTERN EXCEPTION_NMI    ; Tipo 2
EXTERN EXCEPTION_BE     ; Tipo 3
EXTERN EXCEPTION_OF     ; Tipo 4
EXTERN EXCEPTION_BR     ; Tipo 5
EXTERN EXCEPTION_UD     ; Tipo 6
EXTERN EXCEPTION_NM     ; Tipo 7
EXTERN EXCEPTION_DF     ; Tipo 8
EXTERN EXCEPTION_CoS    ; Tipo 9
EXTERN EXCEPTION_TS     ; Tipo 10
EXTERN EXCEPTION_NP     ; Tipo 11
EXTERN EXCEPTION_SS     ; Tipo 12
EXTERN EXCEPTION_GP     ; Tipo 13
EXTERN EXCEPTION_PF     ; Tipo 14
EXTERN EXCEPTION_MF     ; Tipo 16
EXTERN EXCEPTION_AC     ; Tipo 17
EXTERN EXCEPTION_MC     ; Tipo 18
EXTERN EXCEPTION_XM     ; Tipo 19
EXTERN IRQ00__Key_Handler;


ATTR_EXC EQU 0x0000008F
ATTR_INT EQU 0x0000008E

section .init_IDT

GLOBAL init_IDT

init_IDT:


; --> Cargar la IDT con Divide Error Exception #DE (TIPO 0) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_DE)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x00)                ; Numero de excepción
    call IDT_handler_loader
    leave


 ; --> Cargar la IDT con Debug #DB (TIPO 1) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_DB)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x01)                ; Numero de excepción
    call IDT_handler_loader
    leave

 ; --> Cargar la IDT con ? #NMI (TIPO 2) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_NMI)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x02)                ; Numero de excepción
    call IDT_handler_loader
    leave

 ; --> Cargar la IDT con ? #BE (TIPO 3) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_BE)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x03)                ; Numero de excepción
    call IDT_handler_loader
    leave
 
 ; --> Cargar la IDT con ? #OF (TIPO 4) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_OF)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x04)                ; Numero de excepción
    call IDT_handler_loader
    leave

; --> Cargar la IDT con Rango de instrucción BOUND excedido #BR (TIPO 5) <--
    push ebp
    mov ebp, esp    ;enter

    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_BR)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x05)                ; Numero de excepción
    call IDT_handler_loader
    leave

 ; --> Cargar la IDT con Invalid Opcode #UD (TIPO 6) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_UD)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x06)                ; Numero de excepción
    call IDT_handler_loader
    leave

 ; --> Cargar la IDT con Device not found #NM (TIPO 7) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_NM)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x07)                ; Numero de excepción
    call IDT_handler_loader
    leave

  ; --> Cargar la IDT con Double Fault Exception #DF (TIPO 8) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_DF)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x08)                ; Numero de excepción
    call IDT_handler_loader
    leave

 ; --> Cargar la IDT con Divide Error Exception #DB (TIPO 9) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_CoS)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x09)                ; Numero de excepción
    call IDT_handler_loader
    leave

 ; --> Cargar la IDT con TSS invalido #TS (TIPO 10) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_TS)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x0A)                ; Numero de excepción
    call IDT_handler_loader
    leave

 ; --> Cargar la IDT con Segmento no presente #NP (TIPO 11) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_NP)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x0B)                ; Numero de excepción
    call IDT_handler_loader
    leave
 
 ; --> Cargar la IDT con Stack Fault Exception #SS (TIPO 12) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_SS)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x0C)                ; Numero de excepción
    call IDT_handler_loader
    leave

 ; --> Cargar la IDT con General Protection Exception #GP (TIPO 13) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_GP)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x0D)                ; Numero de excepción
    call IDT_handler_loader
    leave

 ; --> Cargar la IDT con Page Fault Exception #PF (TIPO 14) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_PF)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x0E)                ; Numero de excepción
    call IDT_handler_loader
    leave

 ; --> Cargar la IDT con Error matemarico x87 #MF (TIPO 16) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_MF)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x10)                ; Numero de excepción
    call IDT_handler_loader
    leave

 ; --> Cargar la IDT con Error de alineación #AC (TIPO 17) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_AC)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x11)                ; Numero de excepción
    call IDT_handler_loader
    leave

 ; --> Cargar la IDT con ? #MC (TIPO 18) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_MC)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x12)                ; Numero de excepción
    call IDT_handler_loader
    leave

 ; --> Cargar la IDT con Exception float SIMD #XM (TIPO 19) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(EXCEPTION_XM)        ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x13)                ; Numero de excepción
    call IDT_handler_loader
    leave

     ; --> Cargar la IDT con Exception float SIMD #XM (TIPO 19) <--
    push ebp
    mov ebp, esp    ;enter
    push dword(__SYS_TABLES_IDT)               ; Dirección de la IDT
    push dword(ATTR_EXC)            ; Atributos
    push dword(IRQ00__Key_Handler)  ; Offset de la función que atiende la excepción (dirección)
    push dword(CS_SEL_32)           ; Segmento de la función que atiende la excepción
    push dword(0x21)                ; Numero de excepción
    call IDT_handler_loader
    leave






    
ret

    