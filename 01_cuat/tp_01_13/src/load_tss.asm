
%include "inc/externs.h" 

section .load_tss
GLOBAL load_tss
EXTERN __TSS_TASK1
EXTERN __TSS_TASK2
EXTERN __TSS_TASK3
EXTERN __TSS_TASK4
EXTERN TASK1_LABEL
EXTERN TASK2_LABEL
EXTERN TASK3_LABEL
EXTERN TASK4_LABEL
EXTERN kernel32_loop
EXTERN DS_SEL
EXTERN DS_SEL_11
EXTERN CS_SEL_11
EXTERN CS_SEL_32
EXTERN DS_SEL
EXTERN TSS_SEL
EXTERN __STACK_KERNEL_T1_PHY
EXTERN __STACK_KERNEL_T1_VMA_END
EXTERN __STACK_KERNEL_T2_PHY
EXTERN __STACK_KERNEL_T2_VMA_END
EXTERN __STACK_KERNEL_T3_PHY
EXTERN __STACK_KERNEL_T3_VMA_END
EXTERN __STACK_KERNEL_T4_PHY
EXTERN __STACK_KERNEL_T4_VMA_END
EFLAGS EQU 0x202
;https://wiki.osdev.org/Task_State_Segment
load_tss:

;------------TSS TASK1------------
    mov eax, __TSS_TASK1
    mov [eax], dword(0) ; Previous task link
    mov [eax+0x04], dword(__STACK_KERNEL_T1_VMA_END) ;ESP0
    mov [eax+0x08], dword(DS_SEL)   ;SS0                 
    mov [eax+0x0C], dword(0) ;ESP1
    mov [eax+0x10], dword(0) ;SS1
    mov [eax+0x14], dword(__STACK_TASK1_VMA_END) ;ESP2
    mov [eax+0x18], dword(DS_SEL_11+3) ;SS2
    mov [eax+0x1C], dword(__CR3_TASK1);CR3
    mov [eax+0x20], dword(TASK1_LABEL) ;EIP
    mov [eax+0x24], dword(EFLAGS) ;EFLAGS
    mov [eax+0x28], dword(0) ;EAX
    mov [eax+0x2C], dword(0) ;ECX
    mov [eax+0x30], dword(0) ;EDX
    mov [eax+0x34], dword(0) ;EBX
    mov [eax+0x38], dword(__STACK_TASK1_VMA_END) ;ESP
    mov [eax+0x3C], dword(__STACK_TASK1_VMA_END)    ;EBP
    mov [eax+0x40], dword(0) ;ESI
    mov [eax+0x44], dword(0) ;EDI
    mov [eax+0x48], dword(DS_SEL_11+3) ;ES
    mov [eax+0x4C], dword(CS_SEL_11+3) ;CS
    mov [eax+0x50], dword(DS_SEL_11+3) ;SS
    mov [eax+0x54], dword(DS_SEL_11+3) ;DS
    mov [eax+0x58], dword(DS_SEL_11+3) ;FS
    mov [eax+0x5C], dword(DS_SEL_11+3);GS
    mov [eax+0x60], dword(0)   ;LDTR
    mov [eax+0x64], dword(0) ;Bitmap I/O

;------------TSS TASK2------------
   mov eax, __TSS_TASK2
    mov [eax], dword(0) ;
    mov [eax+0x04], dword(__STACK_KERNEL_T2_VMA_END) ;ESP0
    mov [eax+0x08], dword(DS_SEL)   ;SS0                 
    mov [eax+0x0C], dword(0) ;ESP1
    mov [eax+0x10], dword(0) ;SS1
    mov [eax+0x14], dword(__STACK_TASK2_VMA_END) ;ESP2
    mov [eax+0x18], dword(DS_SEL_11+3) ;SS2
    mov [eax+0x1C], dword(__CR3_TASK2);CR3
    mov [eax+0x20], dword(TASK2_LABEL) ;EIP
    mov [eax+0x24], dword(EFLAGS) ;EFLAGS
    mov [eax+0x28], dword(0) ;EAX
    mov [eax+0x2C], dword(0) ;ECX
    mov [eax+0x30], dword(0) ;EDX
    mov [eax+0x34], dword(0) ;EBX
    mov [eax+0x38], dword(__STACK_TASK2_VMA_END) ;ESP
    mov [eax+0x3C], dword(__STACK_TASK2_VMA_END)    ;EBP
    mov [eax+0x40], dword(0) ;ESI
    mov [eax+0x44], dword(0) ;EDI
    mov [eax+0x48], dword(DS_SEL_11+3) ;ES
    mov [eax+0x4C], dword(CS_SEL_11+3) ;CS
    mov [eax+0x50], dword(DS_SEL_11+3) ;SS
    mov [eax+0x54], dword(DS_SEL_11+3) ;DS
    mov [eax+0x58], dword(DS_SEL_11+3) ;FS
    mov [eax+0x5C], dword(DS_SEL_11+3);GS
    mov [eax+0x60], dword(0)   ;LDTR
    mov [eax+0x64], dword(0) ;Bitmap I/O

