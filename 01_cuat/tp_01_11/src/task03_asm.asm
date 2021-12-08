section .task03_functions
USE32

GLOBAL TASK3_LABEL

EXTERN sum_all_task3
EXTERN Screen_Writing
EXTERN Screen_pointer
EXTERN Load_Keyboard_table_Itself
EXTERN __VIDEO_VMA
VIDEO_BUFFER_ADDR EQU 0x00E80000

TASK3_LABEL:
      mov eax, VIDEO_BUFFER_ADDR
    mov [Screen_pointer],eax;  Reload the screen pointer    

    push    ebp
    mov     ebp, esp
    push dword Keyboard_Buffer_TotalSum_Task3
    push dword Load_Keyboard_table_Itself
    call sum_all_task3
    leave
    
    push    ebp
    mov     ebp, esp
    push 64 ;Column
    push 2  ;Row   
    push dword Keyboard_Buffer_TotalSum_Task3     
    push dword __VIDEO_VMA;:VIDEO_BUFFER_ADDR;[Screen_pointer]
    call Screen_Writing
    leave    
    hlt

section .data_03
Keyboard_Buffer_TotalSum_Task3 dq 0  