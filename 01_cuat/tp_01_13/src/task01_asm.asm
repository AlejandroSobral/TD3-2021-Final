%include "inc/defines.h" 
;; CHECK P. 101 de los PDF de paginacion
section .task01_functions
USE32

GLOBAL task01
GLOBAL TASK1_LABEL
GLOBAL TASK1_AC_EXCEP

;Global Variables
EXTERN buffer_Clear
EXTERN KEYBOARD_BUFFER_ITSELF
EXTERN DIGIT_TABLE_KERNEL
EXTERN _64BITS_AVERAGE_FUNC
EXTERN SCREEN_WRITING
EXTERN SCREEN_POINTER
EXTERN __VIDEO_VMA
DIGIT_TOTAL_TABLE_SIZE EQU 160
VIDEO_BUFFER_ADDR EQU 0x00E80000

task01:
TASK1_LABEL:

    ;xchg bx, bx
    ;Ask Kernel to get data
    mov esi, DIGIT_TABLE_KERNEL               
    mov edi, DIGIT_TABLE_TASK1    
    mov ecx, DIGIT_TOTAL_TABLE_SIZE                           
    mov eax, SYS_CALL_READ                                      
    int 0x80
     
    ;xchg bx, bx    

    push    ebp
    mov     ebp, esp
    push dword DIGIT_TABLE_AVERAGE
    push dword DIGIT_TABLE_TASK1
    call _64BITS_AVERAGE_FUNC
    leave

    ; SYS_CALL_HALT     EQU     0
    ; SYS_CALL_READ     EQU     1
    ; SYS_CALL_WRITE    EQU     2
    ; SYS_CALL_SCREEN   EQU     3

    mov esi, __VIDEO_VMA               
    mov edi, DIGIT_TABLE_AVERAGE        
    mov edx, 0                          
    mov ecx, 64                         
    mov eax, SYS_CALL_SCREEN                                      
    int 0x80   

    mov eax, SYS_CALL_HALT                 
    int 0x80
    jmp TASK1_LABEL



section .data_01
DIGIT_TABLE_TASK1 resb 190 ;
DIGIT_TABLE_AVERAGE resb 19 ; 
section .task01_functions
TASK1_AC_EXCEP:
        mov eax, 1b
        
       
