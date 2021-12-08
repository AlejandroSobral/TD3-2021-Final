;Escribir un programa que se ejecute en una ROM de 64kB y permita copiarse a sí mismo en cualquier zona de memoria.
 ;A tal fin se deberá implementar la función void *td3_memcopy(void *destino, const void *origen, unsigned int num_bytes);
 ;Para validar el correcto funcionamiento del programa, el mismo deberá copiarse en las direcciones indicadas a continuación y mediante Bochs verificar 
 ;que la memoria se hayaescrito correctamente.
 ;i.0x00000
 ;ii.0xF0000
BITS 16
GLOBAL entry



DEST_ADRESS  EQU 0x0000; Start destination adress
DEST_ADRESS2 EQU 0xF000; Start destination adress 
;msg_length EQU 0x20; Dummy msg_length

SECTION .entry


entry:
    xor ax,ax; Clear ax
    mov ds, ax; Clear ds
    mov ss, ax; Set stack segment as zero
    mov sp, 0x8000; Set the stack pointer top adress. At middle from DestAdd 1 & Dest Add2

;***********************Load first destination info data****************************************;
    mov ax, DEST_ADRESS
    mov bx, MSG_LENGTH
    mov cx, memcopy

    call memcopy

    mov ax, DEST_ADRESS2
    mov bx, MSG_LENGTH; Same length than last time
    mov cx, memcopy

    call memcopy

    jmp to_sleep


memcopy:

    mov di, ax; Load destiny to destination register
    mov si, cx; Load source, code itself!
    mov cx, bx; Set lenght to bx for repetion
    rep cs movsb ; Move bytes 
    ;; MOVSB INFO:
    ;; Move byte at adreess SI to adress DI. In this particular case, I'm using the (CS) Code Segment as source register. That's why
    ;; I wrote cs before movsb.

;; SEGMENT REGISTERS INFO P77 & 78 AT Intel's Manual.

MSG_LENGTH EQU ($ - memcopy); Fetch the length size right here

    ret

to_sleep:
    xchg bx, bx ; Magic breakpoint
    hlt

ALIGN 16
