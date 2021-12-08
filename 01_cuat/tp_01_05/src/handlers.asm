SECTION .kernel32

%include "inc/defines.h" 

GLOBAL EXCEPTION_DE     ; Tipo 0
GLOBAL EXCEPTION_DB     ; Tipo 1
GLOBAL EXCEPTION_NMI    ; Tipo 2
GLOBAL EXCEPTION_BE     ; Tipo 3
GLOBAL EXCEPTION_OF     ; Tipo 4
GLOBAL EXCEPTION_BR     ; Tipo 5
GLOBAL EXCEPTION_UD     ; Tipo 6
GLOBAL EXCEPTION_NM     ; Tipo 7
GLOBAL EXCEPTION_DF     ; Tipo 8
GLOBAL EXCEPTION_CoS    ; Tipo 9
GLOBAL EXCEPTION_TS     ; Tipo 10
GLOBAL EXCEPTION_NP     ; Tipo 11
GLOBAL EXCEPTION_SS     ; Tipo 12
GLOBAL EXCEPTION_GP     ; Tipo 13
GLOBAL EXCEPTION_PF     ; Tipo 14
GLOBAL EXCEPTION_MF     ; Tipo 16
GLOBAL EXCEPTION_AC     ; Tipo 17
GLOBAL EXCEPTION_MC     ; Tipo 18
GLOBAL EXCEPTION_XM     ; Tipo 19
GLOBAL IRQ00__Key_Handler

EXTERN __SYS_TABLES_IDT
EXTERN __SYS_TABLES_GDT
EXTERN DS_SEL
EXTERN IDT_handler_loader
EXTERN CS_SEL_32

%define PORT_A_8042    0x60
%define WRITE_OUT_8042 0xD1

EXCEPTION_DE:                   ; Divide Error Exception
    mov eax, 0x00
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_DE
    ret

EXCEPTION_DB:                   ; Debug Exception
    mov eax, 0x01
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_DB
    ret

EXCEPTION_NMI:                  ; Non maskable interrupt
    mov eax, 0x02
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_NMI
    ret

EXCEPTION_BE:                   ; Breakpoint Exception
    mov eax, 0x03
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_BE
    ret

EXCEPTION_OF:                   ; Overflow Exception
    mov eax, 0x04
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_OF
    ret

EXCEPTION_BR:                   ; Bound Range Exception
    mov eax, 0x05
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_BR
    ret

EXCEPTION_UD:                   ; Invalid Opcode Exception
    mov eax, 0x06
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_UD
    ret

EXCEPTION_NM:                   ; Device Not Available Exception
    mov eax, 0x07
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_NM
    ret

EXCEPTION_DF:                   ; Double Fault Exception
    mov eax, 0x08
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_DF
    ret

EXCEPTION_CoS:                   ; Coprocessor Segment Overrun Exception
    mov eax, 0x09
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_CoS
    ret

EXCEPTION_TS:                   ; Invalid TSS Exception
    mov eax, 0x0A
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_TS
    ret

EXCEPTION_NP:                   ; No Present Segment Exception
    mov eax, 0x0B
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_NP
    ret

EXCEPTION_SS:                   ; Stack Fault Exception
    mov eax, 0x0C
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_SS
    ret

EXCEPTION_GP:                   ; General Protection Fault Exception
    mov eax, 0x0D
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_GP
    ret

EXCEPTION_PF:                   ; Page Fault Exception
    mov eax, 0x0E
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_PF
    ret

EXCEPTION_MF:                   ; FPU Floating Point Error Exception
    mov eax, 0x10
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_MF
    ret

EXCEPTION_AC:                   ; Aligment Check Exception
    mov eax, 0x11
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_AC
    ret

EXCEPTION_MC:                   ; Machine Check Exception
    mov eax, 0x12
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_MC
    ret

EXCEPTION_XM:                   ; SIMD Floating Point Exception
    mov eax, 0x13
    mov edx, eax
    xchg bx,bx
    hlt
    jmp EXCEPTION_XM
    ret

IRQ00__Key_Handler:                   ; Keyboard IRQ Handler
    PUSHAD ; Push all general purp registers to stack

    in al, PORT_A_8042 ; Read key buffer
    mov bl, al      ; Store al value
    and al, al ; Compare signal between al & al
    JS End_Keyboard ;If the key was released, nothing to do

    cmp bl, TECLA_U
    je KEY_U

    cmp bl, TECLA_I
    je KEY_I

    cmp bl, TECLA_S
    je KEY_S

    cmp bl, TECLA_A
    je KEY_A

    xchg bx,bx

    jmp End_Keyboard




KEY_U:   ; #UP: Invalid Opcode fetch
    xchg bx,bx
    UD2
    jmp End_Keyboard 

KEY_I:   ;#GP General Protection Fault
    xchg bx,bx
    mov sp, 0x0;
    push eax;
    jmp End_Keyboard

KEY_S:   ;#DE Division error.
    xchg bx,bx
    mov edx,0
    mov eax,0x10
    mov esi,0
    div esi
    jmp End_Keyboard    

EXTERN __STACK_END_16
EXTERN DS_SEL_FAULT
EXTERN _gdtr_fault

KEY_A: ;#SS
    xchg bx,bx
    xor eax,eax
    lgdt [_gdtr_fault]
    add esp,16
    mov ax,DS_SEL_FAULT
    mov ss,ax

    

    jmp End_Keyboard


End_Keyboard:
    MOV al, 0x20 ;Send END of interrupt to PIC
    OUT 0x20, al
    POPAD ;Pop all general purp registers to stack
    iret