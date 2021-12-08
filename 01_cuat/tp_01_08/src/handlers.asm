SECTION .ISR_AND_KEYBOARD

%include "inc/defines.h" 

EXTERN __Keyboard_Buffer_func
EXTERN Keyboard_Buffer_Itself
EXTERN Load_KeyBoardTable
EXTERN Load_Keyboard_table_Itself
EXTERN Keyboard_counter
EXTERN Flag_Task_1

Key_times_to_load EQU 16

GLOBAL EXCEPTION_DE     ; 0
GLOBAL EXCEPTION_DB     ; 1
GLOBAL EXCEPTION_NMI    ; 2
GLOBAL EXCEPTION_BE     ; 3
GLOBAL EXCEPTION_OF     ; 4
GLOBAL EXCEPTION_BR     ; 5
GLOBAL EXCEPTION_UD     ; 6
GLOBAL EXCEPTION_NM     ; 7
GLOBAL EXCEPTION_DF     ; 8
GLOBAL EXCEPTION_CoS    ; 9
GLOBAL EXCEPTION_TS     ; 10
GLOBAL EXCEPTION_NP     ; 11
GLOBAL EXCEPTION_SS     ; 12
GLOBAL EXCEPTION_GP     ; 13
GLOBAL EXCEPTION_PF     ; 14
GLOBAL EXCEPTION_MF     ; 16
GLOBAL EXCEPTION_AC     ; 17
GLOBAL EXCEPTION_MC     ; 18
GLOBAL EXCEPTION_XM     ; 19
GLOBAL IRQ00__Key_Handler
GLOBAL IRQ01__TIMER0

EXTERN __SYS_TABLES_IDT
EXTERN __SYS_TABLES_GDT
EXTERN DS_SEL
EXTERN IDT_handler_loader
EXTERN CS_SEL_32
EXTERN TIMER_COUNTER

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


;https://xem.github.io/minix86/manual/intel-x86-and-64-manual-vol3/o_fe12b1e2a880e0ce-227.html
    ; CR2 content
    ; Bit0 -> Present -> 0 = Non-present page
    ; Bit0 -> Present -> 1 = Page-level protection violation
    ; Bit1 -> W/R     -> 0 = Access causing the fault was a read
    ; Bit1 -> W/R     -> 1 = Access causing the fault was a write
    ; Bit2 -> U/S     -> 0 = A Supervisor-mode access caused the fault
    ; Bit2 -> U/S     -> 1 = A User-mode access caused the fault
    ; Bit3 -> RSVD    -> 0 = Fault was not caused by reserved bit violation
    ; Bit4 -> RSVD    -> 1 = Fault was caused by a reserv bit set to 1 in some paging structure entry.
    ; Bit5 -> I/D     -> 0 = Fault not caused by an instruction fetch
    ; Bit5 -> I/D     -> 1 = Fault caused by an instruction fecth
    cli                 ;                                     
    push eax            ;guardo eax
    mov eax,cr2         ;Check CR2
    and eax, 0x0F       ;Mask to take B4-B0
    cmp eax,0           ; Cmp according upper info          
    je PF_P                                           
    cmp eax,1                
    je PF_RW                                        
    cmp eax,2           
    je PF_US                                    
    cmp eax,4                                      
    je PF_ID
PF_P:
    xchg bx,bx
    
PF_RW:
    xchg bx,bx
    
PF_US:
    xchg bx,bx
    
PF_ID:
    xchg bx,bx
    
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
    
    mov dword ecx, [Keyboard_counter]
    inc ecx
    mov dword [Keyboard_counter], ecx ; Store the Keyboard_counter
    cmp cx, Key_times_to_load; #Compare with 17

    JE Buffer_full;

    cmp bl, TECLA_0
    je K_0

    cmp bl, TECLA_1
    je K_1

    cmp bl, TECLA_2
    je K_2

    cmp bl, TECLA_3
    je K_3

    cmp bl, TECLA_4
    je K_4

    cmp bl, TECLA_5
    je K_5

    cmp bl, TECLA_6
    je K_6

    cmp bl, TECLA_7
    je K_7

    cmp bl, TECLA_8
    je K_8

    cmp bl, TECLA_9
    je K_9 

    cmp bl, TECLA_ENTER
    je K_ENTER 

    

    jmp End_Keyboard ; Any other key should be ignored.




