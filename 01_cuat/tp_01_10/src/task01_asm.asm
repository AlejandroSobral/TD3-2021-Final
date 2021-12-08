
;; CHECK P. 101 de los PDF de paginacion
section .task01_functions
USE32

GLOBAL task01
;Global Variables
EXTERN buffer_Clear
EXTERN Keyboard_Buffer_Itself
EXTERN Load_Keyboard_table_Itself
EXTERN _64bits_average_func
EXTERN Screen_Writing
EXTERN Screen_pointer
EXTERN Digit_Table_Average
EXTERN Flag_Task_1;
EXTERN _access_average_memory
VIDEO_BUFFER_ADDR EQU 0x000B8000

task01:

wait_for_flag:
    mov eax, dword [Flag_Task_1]
    cmp eax, 0x01;
    je Average_on;
    jmp wait_for_flag; No task
    nop

Average_on:
    mov eax, 0x00
    mov dword [Flag_Task_1], eax;Reset task flag

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
    push dword [Screen_pointer]
    call Screen_Writing
    leave    


    ;Access to random position may cause a Page Fault (PF)
    mov dword eax,  [Digit_Table_Average]
    mov dword ebx,  [eax]



    ret