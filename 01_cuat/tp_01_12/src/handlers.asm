SECTION .ISR_AND_KEYBOARD

%include "inc/defines.h" 
%include "inc/processor-flags.h" 

EXTERN __Keyboard_Buffer_func
EXTERN Keyboard_Buffer_Itself
EXTERN Load_KeyBoardTable
EXTERN Load_Keyboard_table_Itself
EXTERN Keyboard_counter
EXTERN Flag_Task_1
EXTERN PF_error_code
EXTERN Screen_Writing_string
EXTERN __PAGE_FAULT_PHY
EXTERN Basic_Scheduler
EXTERN __MMX_TASK2
EXTERN __MMX_TASK3
EXTERN SCH_ACTUAL_TASK
Key_times_to_load EQU 16

PAG_PCD_YES equ 1       ; Cached                         
PAG_PCD_NO  equ 0       ; No-cached
PAG_PWT_YES equ 1       ; 1 to be write on Cache & Ram   
PAG_PWT_NO  equ 0       ; 0 
PAG_P_YES   equ 1       ; 1 Present
PAG_P_NO    equ 0       ; 0 No presente
PAG_RW_W    equ 1       ; 1 Read_Write
PAG_RW_R    equ 0       ; 0 Read only
PAG_US_SUP  equ 0       ; 0 Supervisor
PAG_US_US   equ 1       ; 1 User  
PAG_D       equ 0       ; Modify at page
PAG_PAT     equ 0       ; PAT                   
PAG_G_YES   equ 0       ; Global                 
PAG_A       equ 0       ; Accesed
PAG_PS_4K   equ 0       ; 4KB as PageSize

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
GLOBAL Timer_fin

EXTERN __SYS_TABLES_IDT
EXTERN __SYS_TABLES_GDT
EXTERN DS_SEL
EXTERN IDT_handler_loader
EXTERN CS_SEL_32
EXTERN TIMER_COUNTER
EXTERN PF_lin_addrs
EXTERN __screen_writing_pf
EXTERN Screen_pointer
EXTERN __PAGE_TABLES_PHY
EXTERN Basic_Scheduler
EXTERN buffer_Clear

EXTERN __load_DTP_entry
EXTERN __load_TP_entry

TASK2 EQU 2
TASK3 EQU 3

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

    PUSHAD
    mov eax, 0x07
    clts        
    cmp byte [SCH_ACTUAL_TASK], TASK2
    je LOAD_CONTEXT_TASK2

    cmp byte [SCH_ACTUAL_TASK], TASK3
    je LOAD_CONTEXT_TASK3

    jmp END_NM_ITR

LOAD_CONTEXT_TASK2:
    mov eax, __MMX_TASK2
    FXRSTOR [eax]
    jmp END_NM_ITR

LOAD_CONTEXT_TASK3:
    mov eax, __MMX_TASK3
    FXRSTOR [eax]

END_NM_ITR:
    POPAD
    iret


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
    ; CR2 content show the memory
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
    cli                                ; Turn off interrputs
    xchg bx,bx                    ;                                     
    pusha                              ; Store g.p. registers
    mov eax, cr2                       ;Store CR2 as requested
    mov [PF_lin_addrs], eax      ;Store linear addrs
    mov ebx, [esp + 32]                ;Get error code
    mov [PF_error_code], ebx     ;Store error code
    mov eax, ebx; Compare PF_error_code 


    and eax, 0x1F       ;Mask to take B4-B0
    cmp eax,0           ; Cmp according upper info          
    je PF_P             ; No present page                                   
    cmp eax,1                
    je PF_RW                                        
    cmp eax,2           
    je PF_US                                    
    cmp eax,4                                      
    je PF_ID
PF_P:

    push ebp
    mov ebp,esp
    push dword [PF_error_code] 
    call __screen_writing_pf
    leave

    ; Here I should set paging off, and load the no-paged add


    mov  eax, cr0 
    and  eax, (X86_CR0_PG - 1) 
    mov  cr0, eax  



    ; -> Load DTP (Page Table Entry)
    push    ebp
    mov     ebp, esp
    push    PAG_P_YES                           ; Present. P = 1 on memory. P=0, out of mem.
    push    PAG_RW_W                            ; Readable / Writable: RO = 0; W = 1;
    push    PAG_US_SUP                          ; User / Supervisor: Set page privileges, Kernel = 0; User = 1
    push    PAG_PWT_NO                          ; Page-Level Write Through. Cache writing mode
    push    PAG_PCD_NO                          ; Page-Level Cache Disable. Set page into non-cached memory.
    push    PAG_A                               ; Accesed. To be write each time page is used.
    push    PAG_PS_4K                           ; Page Size: Set 0 for 4kB page, 1 for 4 Mb
    push    dword[PF_lin_addrs]                       ; VMA Adds
    push    dword(__PAGE_TABLES_PHY)            ; Start itself
    call    __load_DTP_entry
    leave



    ; -> Load (Page Table Entry)
    push    ebp
    mov     ebp, esp
    push    PAG_P_YES
    push    PAG_RW_W
    push    PAG_US_SUP
    push    PAG_PWT_NO
    push    PAG_PCD_NO
    push    PAG_A
    push    PAG_D
    push    PAG_PAT
    push    PAG_G_YES
    push    dword(0xA0000000) ;Phy where is indicated to page. No used any more.
    push    dword[PF_lin_addrs]  ;VMA've cause the pF
    push    dword(__PAGE_TABLES_PHY) ;TP Init, After DTP 
    call    __load_TP_entry
    leave

    ; Paging turn on
    mov   eax, cr0 
    or    eax, X86_CR0_PG
    mov   cr0, eax  

    jmp END_PF
    
PF_RW:
    push ebp
    mov ebp,esp
    push dword [PF_error_code]   
    call __screen_writing_pf
    leave
    xchg bx,bx    



    jmp END_PF
    
PF_US:

    push ebp
    mov ebp,esp
    push dword [PF_error_code]  
    call __screen_writing_pf
    leave
    xchg bx,bx
    jmp END_PF
    
PF_ID:
    xchg bx,bx
    push ebp
    mov ebp,esp
    push dword [PF_error_code] 
    call __screen_writing_pf
    leave
    jmp END_PF



END_PF:
    
    MOV al, 0x20 ;Send END of interrupt to PIC
    OUT 0x20, al
    POPAD ;Pop all general purp registers to stack
    pop eax
    sti
    iret     
    




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
    ;xchg bx, bx
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
    ;mov dword eax, [Keyboard_counter]
    ;mov eax, 0
    mov dword [Keyboard_counter], 0 ; Store the Keyboard_counter
    jmp K_ENTER_2;


K_ENTER:   ; Process enter key
    mov dword [Keyboard_counter], 0 ; Reset the keyboard counter

K_ENTER_2:    
    ;xchg bx, bx
    push dword Keyboard_Buffer_Itself
    push dword Load_Keyboard_table_Itself
    call Load_KeyBoardTable
    add esp,8
    ;xchg bx, bx

    ;push dword Keyboard_Buffer_Itself
    ;call buffer_Clear
    ;add esp, 4

    jmp End_Keyboard

End_Keyboard:
    MOV al, 0x20 ;Send END of interrupt to PIC
    OUT 0x20, al
    POPAD ;Pop all general purp registers to stack
    iret     
    

IRQ01__TIMER0:
                            
    jmp Basic_Scheduler     ; Jump rather than calling for keep stack just the same
               
    
Timer_fin:
    MOV al, 0x20                        
    OUT 0x20, al                              
    iret                                





