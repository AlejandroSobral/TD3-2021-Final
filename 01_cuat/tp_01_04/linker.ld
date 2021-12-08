ENTRY (reset)


    __EH_FRAME = 0x00060000;
    __DATA_NO_INIT = 0x0050000;

    __STACK_START_16 = 0x9000;
    __STACK_END_16 = 0x09FFF;
    __STACK_START_32        = 0x2FF08000;
    __STACK_END_32          = 0x2FF08FFF;
    __STACK_SIZE_32 = ((__STACK_END_32 - __STACK_START_32) / 4); /*32b word*/
     __STACK_SIZE_32 = ((__STACK_END_32 - __STACK_START_32) / 4); /*32b word*/
    /*************************VMA***************************/
    __FUNCTIONS_VMA     = 0x00100000;
    __KERNEL_32_VMA     = 0x00202000;

    __INIT_16_VMA       = 0xFFFF0000;
    __INIT_32_VMA       = 0xFFFFF800;
    __FUNCTIONS_ROM_VMA = 0xFFFFFC00;
    __SYS_TABLES_VMA   = 0xFFFFFD00; /*GDT location*/
    __RESET_VMA         = 0xFFFFFFF0;

    /*************************LMA***************************/

    __INIT_16_LMA       = 0xFFFF0000;

    __FUNCTIONS_LMA     = 0xFFFF1000;
    __KERNEL_32_LMA     = 0xFFFF2000;


    __INIT_32_LMA       = 0xFFFFF800;

    __FUNCTIONS_ROM_LMA = 0xFFFFFC00;
    __SYS_TABLES_LMA   = 0xFFFFFD00;
    __RESET_LMA         = 0xFFFFFFF0;


MEMORY
{
  ram (rwx):        ORIGIN = 0x00000000,    LENGTH = 0xFFFF0000
  rom (rx):         ORIGIN = 0xFFFF0000,    LENGTH = 64K

}




SECTIONS
{
    .codigo_kernel32 __KERNEL_32_VMA :
        AT (__KERNEL_32_LMA)
        { *(.kernel32); } > ram
    __codigo_kernel32_size = SIZEOF(.codigo_kernel32); 


    .functions __FUNCTIONS_VMA :
        AT (__FUNCTIONS_LMA)
        { *(.functions); } > ram
    __functions_size = SIZEOF(.functions);


    .init16 __INIT_16_VMA :
        AT (__INIT_16_LMA)
        {   *(.init16);
            *(.entry); } > rom 


    .init32 __INIT_32_VMA : /*VMA*/
        AT (__INIT_32_LMA)
        { *(.init32); } > rom

    .functions_rom __FUNCTIONS_ROM_VMA :
        AT (__FUNCTIONS_ROM_LMA)
        { *(.functions_rom);
          *(.note.gnu.property); } > rom



    .data __SYS_TABLES_VMA :
        AT (__SYS_TABLES_LMA)
        { *(.sys_tables*); } > rom  

    .reset __RESET_VMA :
        AT (__RESET_LMA)
        { *(.resetVector); } > rom 








}

