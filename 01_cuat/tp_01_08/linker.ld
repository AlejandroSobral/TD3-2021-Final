ENTRY (reset)

/**********************************STACK************************/
    __STACK_START_16 = 0x9000;
    __STACK_END_16 = 0x09FFF;

    __STACK_SIZE_32 = ((__STACK_END_32 - __STACK_START_32) / 4); /*32b word*/
    __STACK_SIZE_32 = ((__STACK_END_32 - __STACK_START_32) / 4); /*32b word*/

/******LMA******/

    __SYS_TABLES_LMA       = 0xFFFF0000; /*Init rom*/
    __INIT_16_LMA          = 0xFFFF9000;
    __RESET_LMA            = 0xFFFFFFF0;              

/*****VMA******/

    __SYS_TABLES_VMA       = 0x00000000; /*GDT location*/   
    __SYS_TABLES_IDT       = 0x00000000; /*IDT BEGIN*/
    __SYS_TABLES_GDT       = 0x00000100; /*GDT STARTS AFTER IDT.*/
    __PAGE_TABLES_VMA      = 0x00010000;
    __FUNCTIONS_VMA        = 0x00050000;      
    __VIDEO_VMA            = 0x000B8000;
    __ISR_AND_KEYBOARD_VMA = 0x00100000;
    __DATA_VMA             = 0x00200000;
    __TABLE_KEYBOARD_VMA   = 0x00210000;              
    __KERNEL_32_VMA        = 0x00220000;
    __TASK_1_TEXT_VMA      = 0x00310000;  /* .text TASK1*/
    __TASK_1_BSS_VMA       = 0x00320000;  /* .bss TASK1*/
    __TASK_1_DATA_VMA      = 0x00330000;  /* .data TASK1*/
    __TASK_1_RODATA_VMA    = 0x00340000;  /* .rodata TASK1*/  
    __STACK_START_32       = 0x1FFF8000;
    __STACK_END_32         = 0x1FFF8FFF;
    __TASK_1_STACK_START   = 0x1FFFF000;  /* Task1 Stack */
    __TASK_1_STACK_END     = 0x1FFFFC00;             
    __INIT_16_VMA          = __INIT_16_LMA;
    __INIT_32_VMA          = __INIT_32_LMA;
    __FUNCTIONS_ROM_VMA    = __FUNCTIONS_ROM_LMA;    
    __RESET_VMA            = __RESET_LMA;                                    


MEMORY
{
  ram (rwx):        ORIGIN = 0x00000000,    LENGTH = 0xFFFF0000
  rom (rx):         ORIGIN = 0xFFFF0000,    LENGTH = 64K
}

