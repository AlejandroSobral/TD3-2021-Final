USE32
GLOBAL init32
GLOBAL start32_launcher
GLOBAL turn_on_paging
%include "inc/processor-flags.h" 

SECTION .init32

;Load references
EXTERN  DS_SEL
EXTERN __FUNCTIONS_PHY
EXTERN __TASK_1_BSS_PHY
EXTERN __TASK_1_DATA_PHY
EXTERN __TASK_1_RODATA_PHY
EXTERN __TASK_1_TEXT_PHY
EXTERN __TASK_4_BSS_PHY
EXTERN __TASK_4_DATA_PHY
EXTERN __TASK_4_RODATA_PHY
EXTERN __TASK_4_TEXT_PHY
EXTERN __TASK_2_BSS_PHY
EXTERN __TASK_2_DATA_PHY
EXTERN __TASK_2_RODATA_PHY
EXTERN __TASK_2_TEXT_PHY
EXTERN __TASK_3_BSS_PHY
EXTERN __TASK_3_DATA_PHY
EXTERN __TASK_3_RODATA_PHY
EXTERN __TASK_3_TEXT_PHY
EXTERN __DATA_PHY
EXTERN __KERNEL_32_PHY
EXTERN __ISR_AND_KEYBOARD_PHY
EXTERN __SYS_TABLES_PHY
EXTERN  __STACK_END_32
EXTERN  __STACK_SIZE_32
EXTERN  CS_SEL_32
EXTERN  kernel32_init
EXTERN  __KERNEL_32_LMA
EXTERN  __codigo_KERNEL32_size
EXTERN __ISR_AND_KEYBOARD_CODE_size; 
EXTERN __ISR_AND_KEYBOARD_VMA;
EXTERN __ISR_AND_KEYBOARD_LMA;_
EXTERN  __fast_memcpy
EXTERN  __fast_memcpy_rom
EXTERN __DATA__size
EXTERN  kernel32_code_size
EXTERN  __functions_size
EXTERN TASK_1_rodata_size
EXTERN TASK_1_data_size
EXTERN TASK_1_bss_size
EXTERN TASK_1_TEXT_size
EXTERN TASK_2_rodata_size
EXTERN TASK_2_data_size
EXTERN TASK_2_bss_size
EXTERN TASK_2_TEXT_size
EXTERN TASK_3_rodata_size
EXTERN TASK_3_data_size
EXTERN TASK_3_bss_size
EXTERN TASK_3_TEXT_size
EXTERN TASK_4_rodata_size
EXTERN TASK_4_data_size
EXTERN TASK_4_bss_size
EXTERN TASK_4_TEXT_size
EXTERN __TASK_1_DATA_LMA
EXTERN __TASK_1_DATA_VMA
EXTERN __TASK_1_RODATA_VMA
EXTERN __TASK_1_RODATA_LMA
EXTERN __TASK_1_TEXT_LMA
EXTERN __TASK_1_TEXT_VMA
EXTERN __TASK_1_BSS_LMA
EXTERN __TASK_1_BSS_VMA
EXTERN __TASK_2_DATA_LMA
EXTERN __TASK_2_RODATA_LMA
EXTERN __TASK_2_TEXT_LMA
EXTERN __TASK_2_TEXT_VMA
EXTERN __TASK_2_BSS_LMA
EXTERN __TASK_2_BSS_VMA
EXTERN __TASK_3_DATA_LMA
EXTERN __TASK_3_RODATA_LMA
EXTERN __TASK_3_TEXT_LMA
EXTERN __TASK_3_TEXT_VMA
EXTERN __TASK_3_BSS_LMA
EXTERN __TASK_3_BSS_VMA
EXTERN __TASK_4_DATA_LMA
EXTERN __TASK_4_DATA_VMA
EXTERN __TASK_4_RODATA_VMA
EXTERN __TASK_4_RODATA_LMA
EXTERN __TASK_4_TEXT_LMA
EXTERN __TASK_4_TEXT_VMA
EXTERN __TASK_4_BSS_LMA
EXTERN __TASK_4_BSS_VMA
EXTERN  __FUNCTIONS_LMA
EXTERN  __KERNEL_32_VMA
EXTERN  __FUNCTIONS_VMA
EXTERN __DATA_LMA
EXTERN __DATA_VMA
EXTERN __SYS_TABLES_GDT 
EXTERN __SYS_TABLES_IDT
EXTERN __SYS_TABLES_LMA
EXTERN  __sys_tables_size
EXTERN Screen_pointer

;JMP References
EXTERN init_pic
EXTERN init_IDT
EXTERN init_timer0
EXTERN load_tss


EXTERN go_paging
KeyBoard_IRQ equ 0x01
VIDEO_BUFFER_ADDR EQU 0x000B8000


_idtr   dw ((0x21*8)+(0x2*8))
        dd __SYS_TABLES_IDT

