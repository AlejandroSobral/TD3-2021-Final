GLOBAL Basic_Scheduler ;
EXTERN TASK1_COUNTER 
EXTERN TASK2_COUNTER 
EXTERN TASK3_COUNTER 
EXTERN TASK4_COUNTER 
EXTERN TIMER_COUNTER
EXTERN SCH_NEXT_TASK
EXTERN SCH_ACTUAL_TASK
EXTERN TSS_TO_LOAD 
EXTERN CR3_TO_LOAD
EXTERN Timer_fin
EXTERN First_time_Flag
EXTERN __TSS_KERNEL
EXTERN __TSS_TASK1
EXTERN __CR3_TASK1
EXTERN __TSS_TASK2
EXTERN __CR3_TASK2
EXTERN __TSS_TASK3
EXTERN __CR3_TASK3
EXTERN __TSS_TASK4
EXTERN __CR3_TASK4
EXTERN __MMX_TASK2
EXTERN __MMX_TASK3
EXTERN NEW_STACK

TASK1 EQU 1
TASK2 EQU 2
TASK3 EQU 3
TASK4 EQU 4
CYCLE EQU 21

__100mS EQU 10
__200mS EQU 20
__500mS EQU 50

section .ISR_AND_KEYBOARD

Basic_Scheduler:
    PUSHAD
    
    mov eax,[First_time_Flag]
    cmp eax,0                   
    ja Not_first             

 first_entry:
    xor eax, eax
    inc eax
    mov [First_time_Flag],eax   

    POPAD
    ;
    mov byte [SCH_ACTUAL_TASK], TASK4             ;Set a task as actual task (Idle task)

    mov eax, __TSS_TASK4
    mov [TSS_TO_LOAD], eax
    mov eax, __CR3_TASK4
    mov [CR3_TO_LOAD], eax      
    mov cr3,eax

    jmp LOAD_CONTEXT ; Only first time

Not_first:
    ;;
    inc byte [TASK1_COUNTER]
    inc byte [TASK2_COUNTER]
    inc byte [TASK3_COUNTER]        
   

    cmp byte [TASK1_COUNTER], __100mS
    jae _100mS_label

    cmp byte [TASK2_COUNTER], __200mS
    jae _200mS_label

    cmp byte [TASK3_COUNTER], __500mS
    jae _500mS_label  

    mov byte [SCH_ACTUAL_TASK], TASK4 ; If no flag got on, I shoudl execute the Idle Task
    mov byte [SCH_NEXT_TASK], TASK4   ; So TASK4 is ACTUAL and NEXT task to execute
    jmp ActualVsNext

_100mS_label: ;Exec TASK1
    mov byte [SCH_NEXT_TASK], TASK1
    mov byte[TASK1_COUNTER], 0
    jmp ActualVsNext

_200mS_label: ;Exec TASK2
    ;xchg bx,bx
    mov byte [SCH_NEXT_TASK], TASK2
    mov byte[TASK2_COUNTER], 0
    jmp ActualVsNext        

_500mS_label: ;Exec TASK3
    ;xchg bx, bx
    mov byte [SCH_NEXT_TASK], TASK3
    mov byte[TASK3_COUNTER], 0 
  
    jmp ActualVsNext        


ActualVsNext:

    xor eax, eax
    xor ebx, ebx
    mov al, byte[SCH_ACTUAL_TASK]
    mov bl, byte[SCH_NEXT_TASK]
    cmp al, bl
    je sch_end_no_switch ; If i'm running the same task I'd run after, there's nothing to be done
    jne sch_switch

 LOAD_CONTEXT:                 
    
    ;Cargo los registros de segmento
    mov eax, [TSS_TO_LOAD]     ; es
    mov es, [eax  + 0x48 ] 
    mov ds, [eax  + 0x54]
    mov fs, [eax  + 0x58]
    mov gs, [eax  + 0x5C]
    mov ebp, [eax + 0x3C]

    ;Stack
    mov ebx, [eax  + 0x04]
    mov [NEW_STACK], ebx
    mov ebx, [eax  + 0x08] ;SS0
    mov [NEW_STACK +4], ebx

    ;LSS --> load stack segment
    lss esp, [NEW_STACK]
    ;cargo el stack 

    mov ebx,  [eax + 0x18 ] ; SS2
    push ebx
    mov ebx,  [eax + 0x14 ] ; ESP2
    push ebx
    mov ebx,  [eax + 0x24 ] ; EFLGAS
    push ebx  
    mov ebx,  [eax + 0x4C ] ; CS
    push ebx 
    mov ebx,  [eax + 0x20 ] ; EIP
    push ebx   
 
    ;Registros de Proposito general
    mov ecx, [eax + 0x2C]
    mov edx, [eax + 0x30]
    mov ebx, [eax + 0x34]       
    mov esi, [eax + 0x40]
    mov edi, [eax + 0x44]
    mov eax, [eax + 0x28]    

    ;LOAD TSS INSTANCE

    push dword[TSS_TO_LOAD]
    call LOAD_DYN_TSS
    add esp,4
    jmp sch_end


