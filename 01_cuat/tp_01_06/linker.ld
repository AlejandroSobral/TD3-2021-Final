ENTRY (reset)

/**********************************STACK*/
    __STACK_START_16 = 0x9000;
    __STACK_END_16 = 0x09FFF;
    __STACK_START_32        = 0x1FF08000;
    __STACK_END_32          = 0x1FF08FFF;
    __STACK_SIZE_32 = ((__STACK_END_32 - __STACK_START_32) / 4); /*32b word*/
     __STACK_SIZE_32 = ((__STACK_END_32 - __STACK_START_32) / 4); /*32b word*/
    /*************************VMA***************************/
   
    __SYS_TABLES_VMA    = 0xFFFFFD00; /*GDT location*/
    __SYS_TABLES_LMA    = 0xFFFFFD00;    

    __RESET_LMA        = 0xFFFFFFF0;
    __RESET_VMA        = 0xFFFFFFF0;

    /*************************LMA***************************/

    __INIT_16_LMA       = 0xFFFF0000;
    __INIT_16_VMA       = 0xFFFF0000;

    __INIT_32_LMA       = 0xFFFF2000;
    __INIT_32_VMA       = 0xFFFF2000;


    __ISR_AND_KEYBOARD_VMA = 0x00100000;
    __ISR_AND_KEYBOARD_LMA = 0xFFFF3000;

    __TABLE_KEYBOARD_VMA = 0x00200000;
    __TABLE_KEYBOARD_LMA = 0xFFFF4000;

    __DATA_LMA = 0xFFFF5000;
    __DATA_VMA = 0x00210000;

    __KERNEL_32_VMA     = 0x00202000;
    __KERNEL_32_LMA     = 0xFFFF6000;

    __FUNCTIONS_VMA     = 0x00302000;    
    __FUNCTIONS_LMA     = 0xFFFF7000;


    __FUNCTIONS_ROM_VMA = 0xFFFFFC00;    
    __FUNCTIONS_ROM_LMA = 0xFFFFFC00;

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
        AT (__INIT_32_LMA)
        { *(.init32);
          *(.init_pic);
          *(.init_IDT);
          *(.init_timer0); } > rom


    .ISR_AND_KEYBOARD_CODE __ISR_AND_KEYBOARD_VMA :
        AT (__ISR_AND_KEYBOARD_LMA)
        { *(.ISR_AND_KEYBOARD);
          } > ram  
    __ISR_AND_KEYBOARD_CODE_size = SIZEOF(.ISR_AND_KEYBOARD_CODE);   

    .TABLE_KEYBOARD_o __TABLE_KEYBOARD_VMA :
        AT (__TABLE_KEYBOARD_LMA)
        { *(.TABLE_KEYBOARD); } > ram  
    __TABLE_KEYBOARD__size = SIZEOF(.TABLE_KEYBOARD_o); 

    .DATA_EXEC_o __DATA_VMA :
        AT (__DATA_LMA)
        { *(.DATA_EXEC); } > ram  
    DATA_EXEC_size = SIZEOF(.DATA_EXEC_o); 

    .codigo_kernel32 __KERNEL_32_VMA :
        AT (__KERNEL_32_LMA)
        { *(.kernel32); } > ram
    __codigo_kernel32_size = SIZEOF(.codigo_kernel32); 


    .functions_o __FUNCTIONS_VMA :
        AT (__FUNCTIONS_LMA)
        { *(.functions);
            *(.rodata);
            *(.bss); 
            *(.data);
 } > ram
    __functions_size = SIZEOF(.functions_o);


    .functions_rom __FUNCTIONS_ROM_VMA :
        AT (__FUNCTIONS_ROM_LMA)
        { *(.functions_rom);
          *(.note.gnu.property); } > rom
  

    .sys __SYS_TABLES_VMA :
        AT (__SYS_TABLES_LMA)
        { *(.sys_tables*); } > rom  
    __sys_size = SIZEOF(.sys);        


    .reset __RESET_VMA :
        AT (__RESET_LMA)
        { *(.resetVector); } > rom 


}

