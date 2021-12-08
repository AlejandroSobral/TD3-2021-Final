USE32
GLOBAL init32
GLOBAL start32_launcher
%include "inc/processor-flags.h" 

SECTION .init32

;Load references
EXTERN  DS_SEL
EXTERN  __STACK_END_32
EXTERN  __STACK_SIZE_32
EXTERN  CS_SEL_32
EXTERN  kernel32_init
EXTERN  __KERNEL_32_LMA
EXTERN  __codigo_kernel32_size
EXTERN __ISR_AND_KEYBOARD_CODE_size; 
EXTERN __ISR_AND_KEYBOARD_VMA;
EXTERN __ISR_AND_KEYBOARD_LMA;_
EXTERN  __fast_memcpy
EXTERN  __fast_memcpy_rom
EXTERN  kernel32_code_size
EXTERN  __functions_size
EXTERN TASK_1_size
EXTERN __TASK_
EXTERN __TASK_1_VMA
EXTERN __TASK_1_LMA
EXTERN  __FUNCTIONS_LMA
EXTERN  __KERNEL_32_VMA
EXTERN  __FUNCTIONS_VMA
EXTERN __SYS_TABLES_GDT
EXTERN __SYS_TABLES_LMA
EXTERN  __sys_size
EXTERN Digit_Table_Average
EXTERN Screen_pointer

;JMP References
EXTERN init_pic
EXTERN init_IDT
EXTERN init_timer0
EXTERN _idtr
KeyBoard_IRQ equ 0x01
VIDEO_BUFFER_ADDR EQU 0x000B8000

 


init32:
start32_launcher:

    ;Selectors init
    mov ax, DS_SEL
    mov ds, ax
    mov es, ax
    mov gs, ax
    mov fs, ax

    ;Stack init
    mov ss,ax
    mov esp,__STACK_END_32
    xor eax,eax

    ;Clean Stack
    mov ecx,__STACK_SIZE_32   
    .stack_init:
        push eax
        loop .stack_init
    mov esp,__STACK_END_32

    ;Start copying from ROM -> RAM.

    ;Copy Functions functions
    push ebp
    mov ebp,esp
    push __functions_size; 
    push __FUNCTIONS_VMA
    push __FUNCTIONS_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo

    ;Copy Kernel
    push ebp
    mov ebp,esp
    push __codigo_kernel32_size; 
    push __KERNEL_32_VMA;
    push __KERNEL_32_LMA;
    call __fast_memcpy
    leave
    cmp eax,1
    jne .halteo

    ;Copy Task_01
    push ebp
    mov ebp,esp
    push TASK_1_size; 
    push __TASK_1_VMA;
    push __TASK_1_LMA;
    call __fast_memcpy
    leave
    cmp eax,1
    jne .halteo


    ;ISR & KEYBOARD Codes
    push ebp
    mov ebp,esp
    push __ISR_AND_KEYBOARD_CODE_size; 
    push __ISR_AND_KEYBOARD_VMA;
    push __ISR_AND_KEYBOARD_LMA;_
    call __fast_memcpy
    leave
    cmp eax,1
    jne .halteo
    
    push ebp
    mov ebp,esp
    push  __sys_size; 
    push __SYS_TABLES_GDT;
    push __SYS_TABLES_LMA ;
    call __fast_memcpy
    leave
    cmp eax,1
    jne .halteo

    call init_pic ; PIC Init
    call init_IDT;  IDT Init

    mov eax, 0        ;Little Video Init
    mov [Digit_Table_Average], eax
    mov eax, VIDEO_BUFFER_ADDR
    mov [Screen_pointer],eax    


    jmp CS_SEL_32:kernel32_init


.halteo
    hlt
    jmp .halteo