sch_end_no_switch:
    POPAD ; If no switch've been done, it's mandatory to POPAD reg.purp.
sch_end:
    
    ;POPAD
    jmp Timer_fin        



sch_switch: ;Not first time
;Save actual context. Get the Next Task Context
    ;;
    ;;
    cmp byte [SCH_ACTUAL_TASK], TASK1 
    je SAVE_TASK1_CONTEXT

    cmp byte [SCH_ACTUAL_TASK], TASK2 
    je SAVE_TASK2_CONTEXT

    cmp byte [SCH_ACTUAL_TASK], TASK3 
    je SAVE_TASK3_CONTEXT

    cmp byte [SCH_ACTUAL_TASK], TASK4 
    je SAVE_TASK4_CONTEXT    


SAVE_TASK1_CONTEXT:
    ;;
    mov eax, __TSS_TASK1
    mov [TSS_TO_LOAD], eax
    jmp SAVE_CONTEXT
SAVE_TASK2_CONTEXT:
    ;;
    mov eax, __TSS_TASK2
    mov [TSS_TO_LOAD], eax
    FXSAVE &__MMX_TASK2
    jmp SAVE_CONTEXT
SAVE_TASK3_CONTEXT:
    ;;
    mov eax, __TSS_TASK3
    mov [TSS_TO_LOAD], eax
    FXSAVE &__MMX_TASK3        
    jmp SAVE_CONTEXT
SAVE_TASK4_CONTEXT:
    ;;
    mov eax, __TSS_TASK4
    mov [TSS_TO_LOAD], eax    
    jmp SAVE_CONTEXT    

 SAVE_CONTEXT:

 ;https://i.stack.imgur.com/KioUB.png
    POPAD
    
    mov [TSS_TO_LOAD + 0], ebx      
    mov [TSS_TO_LOAD + 4], ecx      
    mov [TSS_TO_LOAD + 8], edx      
    pop ebx
    mov [TSS_TO_LOAD + 12], ebx     
    mov [TSS_TO_LOAD + 16], esi     
    mov [TSS_TO_LOAD + 20], edi     
    mov [TSS_TO_LOAD + 24], ebp     
    mov ebx, esp
    mov [TSS_TO_LOAD + 28], ebx     
    mov ebx, cr3    
    mov [TSS_TO_LOAD + 52], ebx     
    mov ebx,[esp+4]
    mov [TSS_TO_LOAD + 56], ebx     
    mov ebx,[esp]
    mov [TSS_TO_LOAD + 68], ebx     
    mov ebx,[esp+8]
    mov [TSS_TO_LOAD + 72], ebx     

WHAT_TASK_NEXT: ;I'll never jump here

    cmp byte [SCH_NEXT_TASK], TASK1 
    je LOAD_TASK1_CONTEXT

    cmp byte [SCH_NEXT_TASK], TASK2 
    je LOAD_TASK2_CONTEXT

    cmp byte [SCH_NEXT_TASK], TASK3 
    je LOAD_TASK3_CONTEXT

    cmp byte [SCH_NEXT_TASK], TASK4 
    je LOAD_TASK4_CONTEXT
    jmp LOAD_TASK4_CONTEXT ;Default value    

                  
LOAD_TASK1_CONTEXT:
    mov eax, __TSS_TASK1
    mov [TSS_TO_LOAD], eax
    mov eax, __CR3_TASK1
    mov [CR3_TO_LOAD], eax      
    mov cr3,eax
    jmp LOAD_CONTEXT

