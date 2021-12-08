%include "inc/processor-flags.h" 
%include "inc/defines.h" 
section .go_paging

GLOBAL go_paging    
EXTERN __SYS_TABLES_PHY      
EXTERN __PAGE_TABLES_PHY     
EXTERN __FUNCTIONS_PHY       
EXTERN __VIDEO_PHY           
EXTERN __ISR_AND_KEYBOARD_PHY
EXTERN __DATA_PHY            
EXTERN __TABLE_KEYBOARD_PHY  
EXTERN __KERNEL_32_PHY       
EXTERN __TASK_1_TEXT_PHY     
EXTERN __TASK_1_BSS_PHY      
EXTERN __TASK_1_DATA_PHY     
EXTERN __TASK_1_RODATA_PHY   
EXTERN __STACK_START_32_PHY  
EXTERN __STACK_END_32_PHY    
EXTERN __STACK_TASK1_PHY
EXTERN __STACK_TASK1_VMA
EXTERN __STACK_TASK2_VMA
EXTERN __STACK_TASK3_VMA
EXTERN __TASK_1_STACK_END_PHY
EXTERN __SYS_TABLES_IDT
EXTERN __PAGE_TABLES_VMA
EXTERN __VIDEO_VMA
EXTERN __load_DTP_entry_rom
EXTERN __load_TP_entry_rom
EXTERN __DATA_VMA
EXTERN __INIT_16_VMA
EXTERN __INIT_32_VMA
EXTERN __STACK_START_32_VMA
EXTERN __FUNCTIONS_VMA
EXTERN __SYS_TABLES_VMA
EXTERN __DATA_VMA
EXTERN __ISR_AND_KEYBOARD_VMA
EXTERN __KERNEL_32_VMA
EXTERN __TASK_1_BSS_VMA
EXTERN __TASK_1_RODATA_VMA
EXTERN __TASK_1_TEXT_VMA
EXTERN __TASK_1_DATA_VMA
EXTERN __TABLE_KEYBOARD_VMA
EXTERN __TASK_1_RODATA_PHY
EXTERN __STACK_TASK1_VMA
EXTERN __STACK_START_32
EXTERN __CR3_KERNEL
EXTERN __CR3_TASK1
EXTERN __CR3_TASK2
EXTERN __CR3_TASK3
EXTERN __CR3_TASK4
EXTERN LOAD_CR3_ROM
EXTERN set_dtp_pt_merged_rom
EXTERN __SYS_TABLES_TSS_PHY
EXTERN __SYS_TABLES_PAG_PHY
EXTERN __SYS_TABLES_PAG_VMA
EXTERN __SYS_TABLES_LMA
EXTERN turn_on_paging
EXTERN __INIT_32_LMA
EXTERN __TASK_3_RODATA_PHY
EXTERN __TASK_3_RODATA_VMA
EXTERN __TASK_2_TEXT_PHY
EXTERN __TASK_2_TEXT_VMA
EXTERN __TASK_3_TEXT_PHY
EXTERN __TASK_3_TEXT_VMA
EXTERN __SYS_TABLES_TSS_VMA
EXTERN __STACK_START_32_PHY
EXTERN __STACK_START_32
EXTERN __STACK_TASK1_PHY
EXTERN __STACK_TASK1_VMA
EXTERN __SYS_TABLES_TSS_VMA
EXTERN __STACK_KERNEL_T1_PHY
EXTERN __STACK_KERNEL_T1_VMA
EXTERN __TASK_1_TEXT_PHY
EXTERN __TASK_2_TEXT_PHY
EXTERN __TASK_3_TEXT_PHY
EXTERN __TASK_4_TEXT_PHY
EXTERN __TASK_1_TEXT_VMA
EXTERN __TASK_2_TEXT_VMA
EXTERN __TASK_3_TEXT_VMA
EXTERN __TASK_4_TEXT_VMA
EXTERN __TEXT_TASK2_PHY
EXTERN __TEXT_TASK3_PHY
EXTERN __TEXT_TASK4_PHY
EXTERN __TEXT_TASK1_VMA
EXTERN __TEXT_TASK2_VMA
EXTERN __TEXT_TASK3_VMA
EXTERN __TEXT_TASK4_VMA
EXTERN __TASK_1_RODATA_PHY
EXTERN __TASK_1_RODATA_VMA
EXTERN __TASK_2_RODATA_PHY
EXTERN __TASK_2_RODATA_VMA
EXTERN __TASK_3_RODATA_PHY
EXTERN __TASK_3_RODATA_VMA
EXTERN __TASK_4_RODATA_PHY
EXTERN __TASK_4_RODATA_VMA
EXTERN __SYS_TABLES_PAG_T1_PHY
EXTERN __SYS_TABLES_PAG_T2_PHY
EXTERN __SYS_TABLES_PAG_T3_PHY
EXTERN __SYS_TABLES_PAG_T4_PHY
EXTERN __SYS_TABLES_PAG_T1_VMA
EXTERN __SYS_TABLES_PAG_T2_VMA
EXTERN __SYS_TABLES_PAG_T3_VMA
EXTERN __SYS_TABLES_PAG_T4_VMA
EXTERN __SYS_TABLES_PAG_T4_PHY
EXTERN __TASK_2_BSS_PHY
EXTERN __TASK_2_BSS_VMA
EXTERN __TASK_3_BSS_PHY
EXTERN __TASK_3_BSS_VMA
EXTERN __TASK_4_BSS_VMA
EXTERN __TASK_4_BSS_PHY
EXTERN __STACK_TASK2_PHY
EXTERN __STACK_TASK2_VMA
EXTERN __STACK_TASK3_PHY
EXTERN __STACK_TASK3_VMA
EXTERN __STACK_TASK4_VMA
EXTERN __STACK_TASK4_PHY
EXTERN __TASK_2_DATA_PHY
EXTERN __TASK_2_DATA_VMA
EXTERN __TASK_3_DATA_PHY
EXTERN __TASK_3_DATA_VMA
EXTERN __TASK_4_DATA_VMA
EXTERN __TASK_4_DATA_PHY
EXTERN __STACK_TASK1_PHY
EXTERN __STACK_TASK1_VMA
EXTERN __FUNCTIONS_ROM_LMA




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
_4k         EQU 0x400   ; 1024 or 0x400

