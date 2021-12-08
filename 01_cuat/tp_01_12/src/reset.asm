BITS 16
GLOBAL reset
EXTERN init16

SECTION .reset
reset:  ;xFFFFFFF0
    cli ; fffffff1  (1)
    cld; Clear directions
    jmp init16  ;   fff fff3    (2)
    
ALIGN 16

