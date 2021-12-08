section .task04_functions
USE32

GLOBAL TASK4_LABEL

TASK4_LABEL:
    ;xchg bx, bx
    mov eax, 0x4444
    xor eax, eax
    hlt
    jmp TASK4_LABEL