SUP_R_P EQU 0x01
SUP_W_P EQU 0x03
US_R_P  EQU 0x05
US_W_P  EQU 0x07
_1024 EQU 0x400

go_paging:


;;;;;;;;;;;;;;;START - Paging;;;;;;;;;;;;;;;;;;;;;       
    cli

    ;; Clean all CR3 DTP & 1st page - 1024 + 1024
    mov edi,__CR3_KERNEL  
     mov ecx,_1024 *10      
    xor eax,eax           
    rep stosd   

    mov edi,__CR3_TASK1   
    mov ecx,_1024 *2      
    xor eax,eax           
    rep stosd   
    
    mov edi,__CR3_TASK2   
    mov ecx,_1024 *2      
    xor eax,eax           
    rep stosd   

    mov edi,__CR3_TASK3   
    mov ecx,_1024 *2      
    xor eax,eax           
    rep stosd

    ; Set CR3 at DPT base add
    push    ebp
    mov     ebp, esp
    push    PAG_PWT_YES
    push    PAG_PCD_YES
    push    dword __PAGE_TABLES_VMA
    call    LOAD_CR3_ROM
    mov     cr3, eax
    leave    

    ;; After setting CR3x, go paging PT's.
    push    ebp
    mov     ebp, esp
    push SUP_R_P 
    push dword(__ISR_AND_KEYBOARD_PHY)
    push dword(__ISR_AND_KEYBOARD_VMA)
    push dword(__CR3_KERNEL)  
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push SUP_R_P     
    push dword(__KERNEL_32_PHY)
    push dword(__KERNEL_32_VMA)
    push dword(__CR3_KERNEL)  
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push SUP_R_P     
    push dword(__FUNCTIONS_PHY)
    push dword(__FUNCTIONS_VMA)
    push dword(__CR3_KERNEL)  
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push SUP_W_P     
    push dword(__SYS_TABLES_PHY)
    push dword(__SYS_TABLES_VMA)
    push dword(__CR3_KERNEL) 
    call set_dtp_pt_merged_rom
    leave
    ;;    
    push    ebp
    mov     ebp, esp
    push SUP_W_P     
    push dword(__SYS_TABLES_TSS_PHY)
    push dword(__SYS_TABLES_TSS_VMA)
    push dword(__CR3_KERNEL) 
    call set_dtp_pt_merged_rom
    leave 
    ;;
    push    ebp
    mov     ebp, esp
    push SUP_W_P     
    push dword(__SYS_TABLES_PAG_PHY)
    push dword(__SYS_TABLES_PAG_VMA)
    push dword(__CR3_KERNEL)  
    call set_dtp_pt_merged_rom
    leave 
    ;;    
    push    ebp
    mov     ebp, esp
    push SUP_W_P     
    push dword(__VIDEO_PHY)
    push dword(__VIDEO_VMA)
    push dword(__CR3_KERNEL)  
    call set_dtp_pt_merged_rom
    leave
    ;;   
    push    ebp
    mov     ebp, esp
    push SUP_W_P     
    push dword(__DATA_PHY)
    push dword(__DATA_VMA)
    push dword(__CR3_KERNEL)  
    call set_dtp_pt_merged_rom
    leave 
    ;;
    push    ebp
    mov     ebp, esp
    push SUP_W_P     
    push dword(__STACK_START_32_PHY)
    push dword(__STACK_START_32)
    push dword(__CR3_KERNEL)  
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push US_W_P     
    push dword(__STACK_TASK1_PHY)
    push dword(__STACK_TASK1_VMA)
    push dword(__CR3_KERNEL)  
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push US_W_P     
    push dword(__TABLE_KEYBOARD_PHY)
    push dword(__TABLE_KEYBOARD_VMA)
    push dword(__CR3_KERNEL)  
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push SUP_W_P
    push dword(__FUNCTIONS_ROM_LMA) ; Rom init
    push dword(__FUNCTIONS_ROM_LMA)
    push dword(__CR3_KERNEL)          
    call set_dtp_pt_merged_rom
    leave
    ;;
    ; CHEQUEAR ESTO!!**
    push    ebp
    mov     ebp, esp
    push SUP_W_P
    push dword(__INIT_32_VMA) ; Rom init
    push dword(__INIT_32_VMA)
    push dword(__CR3_KERNEL)          
    call set_dtp_pt_merged_rom
    leave
    ;;       TASK1
    push    ebp
    mov     ebp, esp                                            
    push SUP_R_P
    push dword(__ISR_AND_KEYBOARD_PHY)
    push dword(__ISR_AND_KEYBOARD_VMA)
    push dword(__CR3_TASK1)         
    call set_dtp_pt_merged_rom
    leave                       
    ;;
    push    ebp
    mov     ebp, esp                                     
    push US_R_P;SUP_R_P
    push dword(__FUNCTIONS_PHY)
    push dword(__FUNCTIONS_VMA)
    push dword(__CR3_TASK1)         
    call set_dtp_pt_merged_rom
    leave                  
    ;;
    push    ebp
    mov     ebp, esp                    
    push SUP_W_P                        
    push dword(__SYS_TABLES_TSS_PHY)            
    push dword(__SYS_TABLES_TSS_VMA)            
    push dword(__CR3_TASK1)                       
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp                                          
    push US_W_P;SUP_W_P
    push dword(__VIDEO_PHY)
    push dword(__VIDEO_VMA)
    push dword(__CR3_TASK1)               
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp                                          
    push SUP_W_P
    push dword(__DATA_PHY)
    push dword(__DATA_VMA)
    push dword(__CR3_TASK1)                           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push SUP_W_P
    push dword(__STACK_START_32_PHY)
    push dword(__STACK_START_32)
    push dword(__CR3_TASK1)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push SUP_R_P ;US_R_P
    push dword(__TASK_1_TEXT_PHY)
    push dword(__TASK_1_TEXT_VMA)
    push dword(__CR3_TASK1)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push SUP_R_P;US_R_P
    push dword(__TASK_1_RODATA_PHY)
    push dword(__TASK_1_RODATA_VMA)
    push dword(__CR3_TASK1)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push US_W_P                                            
    push dword(__SYS_TABLES_PHY)
    push dword(__SYS_TABLES_VMA)                         
    push dword(__CR3_TASK1)                   
    call set_dtp_pt_merged_rom
    leave
    ;;   
    push    ebp
    mov     ebp, esp
    push US_W_P
    push dword(__SYS_TABLES_PAG_T1_PHY)
    push dword(__SYS_TABLES_PAG_T1_VMA)
    push dword(__CR3_TASK1)         
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp                               
    push US_W_P
    push dword(__TABLE_KEYBOARD_PHY)
    push dword(__TABLE_KEYBOARD_VMA)
    push dword(__CR3_TASK1)                    
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push US_W_P
    push dword(__TASK_1_BSS_PHY)
    push dword(__TASK_1_BSS_VMA)
    push dword(__CR3_TASK1)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push US_W_P
    push dword(__TASK_1_DATA_PHY)
    push dword(__TASK_1_DATA_VMA)
    push dword(__CR3_TASK1)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push US_W_P
    push dword(__STACK_TASK1_PHY)
    push dword(__STACK_TASK1_VMA)
    push dword(__CR3_TASK1)           
    call set_dtp_pt_merged_rom
    leave