LOAD_TASK2_CONTEXT:
    mov eax, __TSS_TASK2
    mov [TSS_TO_LOAD], eax
    mov eax, __CR3_TASK2
    mov [CR3_TO_LOAD], eax      
    mov cr3,eax
    ;SET CR0.TS = 1
    smsw ax
    or ax, 0x0008
    lmsw ax
    jmp LOAD_CONTEXT

LOAD_TASK3_CONTEXT:                        
    mov eax, __TSS_TASK3
    mov [TSS_TO_LOAD], eax
    mov eax, __CR3_TASK3
    mov [CR3_TO_LOAD], eax      
    mov cr3,eax
    ;SET CR0.TS = 1
    smsw ax
    or ax, 0x0008
    lmsw ax    
    jmp LOAD_CONTEXT

LOAD_TASK4_CONTEXT:
    mov eax, __TSS_TASK4
    mov [TSS_TO_LOAD], eax
    mov eax, __CR3_TASK4
    mov [CR3_TO_LOAD], eax      
    mov cr3,eax
    jmp LOAD_CONTEXT  



LOAD_DYN_TSS:
    mov ebx, [esp + 4] ; Back from push
    mov eax, [ebx]
    mov [__TSS_KERNEL], eax    ;Previous task link
    mov eax, [ebx+0x04]
    mov [__TSS_KERNEL+0x04], eax   ;ESP0
    mov eax, [ebx+0x08]
    mov [__TSS_KERNEL+0x08], eax ;SS0 
    mov eax, [ebx+0x0C]
    mov [__TSS_KERNEL+0x0C], eax ;ESP1
    mov eax, [ebx+0x10]
    mov [__TSS_KERNEL+0x10], eax  ;SS1 
    mov eax, [ebx+0x14]
    mov [__TSS_KERNEL+0x14], eax  ;ESP
    mov eax, [ebx+0x18]
    mov [__TSS_KERNEL+0x18], eax     ;SS2
    mov eax, [ebx+0x1C]
    mov [__TSS_KERNEL+0x1C], eax    ;CR3
    mov eax, [ebx+0x20]
    mov [__TSS_KERNEL+0x20], eax     ;EIP
    mov eax, [ebx+0x24]
    mov [__TSS_KERNEL+0x24], eax     ;EFLAGS
    mov eax, [ebx+0x28]
    mov [__TSS_KERNEL+0x28], eax     ;EAX
    mov eax, [ebx+0x2C]
    mov [__TSS_KERNEL+0x2C], eax     ;ECX
    mov eax, [ebx+0x30]
    mov [__TSS_KERNEL+0x30], eax     ;EDX
    mov eax, [ebx+0x34]
    mov [__TSS_KERNEL+0x34], eax     ;EBX
    mov eax, [ebx+0x38]
    mov [__TSS_KERNEL+0x38], eax    ;ESP
    mov eax, [ebx+0x3C]
    mov [__TSS_KERNEL+0x3C], eax     ;EBP
    mov eax, [ebx+0x40]
    mov [__TSS_KERNEL+0x40], eax     ;ESI
    mov eax, [ebx+0x44]
    mov [__TSS_KERNEL+0x44], eax     ;EDI
    mov eax, [ebx+0x48]
    mov [__TSS_KERNEL+0x48], eax     ;ES
    mov eax, [ebx+0x4C]
    mov [__TSS_KERNEL+0x4C], eax     ;CS
    mov eax, [ebx+0x50]
    mov [__TSS_KERNEL+0x50], eax     ;SS
    mov eax, [ebx+0x54]
    mov [__TSS_KERNEL+0x54], eax     ;DS
    mov eax, [ebx+0x58]
    mov [__TSS_KERNEL+0x58], eax     ;FS
    mov eax, [ebx+0x5C]
    mov [__TSS_KERNEL+0x5C], eax     ;GS
    mov eax, [ebx+0x60]
    mov [__TSS_KERNEL+0x60], eax     ;LDTR
    mov eax, [ebx+0x64]
    mov [__TSS_KERNEL+0x64], eax     ;Bitmap E/S

    ret