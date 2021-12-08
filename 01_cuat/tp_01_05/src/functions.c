#include "../inc/functions.h"


__attribute__(( section(".functions"))) byte __fast_memcpy(dword*src,dword *dst,dword length)
{
    byte status = ERROR_DEFECTO;

    if(length>0)
    {
        while(length)
        {
            length--;
            *dst++=*src++;
        }
        status = EXITO;
    }

    return (status);
}

__attribute__(( section(".functions"))) byte IDT_handler_loader(dword *exception_num,
                                                             dword *cs, 
                                                             dword *handler,
                                                             dword *attr, 
                                                             dword *idt_dir){ 
    byte i;
    for (i = 0; i < (2 * (dword)exception_num) ; i++){
        *idt_dir++;
    }

    dword high = (((dword)cs)<<0x10);
    dword low = (0x0000FFFF&(dword)handler);

    *idt_dir = high|low;
    *idt_dir++;

    high = (0xFFFF0000&(dword)handler);
    //low = 0x00008E00;
    low = (0xFFFF & ((dword)attr)<<0x8);

    *idt_dir = high|low;
    
    return 1;
}