;------------TSS TASK3------------
   mov eax, __TSS_TASK3
    mov [eax], dword(0) ;
    mov [eax+0x04], dword(__STACK_KERNEL_T3_VMA_END) ;ESP0
    mov [eax+0x08], dword(DS_SEL)   ;SS0                 
    mov [eax+0x0C], dword(0) ;ESP1
    mov [eax+0x10], dword(0) ;SS1
    mov [eax+0x14], dword(__STACK_TASK3_VMA_END) ;ESP2
    mov [eax+0x18], dword(DS_SEL_11+3) ;SS2
    mov [eax+0x1C], dword(__CR3_TASK3);CR3
    mov [eax+0x20], dword(TASK3_LABEL) ;EIP
    mov [eax+0x24], dword(EFLAGS) ;EFLAGS
    mov [eax+0x28], dword(0) ;EAX
    mov [eax+0x2C], dword(0) ;ECX
    mov [eax+0x30], dword(0) ;EDX
    mov [eax+0x34], dword(0) ;EBX
    mov [eax+0x38], dword(__STACK_TASK3_VMA_END) ;ESP
    mov [eax+0x3C], dword(__STACK_TASK3_VMA_END)    ;EBP
    mov [eax+0x40], dword(0) ;ESI
    mov [eax+0x44], dword(0) ;EDI
    mov [eax+0x48], dword(DS_SEL_11+3) ;ES
    mov [eax+0x4C], dword(CS_SEL_11+3) ;CS
    mov [eax+0x50], dword(DS_SEL_11+3) ;SS
    mov [eax+0x54], dword(DS_SEL_11+3) ;DS
    mov [eax+0x58], dword(DS_SEL_11+3) ;FS
    mov [eax+0x5C], dword(DS_SEL_11+3);GS
    mov [eax+0x60], dword(0)   ;LDTR
    mov [eax+0x64], dword(0) ;Bitmap I/O         

;------------TSS TASK4------------
   mov eax, __TSS_TASK4
    mov [eax], dword(0) ;
    mov [eax+0x04], dword(__STACK_KERNEL_T4_VMA_END) ;ESP0
    mov [eax+0x08], dword(DS_SEL)   ;SS0                 
    mov [eax+0x0C], dword(0) ;ESP1
    mov [eax+0x10], dword(0) ;SS1
    mov [eax+0x14], dword(__STACK_TASK4_VMA_END) ;ESP2
    mov [eax+0x18], dword(DS_SEL) ;SS2
    mov [eax+0x1C], dword(__CR3_TASK4);CR3
    mov [eax+0x20], dword(TASK4_LABEL) ;EIP
    mov [eax+0x24], dword(EFLAGS) ;EFLAGS
    mov [eax+0x28], dword(0) ;EAX
    mov [eax+0x2C], dword(0) ;ECX
    mov [eax+0x30], dword(0) ;EDX
    mov [eax+0x34], dword(0) ;EBX
    mov [eax+0x38], dword(__STACK_TASK4_VMA_END) ;ESP
    mov [eax+0x3C], dword(__STACK_TASK4_VMA_END) ;EBP
    mov [eax+0x40], dword(0) ;ESI
    mov [eax+0x44], dword(0) ;EDI
    mov [eax+0x48], dword(DS_SEL) ;ES
    mov [eax+0x4C], dword(CS_SEL_32) ;CS
    mov [eax+0x50], dword(DS_SEL) ;SS
    mov [eax+0x54], dword(DS_SEL) ;DS
    mov [eax+0x58], dword(DS_SEL) ;FS
    mov [eax+0x5C], dword(DS_SEL);GS
    mov [eax+0x60], dword(0)   ;LDTR
    mov [eax+0x64], dword(0) ;Bitmap I/O

;------------TSS KERNEL------------
   mov eax, __TSS_KERNEL
    mov [eax], dword(0) ;
    mov [eax+0x04], dword(__STACK_END_32) ;ESP0
    mov [eax+0x08], dword(DS_SEL)   ;SS0                 
    mov [eax+0x0C], dword(0) ;ESP1
    mov [eax+0x10], dword(0) ;SS1
    mov [eax+0x14], dword(__STACK_END_32) ;ESP2
    mov [eax+0x18], dword(DS_SEL_11) ;SS2
    mov [eax+0x1C], dword(__CR3_KERNEL);CR3
    mov [eax+0x20], dword(kernel32_loop) ;EIP
    mov [eax+0x24], dword(EFLAGS) ;EFLAGS
    mov [eax+0x28], dword(0) ;EAX
    mov [eax+0x2C], dword(0) ;ECX
    mov [eax+0x30], dword(0) ;EDX
    mov [eax+0x34], dword(0) ;EBX
    mov [eax+0x38], dword(0) ;ESP
    mov [eax+0x3C], dword(0) ;EBP
    mov [eax+0x40], dword(0) ;ESI
    mov [eax+0x44], dword(0) ;EDI
    mov [eax+0x48], dword(DS_SEL) ;ES
    mov [eax+0x4C], dword(CS_SEL_32) ;CS
    mov [eax+0x50], dword(DS_SEL) ;SS
    mov [eax+0x54], dword(DS_SEL) ;DS
    mov [eax+0x58], dword(DS_SEL) ;FS
    mov [eax+0x5C], dword(DS_SEL);GS
    mov [eax+0x60], dword(0)   ;LDTR
    mov [eax+0x64], dword(0) ;Bitmap I/O
    xor eax, eax
    mov ax, TSS_SEL
    ltr ax ; Load TSS



    ret