SECTIONS
{
    .sys_tables __SYS_TABLES_VMA :
        AT ( __SYS_TABLES_LMA )
        { *(.sys*);} > ram
    __sys_tables_size = SIZEOF(.sys_tables);

    __DATA_LMA = LOADADDR(.sys_tables) + SIZEOF(.sys_tables);
    .__DATA__o __DATA_VMA :
        AT (__DATA_LMA)
        { *(.__DATA__); } > ram  
    __DATA__size = SIZEOF(.__DATA__o);

    __ISR_AND_KEYBOARD_LMA = LOADADDR(.__DATA__o) + SIZEOF(.__DATA__o);
    .ISR_AND_KEYBOARD_CODE __ISR_AND_KEYBOARD_VMA :
        AT (__ISR_AND_KEYBOARD_LMA)
        { *(.ISR_AND_KEYBOARD);
          } > ram     
    __ISR_AND_KEYBOARD_CODE_size = SIZEOF(.ISR_AND_KEYBOARD_CODE);


    __TABLE_KEYBOARD_LMA = LOADADDR(.ISR_AND_KEYBOARD_CODE) + SIZEOF(.ISR_AND_KEYBOARD_CODE);
        .__TABLE_KEYBOARD_VMA_o __TABLE_KEYBOARD_VMA :
        AT (__TABLE_KEYBOARD_LMA)
        { *(.TABLE_KEYBOARD); } > ram  
    __TABLE_KEYBOARD_VMA_size = SIZEOF(.__TABLE_KEYBOARD_VMA_o);

    __KERNEL_32_LMA = LOADADDR(.__TABLE_KEYBOARD_VMA_o) + SIZEOF(.__TABLE_KEYBOARD_VMA_o);
    .codigo_kernel32 __KERNEL_32_VMA :
        AT (__KERNEL_32_LMA)
        { *(.kernel32); } > ram
    __codigo_kernel32_size = SIZEOF(.codigo_kernel32);

    __FUNCTIONS_LMA = LOADADDR(.codigo_kernel32) + SIZEOF(.codigo_kernel32);
    .functions_o __FUNCTIONS_VMA :
        AT (__FUNCTIONS_LMA)
        { *(.functions);
            ./bin/functions.elf*(.rodata);
            ./bin/functions.elf*(.bss); 
            ./bin/functions.elf*(.data);} > ram
    __functions_size = SIZEOF(.functions_o); 

    __TASK_1_TEXT_LMA = LOADADDR(.functions_o) + SIZEOF(.functions_o);    
    .TASK_1_TEXT_o __TASK_1_TEXT_VMA :
        AT (__TASK_1_TEXT_LMA)
        { *(.task01_functions);
        ./bin/task01.elf(.text);
        ./bin/task01.elf(.note*); } > ram  
    TASK_1_TEXT_size = SIZEOF(.TASK_1_TEXT_o);

    __TASK_1_BSS_LMA = LOADADDR(.TASK_1_TEXT_o) + SIZEOF(.TASK_1_TEXT_o);
    .TASK_1_BSS_o __TASK_1_BSS_VMA :
        AT (__TASK_1_BSS_LMA)
        {./bin/task01.elf(.bss);} > ram
    TASK_1_bss_size = SIZEOF(.TASK_1_BSS_o); 

    __TASK_1_DATA_LMA = LOADADDR(.TASK_1_BSS_o) + SIZEOF(.TASK_1_BSS_o); 
    .task_1_data __TASK_1_DATA_VMA :
        AT (__TASK_1_DATA_LMA)
        {./bin/task01.elf(.data);} > ram
    task_1_data_size = SIZEOF(.task_1_data);       

    __TASK_1_RODATA_LMA = LOADADDR(.task_1_data) + SIZEOF(.task_1_data); 
    .task_1_rodata __TASK_1_RODATA_VMA :
        AT (__TASK_1_RODATA_LMA)
        {./bin/task01.elf(.rodata);} > ram
    task_1_rodata_size = SIZEOF(.task_1_rodata);  

/*Start at INIT_16_LMA from now on again*/

    .init16 __INIT_16_VMA :
        AT (__INIT_16_LMA)
        {   *(.init16);
            *(.entry); } > rom 

    __INIT_32_LMA = LOADADDR(.init16) + SIZEOF(.init16); 
    .init32 __INIT_32_VMA : /*VMA*/
        AT (__INIT_32_LMA)
        { *(.init32);

          *(.go_paging); } > rom

    __FUNCTIONS_ROM_LMA = LOADADDR(.init32) + SIZEOF(.init32); 
    .functions_rom __FUNCTIONS_ROM_VMA :
        AT (__FUNCTIONS_ROM_LMA)
        { *(.functions_rom);
          *(.init_pic);
          *(.init_IDT);
          *(.init_timer0);
          *(.note.gnu.property); } > rom
  

/*     .sys __SYS_TABLES_VMA :
        AT (__SYS_TABLES_LMA)
        { *(.sys_tables*); } > rom  
    __sys_size = SIZEOF(.sys);       */  


    .reset __RESET_VMA :
        AT (__RESET_LMA)
        { *(.resetVector); } > rom 

}

