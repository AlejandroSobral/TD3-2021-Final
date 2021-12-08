section .task02_functions
USE32

GLOBAL TASK2_LABEL

EXTERN sum_all_task2
EXTERN Screen_pointer
EXTERN Screen_Writing
EXTERN Load_Keyboard_table_Itself
EXTERN __VIDEO_VMA
VIDEO_BUFFER_ADDR EQU 0x00E80000

TASK2_LABEL:
    ;xchg bx, bx
    mov eax, VIDEO_BUFFER_ADDR
    mov [Screen_pointer],eax;  Reload the screen pointer    

    push    ebp
    mov     ebp, esp
    push dword Keyboard_Buffer_TotalSum_Task2
    push dword Load_Keyboard_table_Itself
    call sum_all_task2
    leave
    
    push    ebp
    mov     ebp, esp
    push 64 ;Column
    push 1  ;Row   
    push dword Keyboard_Buffer_TotalSum_Task2     
    push dword __VIDEO_VMA;:VIDEO_BUFFER_ADDR;[Screen_pointer]
    call Screen_Writing
    leave    
    hlt
    jmp TASK2_LABEL



section .data_02
Keyboard_Buffer_TotalSum_Task2 dq 0   