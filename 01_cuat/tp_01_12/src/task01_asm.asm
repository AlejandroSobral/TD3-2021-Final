
;; CHECK P. 101 de los PDF de paginacion
section .task01_functions
USE32

GLOBAL task01
GLOBAL TASK1_LABEL

;Global Variables
EXTERN buffer_Clear
EXTERN Keyboard_Buffer_Itself
EXTERN Load_Keyboard_table_Itself
EXTERN _64bits_average_func
EXTERN Screen_Writing
EXTERN Screen_pointer
EXTERN Flag_Task_1;
EXTERN _access_average_memory
EXTERN __VIDEO_VMA
VIDEO_BUFFER_ADDR EQU 0x00E80000

task01:
TASK1_LABEL:


; wait_for_flag:
;     mov eax, dword [Flag_Task_1]
;     cmp eax, 0x01;
;     je Average_on;
;     jmp wait_for_flag; No task
;     nop

; Average_on:
;     mov eax, 0x00
;     mov dword [Flag_Task_1], eax;Reset task flag

    mov eax, VIDEO_BUFFER_ADDR
    mov [Screen_pointer],eax;  Reload the screen pointer    

    push    ebp
    mov     ebp, esp
    push dword Digit_Table_Average
    push dword Load_Keyboard_table_Itself
    call _64bits_average_func
    leave

    push    ebp
    mov     ebp, esp
    push 64 ;Column
    push 0  ;Row   
    push dword Digit_Table_Average     
    push dword __VIDEO_VMA ;Screen_pointer

    call Screen_Writing
    ;xchg bx, bx

    leave    


    ;Access to random position may cause a Page Fault (PF)
    ;Not any more
    ;mov dword eax,  [Digit_Table_Average]
    ;mov dword ebx,  [eax]

    hlt
    jmp TASK1_LABEL


section .data_01
Digit_Table_Average resb 19 ;    