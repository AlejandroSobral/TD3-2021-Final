#include "../inc/functions.h"
__attribute__(( section(".data_04")))
 byte  dummy_bss_04 = 2; //.data

  __attribute__(( section(".rodata_4")))
const byte rodata_dummy_task4 = 1; 

__attribute__(( section(".bss_04")))
byte bss_dummy_task4; 

__attribute__(( section(".data_04")))
byte data_dummy_task4 = 0; 