K_0:   ; Process any value key mean to set offset for each value..
        ; Instead, create a one-on-one label for each key..Love u assm
    push 0x00
    push dword Keyboard_Buffer_Itself
    call __Keyboard_Buffer_func
    add esp,8; 
    jmp End_Keyboard

K_1:   
    
    push 0x01
    push dword Keyboard_Buffer_Itself
    call __Keyboard_Buffer_func
    add esp,8;
    jmp End_Keyboard

K_2:   
    
    push 0x02
    push dword Keyboard_Buffer_Itself
    call __Keyboard_Buffer_func
    add esp,8; 
    jmp End_Keyboard

K_3:   
    
    push 0x03
    push dword Keyboard_Buffer_Itself
    call __Keyboard_Buffer_func
    add esp,8; 
    jmp End_Keyboard

K_4:   
    
    push 0x04
    push dword Keyboard_Buffer_Itself
    call __Keyboard_Buffer_func
    add esp,8;
    jmp End_Keyboard

K_5:   
    
    push 0x05
    push dword Keyboard_Buffer_Itself
    call __Keyboard_Buffer_func
    add esp,8; 
    jmp End_Keyboard
    
K_6:   
    push 0x06
    push dword Keyboard_Buffer_Itself
    call __Keyboard_Buffer_func
    add esp,8; 
    jmp End_Keyboard

K_7:   
    
    push 0x07
    push dword Keyboard_Buffer_Itself
    call __Keyboard_Buffer_func
    add esp,8; 
    jmp End_Keyboard

K_8:   
    
    push 0x08
    push dword Keyboard_Buffer_Itself
    call __Keyboard_Buffer_func
    add esp,8; 
    
    jmp End_Keyboard  
K_9:   
    
    push 0x09
    push dword Keyboard_Buffer_Itself
    call __Keyboard_Buffer_func
    add esp,8; 
    
    jmp End_Keyboard      


Buffer_full: 
; If 17 key were pressed, reset the counter and load the data

    mov dword eax, [Keyboard_counter]
    mov eax, 0
    mov dword [Keyboard_counter], eax ; Store the Keyboard_counter
    jmp K_ENTER_2;


K_ENTER:   ; Process enter key
    mov eax, 0
    mov dword [Keyboard_counter], eax ; Reset the keyboard counter

K_ENTER_2:    
    push dword Keyboard_Buffer_Itself
    push dword Load_Keyboard_table_Itself
    call Load_KeyBoardTable
    add esp,8
    jmp End_Keyboard

End_Keyboard:
    MOV al, 0x20 ;Send END of interrupt to PIC
    OUT 0x20, al
    POPAD ;Pop all general purp registers to stack
    iret     
    

IRQ01__TIMER0:

    PUSHAD                              ;Pop general purpose registers
    xor eax,eax  
    mov dword eax, [TIMER_COUNTER]
    inc eax
    mov dword [TIMER_COUNTER], eax


    cmp eax, 0x32                       ;How many shots it got?
    jg Clear_Counter                   

Timer_fin:
    MOV al, 0x20                        ;Envío End of Interrupt al PIC.
    OUT 0x20, al
    POPAD                               ;Restauro registros de uso general.
    iret                                ;End of interrupts

Clear_Counter:

    xor eax,eax                     ;Clear eax
    mov dword [TIMER_COUNTER], eax
    mov eax, 0x01
    mov dword [Flag_Task_1], eax
    jmp Timer_fin