;------------------TASK 2-----------------

    push    ebp
    mov     ebp, esp
    push SUP_R_P                        
    push dword(__SYS_TABLES_PHY)                 
    push dword(__SYS_TABLES_VMA)              
    push dword(__CR3_TASK2)                   
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp                                           
    push SUP_R_P
    push dword(__ISR_AND_KEYBOARD_PHY)
    push dword(__ISR_AND_KEYBOARD_VMA)
    push dword(__CR3_TASK2)         
    call set_dtp_pt_merged_rom 
    leave                     
    ;;
    push    ebp
    mov     ebp, esp                                      
    push US_R_P;SUP_R_P
    push dword(__FUNCTIONS_PHY)
    push dword(__FUNCTIONS_VMA)
    push dword(__CR3_TASK2)         
    call set_dtp_pt_merged_rom
    leave                  
    ;;
    push    ebp
    mov     ebp, esp
    push SUP_W_P                                                   
    push dword(__SYS_TABLES_TSS_PHY)               
    push dword(__SYS_TABLES_TSS_VMA)               
    push dword(__CR3_TASK2)                       
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push SUP_W_P
    push dword(__SYS_TABLES_PAG_T2_PHY)
    push dword(__SYS_TABLES_PAG_T2_VMA)
    push dword(__CR3_TASK2)         
    call set_dtp_pt_merged_rom
    leave
    ;;    
    push    ebp
    mov     ebp, esp                                
    push US_W_P;SUP_W_P
    push dword(__VIDEO_PHY)
    push dword(__VIDEO_VMA)
    push dword(__CR3_TASK2)               
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp                                          
    push SUP_W_P
    push dword(__DATA_PHY)
    push dword(__DATA_VMA)
    push dword(__CR3_TASK2)                           
    call set_dtp_pt_merged_rom
    leave