_gdtr   dw (5*8)-1;4 descriptors of 32kb each one
        dd __SYS_TABLES_GDT
 


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


    ;Copy Functions 
    push ebp
    mov ebp,esp
    push __functions_size; 
    push __FUNCTIONS_PHY
    push __FUNCTIONS_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo
        

    ;Copy Task Text
    push ebp
    mov ebp,esp
    push  TASK_1_TEXT_size; 
    push __TASK_1_TEXT_PHY
    push __TASK_1_TEXT_LMA ; 
    call __fast_memcpy_rom ; 
    leave
    cmp eax,1
    jne .halteo

    
    ;Copy Task Bss 
    push ebp
    mov ebp,esp
    push  TASK_1_bss_size; 
    push __TASK_1_BSS_PHY
    push __TASK_1_BSS_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo    
    
    ;Copy Task Data
    push ebp
    mov ebp,esp
    push  TASK_1_data_size; 
    push __TASK_1_DATA_PHY
    push __TASK_1_DATA_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo
    
    ;Copy Task RoData
    push ebp
    mov ebp,esp
    push  0x01;TASK_1_rodata_size; 
    push __TASK_1_RODATA_PHY
    push __TASK_1_RODATA_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo
            
      ;Copy Task Text
    push ebp
    mov ebp,esp
    push  TASK_2_TEXT_size; 
    push __TASK_2_TEXT_PHY
    push __TASK_2_TEXT_LMA ; 
    call __fast_memcpy_rom ; 
    leave
    cmp eax,1
    jne .halteo
          
    ;Copy Task Bss 
    push ebp
    mov ebp,esp
    push  0x01; TASK_2_bss_size 
    push __TASK_2_BSS_PHY
    push __TASK_2_BSS_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo    
  
    ;Copy Task Data
    push ebp
    mov ebp,esp
    push  TASK_2_data_size; 
    push __TASK_2_DATA_PHY
    push __TASK_2_DATA_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo

           
    
    ;Copy Task RoData
    push ebp
    mov ebp,esp
    push  0x01;TASK_2_rodata_size; 
    push __TASK_2_RODATA_PHY
    push __TASK_2_RODATA_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo

;Copy Task Text
    push ebp
    mov ebp,esp
    push  TASK_3_TEXT_size; 
    push __TASK_3_TEXT_PHY
    push __TASK_3_TEXT_LMA ; 
    call __fast_memcpy_rom ; 
    leave
    cmp eax,1
    jne .halteo 
    
    ;Copy Task Bss 
    push ebp
    mov ebp,esp
    push  0x01; TASK_3_bss_size 
    push __TASK_3_BSS_PHY
    push __TASK_3_BSS_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo    
    
    ;Copy Task Data
    push ebp
    mov ebp,esp
    push  0x01;TASK_3_data_size; 
    push __TASK_3_DATA_PHY
    push __TASK_3_DATA_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo
    
    ;Copy Task RoData
    push ebp
    mov ebp,esp
    push  0x01;TASK_3_rodata_size; 
    push __TASK_3_RODATA_PHY
    push __TASK_3_RODATA_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo       

    ;Copy Task Text
    push ebp
    mov ebp,esp
    push  TASK_4_TEXT_size; 
    push __TASK_4_TEXT_PHY
    push __TASK_4_TEXT_LMA ; 
    call __fast_memcpy_rom ; 
    leave
    cmp eax,1
    jne .halteo 

    ;Copy Task Bss 
    push ebp
    mov ebp,esp
    push  0x01;TASK_4_bss_size; 
    push __TASK_4_BSS_PHY
    push __TASK_4_BSS_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo    
    
    ;Copy Task Data
    push ebp
    mov ebp,esp
    push  TASK_4_data_size; 
    push __TASK_4_DATA_PHY
    push __TASK_4_DATA_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo

    ;Copy Task RoData
    push ebp
    mov ebp,esp
    push  0x01;TASK_4_rodata_size; 
    push __TASK_4_RODATA_PHY
    push __TASK_4_RODATA_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo

    push ebp
    mov ebp,esp
    push  __DATA__size; 
    push __DATA_PHY
    push __DATA_LMA ; 
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo  

    ;Copy Kernel
    push ebp
    mov ebp,esp
    push __codigo_KERNEL32_size; 
    push __KERNEL_32_PHY
    push __KERNEL_32_LMA;
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo

    ;ISR & KEYBOARD Codes
    push ebp
    mov ebp,esp
    push __ISR_AND_KEYBOARD_CODE_size; 
    push __ISR_AND_KEYBOARD_PHY
    push __ISR_AND_KEYBOARD_LMA;_
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo

    push ebp
    mov ebp,esp
    push  __sys_tables_size; 
    push __SYS_TABLES_GDT
    push __SYS_TABLES_LMA ;
    call __fast_memcpy_rom
    leave
    cmp eax,1
    jne .halteo

    call init_pic ; PIC Init
    call init_IDT;  IDT Init
    call init_timer0; 

    ;Here I Should start setting CR3 & CR0.PG (Bit 31)
    lidt[_idtr] ;Load IDT
    lgdt[_gdtr];Load GDT

    jmp go_paging; Let's do it!



.halteo:
    hlt
    jmp .halteo



turn_on_paging:

    ; Paging turn on
    mov   eax, cr0 
    or    eax, X86_CR0_PG
    mov   cr0, eax  
    
    call load_tss;
    ;mov eax, 0        ;Little Video Init
    ;mov [Digit_Table_Average], eax
    ;mov eax, VIDEO_BUFFER_ADDR
    ;mov [Screen_pointer],eax  

    jmp CS_SEL_32:kernel32_init