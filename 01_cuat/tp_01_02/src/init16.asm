BITS 16
;Start and jump by now
GLOBAL init16
EXTERN entry

SECTION .init16
init16:
    jmp entry