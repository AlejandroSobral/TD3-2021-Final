section .task03_functions
USE32

GLOBAL TASK3_LABEL

EXTERN sum_all_task3
EXTERN Screen_Writing
EXTERN Screen_pointer
EXTERN Load_Keyboard_table_Itself
EXTERN __VIDEO_VMA
DATA_TABLE_SIZE EQU 10
VIDEO_BUFFER_ADDR EQU 0x00E80000

TASK3_LABEL:
    ;; SIMD ADD ! .-.-.-.-.
    xor ecx, ecx
    mov esi, Load_Keyboard_table_Itself          ;Data Source        
    mov edi, Keyboard_Buffer_TotalSum_Task3      ;Total Sum                 
    mov ebx, DATA_TABLE_SIZE
    pxor mm0, mm0

ADD_T3:
    paddq qword mm0, [esi]
    add esi, 8                          
    inc ecx
    cmp ecx, ebx
    jne ADD_T3
    movq qword [edi], mm0               
    ;; END SIMD ADD .-.-.-.-.

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