;     push __STACK_KERNEL_T2_PHY
;     push __STACK_KERNEL_T2_VMA

    push    ebp
    mov     ebp, esp
    push SUP_W_P
    push dword(__STACK_START_32_PHY)
    push dword(__STACK_START_32)
    push dword(__CR3_TASK2)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push SUP_R_P;US_R_P
    push dword(__TASK_2_TEXT_PHY)
    push dword(__TASK_2_TEXT_VMA)
    push dword(__CR3_TASK2)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp
    push US_R_P
    push dword(__TASK_2_RODATA_PHY)
    push dword(__TASK_2_RODATA_VMA)
    push dword(__CR3_TASK2)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp                              
    push US_W_P
    push dword(__TABLE_KEYBOARD_PHY)
    push dword(__TABLE_KEYBOARD_VMA)
    push dword(__CR3_TASK2)                    
    call set_dtp_pt_merged_rom
    leave
    ;;   
    push    ebp
    mov     ebp, esp 
    push US_W_P
    push dword(__TASK_2_BSS_PHY)
    push dword(__TASK_2_BSS_VMA)
    push dword(__CR3_TASK2)            
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push US_W_P
    push dword(__TASK_2_DATA_PHY)
    push dword(__TASK_2_DATA_VMA)
    push dword(__CR3_TASK2)           
    call set_dtp_pt_merged_rom
    leave 
    ;;
    push    ebp
    mov     ebp, esp 
    push US_W_P  
    push dword(__STACK_TASK2_PHY)
    push dword(__STACK_TASK2_VMA)
    push dword(__CR3_TASK2)            
    call set_dtp_pt_merged_rom
    leave    

