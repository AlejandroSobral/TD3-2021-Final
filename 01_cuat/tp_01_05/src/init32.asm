USE32
GLOBAL init32
GLOBAL start32_launcher
%include "inc/processor-flags.h" 

SECTION .init32

EXTERN  DS_SEL
EXTERN  __STACK_END_32
EXTERN  __STACK_SIZE_32
EXTERN  CS_SEL_32
EXTERN  kernel32_init
EXTERN  __KERNEL_32_LMA
EXTERN  __codigo_kernel32_size
EXTERN  __fast_memcpy
EXTERN  __fast_memcpy_rom
EXTERN  kernel32_code_size
EXTERN  __functions_size
EXTERN  __FUNCTIONS_LMA
EXTERN  __KERNEL_32_VMA
EXTERN  __FUNCTIONS_VMA

EXTERN __SYS_TABLES_GDT
EXTERN __SYS_TABLES_LMA

EXTERN  __sys_size

EXTERN init_pic
EXTERN init_IDT
EXTERN _idtr
KeyBoard_IRQ equ 0x01

 


init32:



start32_launcher:


    ;xchg bx,bx
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

    ;limpio la pila
    mov ecx,__STACK_SIZE_32   
    .stack_init:
        push eax
        loop .stack_init
    mov esp,__STACK_END_32

    ;Start copying from ROM -> RAM.

 
    push ebp
    mov ebp,esp
    ;enter
    push __functions_size; 0x3c __functions_size
    push __FUNCTIONS_VMA
    push __FUNCTIONS_LMA ; 0xFFFF1000 __FUNCTIONS_LMA
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo


    ;desempaqueto la rom
    push ebp
    mov ebp,esp
    push __codigo_kernel32_size; 0x0000000000300000 __codigo_kernel32_size
    push __KERNEL_32_VMA;__KERNEL_32_VMA
    push __KERNEL_32_LMA;__KERNEL_32_LMA
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo

    
    push ebp
    mov ebp,esp
    ;enter
    push  __sys_size; 0x3c __functions_size
    push __SYS_TABLES_GDT;
    push __SYS_TABLES_LMA ; 0xFFFF1000 __FUNCTIONS_LMA
    call __fast_memcpy
    leave
    cmp eax,1
    jne .halteo


    call init_pic ; Inicializo el PIC



    call init_IDT; Inicializo IDT




;Habilito las IRQ de teclado
    ;xchg bx,bx
    ;in al,0x14
    ;xor al,KeyBoard_IRQ
    ;out 0x14,al



    
    jmp CS_SEL_32:kernel32_init

    

.halteo
    hlt
    jmp .halteo
