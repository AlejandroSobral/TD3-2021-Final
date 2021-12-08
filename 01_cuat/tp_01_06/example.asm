ENTRY (reset)


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
    __SYS_TABLES_VMA   = 0xFFFFFD00; /*I'm moving this later during execution*/
    __RESET_VMA         = 0xFFFFFFF0;

    /*************************LMA***************************/
/* I've implemented a Dinamyc LMA assignation through the code at SECTIONS*/


    __INIT_16_LMA      = 0xFFFF0000;
    __RESET_LMA        = 0xFFFFFFF0; 
    /* __SYS_TABLES_LMA   = 0xFFFFFD00; I'm moving this later during execution*/
    __SYS_TABLES_IDT =  0x00000000; /*IDT BEGIN*/
    __SYS_TABLES_GDT =  0x00000100; /*GDT STARTS AFTER IDT.*/
                                    

MEMORY
{
  ram (rwx):        ORIGIN = 0x00000000,    LENGTH = 0xFFFF0000
  rom (rx):         ORIGIN = 0xFFFF0000,    LENGTH = 64K

}

SECTIONS
{
    .init16 __INIT_16_VMA :
        AT (__INIT_16_LMA)
        {   *(.init16);
            *(.entry); } > rom 
    
    .init32 __INIT_32_VMA : /*VMA*/
         AT ( LOADADDR(.init16) + SIZEOF(.init16) )

        { 
    __INIT_32_LMA = LOADADDR(.init32); /*I need this and further adresses to copy the codes at inits*/
          *(.init32);
          *(.init_pic);
          *(.init_IDT);
          *(.init_timer0); } > rom        


    .sys __SYS_TABLES_VMA :
        AT ( LOADADDR(.init32) + SIZEOF(.init32) )
        
        { 
        /*__SYS_TABLES_LMA = LOADADDR(.sys);I need this and further adresses to copy the codes at inits*/
        *(.sys_tables*); } > rom  
        __sys_size = SIZEOF(.sys);   

    .functions __FUNCTIONS_VMA :
        AT ( LOADADDR(.sys) + SIZEOF(.sys) )
        
        { 
            __FUNCTIONS_LMA = LOADADDR(.functions);/*I need this and further adresses to copy the codes at inits*/
            *(.functions);
            *(.rodata);
            *(.bss); 
            *(.data);
            *(.timer_data);
            *(.keyboard_data); } > ram
    __functions_size = SIZEOF(.functions);        


    .codigo_kernel32 __KERNEL_32_VMA :
        AT ( LOADADDR(.functions) + SIZEOF(.functions) )
        
        {
            __KERNEL_32_LMA = LOADADDR(.codigo_kernel32);/*I need this and further adresses to copy the codes at inits*/
             *(.kernel32); } > ram
    __codigo_kernel32_size = SIZEOF(.codigo_kernel32); 


    .functions_rom __FUNCTIONS_ROM_VMA :
        AT ( LOADADDR(.codigo_kernel32) + SIZEOF(.codigo_kernel32) )
        
        { __FUNCTIONS_ROM_LMA = LOADADDR(.functions_rom);/*I need this and further adresses to copy the codes at inits*/
          *(.functions_rom);
          *(.note.gnu.property); } > rom

     


    .reset __RESET_VMA :
        AT (__RESET_LMA)
        { *(.resetVector); } > rom 


}