;------------------TASK 3-----------------

    push    ebp
    mov     ebp, esp 
    push SUP_R_P                                      
    push dword(__SYS_TABLES_PHY)                
    push dword(__SYS_TABLES_VMA )                 
    push dword(__CR3_TASK3)                   
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp                                           
    push US_W_P;SUP_R_P
    push dword(__VIDEO_PHY)
    push dword(__VIDEO_VMA)
    push dword(__CR3_TASK3)               
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp                                            
    push SUP_R_P
    push dword(__ISR_AND_KEYBOARD_PHY)
    push dword(__ISR_AND_KEYBOARD_VMA)
    push dword(__CR3_TASK3)         
    call set_dtp_pt_merged_rom                       
    leave
    ;;
    push    ebp
    mov     ebp, esp                                       
    push US_R_P;SUP_R_P
    push dword(__FUNCTIONS_PHY)
    push dword(__FUNCTIONS_VMA)
    push dword(__CR3_TASK3)         
    call set_dtp_pt_merged_rom                   
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push SUP_W_P                                            
    push dword(__SYS_TABLES_TSS_PHY)               
    push dword(__SYS_TABLES_TSS_VMA)              
    push dword(__CR3_TASK3)                       
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push SUP_W_P
    push dword(__SYS_TABLES_PAG_T3_PHY)
    push dword(__SYS_TABLES_PAG_T3_VMA)
    push dword(__CR3_TASK3)         
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp                                           
    push SUP_W_P
    push dword(__DATA_PHY)
    push dword(__DATA_VMA)
    push dword(__CR3_TASK3)                           
    call set_dtp_pt_merged_rom
    leave
;     push __STACK_KERNEL_T3_PHY
;     push __STACK_KERNEL_T3_VMA
    push    ebp
    mov     ebp, esp 
    push SUP_W_P
    push dword(__STACK_START_32_PHY)
    push dword(__STACK_START_32)
    push dword(__CR3_TASK3)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push SUP_R_P;US_R_P
    push dword(__TASK_3_TEXT_PHY)
    push dword(__TASK_3_TEXT_VMA)
    push dword(__CR3_TASK3)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push US_R_P
    push dword(__TASK_3_RODATA_PHY)
    push dword(__TASK_3_RODATA_VMA)
    push dword(__CR3_TASK3)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp                                
    push US_W_P
    push dword(__TABLE_KEYBOARD_PHY)
    push dword(__TABLE_KEYBOARD_VMA)
    push dword(__CR3_TASK3)                    
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push US_W_P
    push dword( __TASK_3_BSS_PHY)
    push dword(__TASK_3_BSS_VMA)
    push dword(__CR3_TASK3)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push US_W_P
    push dword(__TASK_3_DATA_PHY)
    push dword(__TASK_3_DATA_VMA)
    push dword(__CR3_TASK3)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push US_W_P  
    push dword(__STACK_TASK3_PHY)
    push dword(__STACK_TASK3_VMA)
    push dword(__CR3_TASK3)           
    call set_dtp_pt_merged_rom
    leave


