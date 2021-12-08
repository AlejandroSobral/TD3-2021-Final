%include "inc/processor-flags.h" 
%include "inc/defines.h" 
section .go_paging

GLOBAL go_paging

EXTERN __SYS_TABLES_IDT
EXTERN __PAGE_TABLES_VMA
EXTERN __VIDEO_VMA
EXTERN __load_DTP_entry
EXTERN __load_TP_entry
EXTERN __DATA_VMA
EXTERN __INIT_16_VMA
EXTERN __INIT_32_VMA
EXTERN __STACK_START_32
EXTERN __FUNCTIONS_VMA
EXTERN __SYS_TABLES_VMA
EXTERN __DATA_VMA
EXTERN __ISR_AND_KEYBOARD_VMA
EXTERN __KERNEL_32_VMA
EXTERN __TASK_1_BSS_VMA
EXTERN __TASK_1_RODATA_VMA
EXTERN __TASK_1_TEXT_VMA
EXTERN __TASK_1_STACK_START
EXTERN __TASK_1_DATA_VMA
EXTERN __TABLE_KEYBOARD_VMA
EXTERN LOAD_CR3


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

go_paging:



;;;;;;;;;;;;;;;;;START - Page Directory Entries;;;;;;;;;;;;;;;;;;;;;     

    ;-> Entry 0 for DPT
    ; VMA Directions I'm mapping here are: (Check that index Bits 31-22 are 0x00 for all of them!)
    ;DPT Index -> (Bits 31-22)
    ; __SYS_TABLES_IDT        = 0x00000000;                                                                   
    ; __PAGE_TABLES_VMA       = 0x00010000;                                                           
    ; __VIDEO_VMA             = 0x000B8000;
    ; __TECLADO_ISR_VMA       = 0x00100000;
    ; __DATA_VMA              = 0x00200000;
    ; __FUNCTIONS_VMA         = 0x00207000;     
    ; __TABLE_KEYBOARD_VMA    = 0x00210000; 
    ; __KERNEL_32_VMA         = 0x00220000;
    ; __TASK_1_VMA            = 0x00310000;
    ; __TASK_1_TEXT_VMA       = 0x00310000;
    ; __TASK_1_BSS_BMA        = 0x00320000;
    ; __TASK_1_DATA_VMA       = 0x00330000;
    ; __TASK_1_RODATA_VMA     = 0x00340000;

  
  ; Set CR3 at DPT base add
    push    ebp
    mov     ebp, esp
    push    PAG_PWT_YES
    push    PAG_PCD_YES
    push    dword __PAGE_TABLES_VMA
    call    LOAD_CR3
    mov     cr3, eax
    leave    
             
    ; I'm pushing VMA with exactly the same INDEX, that's why I pushed just one VMA i.e. __SYS_TABLES_IDT
    push    ebp
    mov     ebp, esp
    push    PAG_P_YES                           ; Present. P = 1 on memory. P=0, out of mem.
    push    PAG_RW_W                            ; Readable / Writable: RO = 0; W = 1;
    push    PAG_US_SUP                          ; User / Supervisor: Set page privileges, Kernel = 0; User = 1
    push    PAG_PWT_NO                          ; Page-Level Write Through. Cache writing mode
    push    PAG_PCD_NO                          ; Page-Level Cache Disable. Set page into non-cached memory.
    push    PAG_A                               ; Accesed. To be write each time page is used.
    push    PAG_PS_4K                           ; Page Size: Set 0 for 4kB page, 1 for 4 Mb
    push    dword(__SYS_TABLES_IDT)             ; VMA Adds
    push    dword(__PAGE_TABLES_VMA)            ; Start itself
    call    __load_DTP_entry
    leave

    ;-> Entry 1 for DPT
    ; VMA Directions I'm mapping here are: (Check that index Bits 31-22 are the same for all of them!. Index is calculated from VMA at __load_DTP_entry)
    ;
    ; __STACK_START_32        = 0x1FFF8000;
    ; __STACK_END_32          = 0x1FFF8FFF;
    ; __TASK_1_STACK_START    = 0x1FFFF000;
    ; __TASK_1_STACK_END      = 0x1FFFFFFF;  
             
    ; I'm pushing VMA with exactly the same INDEX, that's why I pushed just one VMA i.e. __STACK_START_32
    push    ebp
    mov     ebp, esp
    push    PAG_P_YES                           ; Present. P = 1 on memory. P=0, out of mem.
    push    PAG_RW_W                            ; Readable / Writable: RO = 0; W = 1;
    push    PAG_US_SUP                          ; User / Supervisor: Set page privileges, Kernel = 0; User = 1
    push    PAG_PWT_NO                          ; Page-Level Write Through. Cache writing mode
    push    PAG_PCD_NO                          ; Page-Level Cache Disable. Set page into non-cached memory.
    push    PAG_A                               ; Accesed. To be write each time page is used.
    push    PAG_PS_4K                           ; Page Size: Set 0 for 4kB page, 1 for 4 Mb
    push    dword(__STACK_START_32)             ; VMA Adds
    push    dword(__PAGE_TABLES_VMA)            ; Start itself
    call    __load_DTP_entry
    leave


    ;-> Entry 2 for DPT
    ; VMA Directions I'm mapping here are: (Check that index Bits 31-22 are the same for all of them!. Index is calculated from VMA at __load_DTP_entry)
    ;
    ;    __INIT_16_VMA           = 0xFFFF0000;
    ;    __VIDEO_VMA          =    0xFFFF5000;
    ;    __INIT_32_VMA           = 0xFFFFB000;
    ;    __FUNCTIONS_ROM_VMA     = 0xFFFFFC00;
    ;    __RESET_VMA             = 0xFFFFFFF0;
             
    ; I'm pushing VMA with exactly the same INDEX, that's why I pushed just one VMA i.e. __INIT_16_VMA
    push    ebp
    mov     ebp, esp
    push    PAG_P_YES                           ; Present. P = 1 on memory. P=0, out of mem.
    push    PAG_RW_W                            ; Readable / Writable: RO = 0; W = 1;
    push    PAG_US_SUP                          ; User / Supervisor: Set page privileges, Kernel = 0; User = 1
    push    PAG_PWT_NO                          ; Page-Level Write Through. Cache writing mode
    push    PAG_PCD_NO                          ; Page-Level Cache Disable. Set page into non-cached memory.
    push    PAG_A                               ; Accesed. To be write each time page is used.
    push    PAG_PS_4K                           ; Page Size: Set 0 for 4kB page, 1 for 4 Mb
    push    dword(__INIT_16_VMA)                ; VMA Adds
    push    dword(__PAGE_TABLES_VMA)            ; Start itself
    call    __load_DTP_entry
    leave

