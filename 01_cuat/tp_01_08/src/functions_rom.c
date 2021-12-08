#include "../inc/functions.h"


__attribute__(( section(".functions_rom"))) byte __fast_memcpy_rom(bits32_v* src,bits32_v *dst,bits32_v length)
{
    byte status = ERROR_CODE;

    if(length>0)
    {
        while(length)
        {
            length--;
            *dst++=*src++;
        }
        status = OK_CODE;
    }

    return (status);
}