;------------------TASK 4-----------------

    push    ebp
    mov     ebp, esp 
    push SUP_R_P                                      
    push dword(__SYS_TABLES_PHY)                
    push dword(__SYS_TABLES_VMA )                 
    push dword(__CR3_TASK4)                   
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp                                           
    push US_W_P;SUP_R_P
    push dword(__VIDEO_PHY)
    push dword(__VIDEO_VMA)
    push dword(__CR3_TASK4)               
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp                                            
    push SUP_R_P
    push dword(__ISR_AND_KEYBOARD_PHY)
    push dword(__ISR_AND_KEYBOARD_VMA)
    push dword(__CR3_TASK4)         
    call set_dtp_pt_merged_rom                       
    leave
    ;;
    push    ebp
    mov     ebp, esp                                       
    push US_R_P;SUP_R_P
    push dword(__FUNCTIONS_PHY)
    push dword(__FUNCTIONS_VMA)
    push dword(__CR3_TASK4)         
    call set_dtp_pt_merged_rom                   
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push SUP_W_P                                            
    push dword(__SYS_TABLES_TSS_PHY)               
    push dword(__SYS_TABLES_TSS_VMA)              
    push dword(__CR3_TASK4)                       
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push SUP_W_P
    push dword(__SYS_TABLES_PAG_T4_PHY)
    push dword(__SYS_TABLES_PAG_T4_VMA)
    push dword(__CR3_TASK4)         
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp                                           
    push SUP_W_P
    push dword(__DATA_PHY)
    push dword(__DATA_VMA)
    push dword(__CR3_TASK4)                           
    call set_dtp_pt_merged_rom
    leave
;     push __STACK_KERNEL_T3_PHY
;     push __STACK_KERNEL_T3_VMA
    push    ebp
    mov     ebp, esp 
    push SUP_W_P
    push dword(__STACK_START_32_PHY)
    push dword(__STACK_START_32)
    push dword(__CR3_TASK4)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push SUP_R_P ; US_R_P
    push dword(__TASK_4_TEXT_PHY)
    push dword(__TASK_4_TEXT_VMA)
    push dword(__CR3_TASK4)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push US_R_P
    push dword(__TASK_4_RODATA_PHY)
    push dword(__TASK_4_RODATA_VMA)
    push dword(__CR3_TASK4)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp                                
    push US_W_P
    push dword(__TABLE_KEYBOARD_PHY)
    push dword(__TABLE_KEYBOARD_VMA)
    push dword(__CR3_TASK4)                    
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push US_W_P
    push dword( __TASK_4_BSS_PHY)
    push dword(__TASK_4_BSS_VMA)
    push dword(__CR3_TASK4)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push US_W_P
    push dword(__TASK_4_DATA_PHY)
    push dword(__TASK_4_DATA_VMA)
    push dword(__CR3_TASK4)           
    call set_dtp_pt_merged_rom
    leave
    ;;
    push    ebp
    mov     ebp, esp 
    push SUP_W_P ;US_W_P  
    push dword(__STACK_TASK4_PHY)
    push dword(__STACK_TASK4_VMA)
    push dword(__CR3_TASK4)           
    call set_dtp_pt_merged_rom
    leave


    ;; Ready to turn on paging, say touching CR registers, go on
    
    jmp turn_on_paging ; Return ready to turn on paging