;;;;;;;;;;;;;;;;;END - Page Directory Entries;;;;;;;;;;;;;;;;;;;;;    


;;;;;;;;;;;;;;;;;;;;START -  Table Paging (TP) Mapping;;;;;;;;;;;;;;;;;;;;;
    ; TP Index -> Bits 21-12 from VMA
  ;-----------------------------------------------------------------
    ;1st Page - Systables. __SYS_TABLES_VMA = 0x00000000)
  ;-----------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_R
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__SYS_TABLES_VMA)
    push dword(__PAGE_TABLES_VMA+0x1000) ;TP Init, After DTP 
    call __load_TP_entry 
    leave

  ;-----------------------------------------------------------------
    ;2nd Page __PAGE_TABLES_VMA = 0x00010000
  ;-----------------------------------------------------------------

    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_R
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__PAGE_TABLES_VMA)
    push dword(__PAGE_TABLES_VMA+0x1000) ;TP Init, After DTP 
    call __load_TP_entry 
    leave

  ;-----------------------------------------------------------------
    ;3rd Page - Functions __FUNCTIONS_VMA = 0x00500000
  ;-----------------------------------------------------------------

    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_R
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__FUNCTIONS_VMA)
    push dword(__PAGE_TABLES_VMA+0x1000) ;TP Init, After DTP 
    call __load_TP_entry 
    leave

  ;-----------------------------------------------------------------
    ;4th Page __VIDEO_VMA = 0x000B8000;
  ;-----------------------------------------------------------------

    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_R
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__VIDEO_VMA)
    push dword(__PAGE_TABLES_VMA+0x1000) ;TP Init, After DTP 
    call __load_TP_entry 
    leave    

  ;-----------------------------------------------------------------
    ;5th Page __ISR_AND_KEYBOARD_VMA  = 0x00100000;
  ;-----------------------------------------------------------------

    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_R
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__ISR_AND_KEYBOARD_VMA)
    push dword(__PAGE_TABLES_VMA+0x1000) ;TP Init, After DTP 
    call __load_TP_entry 
    leave        

  ;-----------------------------------------------------------------
    ;6º Page __DATA_VMA    = 0x00200000;
  ;-----------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_W
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__DATA_VMA)
    push dword(__PAGE_TABLES_VMA+0x1000)
    call __load_TP_entry 
    leave

    ;-----------------------------------------------------------------
    ;7th   __TABLE_KEYBOARD_VMA    = 0x00210000; 
    ;-----------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_W
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__TABLE_KEYBOARD_VMA)
    push dword(__PAGE_TABLES_VMA+0x1000)
    call __load_TP_entry 
    leave

    ;-----------------------------------------------------------------
   ; 8th __KERNEL_32_VMA = 0x00220000;
    ;-----------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_R
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__KERNEL_32_VMA)
    push dword(__PAGE_TABLES_VMA+0x1000)
    call __load_TP_entry 
    leave

    ;-----------------------------------------------------------------
    ;9th __TASK_1_TEXT_VMA   = 0x00310000;
    ;-----------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_R
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__TASK_1_TEXT_VMA)
    push dword(__PAGE_TABLES_VMA+0x1000)
    call __load_TP_entry 
    leave

    ;-----------------------------------------------------------------
    ;10° __TASK_1_BSS_VMA = 0x00320000;
    ;-----------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_W
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__TASK_1_BSS_VMA)
    push dword(__PAGE_TABLES_VMA+0x1000)
    call __load_TP_entry 
    leave

    ;-----------------------------------------------------------------
    ;11th   __TASK_1_DATA_VMA      = 0x00330000;
    ;-----------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_W
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__TASK_1_DATA_VMA)
    push dword(__PAGE_TABLES_VMA+0x1000)
    call __load_TP_entry 
    leave

    ;-----------------------------------------------------------------
    ;12th  __TASK_1_RODATA_VMA    = 0x00340000;   
    ;-----------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_R
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__TASK_1_RODATA_VMA)
    push dword(__PAGE_TABLES_VMA+0x1000)
    call __load_TP_entry 
    leave

    ;-----------------------------------------------------------------
    ;13th  __STACK_START_32   = 0x1FFF8000;
    ;-----------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_W
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__STACK_START_32)
    push dword(__PAGE_TABLES_VMA+0x1000)
    call __load_TP_entry 
    leave

    ;-----------------------------------------------------------------
    ;14th __TASK_1_STACK_START   = 0x1FFFF000; 
    ;-----------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_W
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__TASK_1_STACK_START)
    push dword(__PAGE_TABLES_VMA+0x1000)
    call __load_TP_entry 
    leave

    ; ;-----------------------------------------------------------------
    ; ;15th    __INIT_32_VMA          = Dynamic LMA;
    ; ;-----------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push PAG_P_YES
    push PAG_RW_W
    push PAG_US_SUP
    push PAG_PWT_NO
    push PAG_PCD_NO
    push PAG_A
    push PAG_D
    push PAG_PAT
    push PAG_G_YES
    push dword(__INIT_32_VMA) ; 
    push dword(__PAGE_TABLES_VMA+0x1000)
    call __load_TP_entry
    leave
  ;; Ready to turn on paging, say touching CR registers, go on


    ret ; Return ready to turn on paging