#define ERROR_DEFECTO 0
#define EXITO 1

typedef unsigned char byte;
typedef unsigned long dword;

byte __fast_memcpy_rom(   dword*, dword *,dword);
byte __fast_memcpy(   dword*, dword *,dword);
byte IDT_handler_loader(dword *,dword *cs,dword *,dword *,dword *);