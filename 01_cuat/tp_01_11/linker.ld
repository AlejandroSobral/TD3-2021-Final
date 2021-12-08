ENTRY (reset)

/**********************************STACK************************/
    __STACK_START_16 = 0x9000;
    __STACK_END_16 = 0x09FFF;

    __STACK_SIZE_32 = ((__STACK_END_32 - __STACK_START_32) / 4); /*32b word*/
    __STACK_SIZE_32 = ((__STACK_END_32 - __STACK_START_32) / 4); /*32b word*/

/******LMA******/

    __SYS_TABLES_LMA            = 0xFFFF0000; /*Init rom*/
    __INIT_16_LMA               = 0xFFFF9000;
    __RESET_LMA                 = 0xFFFFFFF0;              

/*******PAGING INFO******/

    __CR3_KERNEL                = 0x00010000; /*PHY*/
    __CR3_TASK1                 = 0x01000000;       
    __CR3_TASK2                 = 0x02000000;
    __CR3_TASK3                 = 0x03000000;
    __CR3_TASK4                 = 0x04000000;

    __TSS_KERNEL                = 0x00001000;
    __TSS_TASK1                 = 0x00001100;
    __TSS_TASK2                 = 0x00001200;
    __TSS_TASK3                 = 0x00001300;
    __TSS_TASK4                 = 0x00001400;

/**************PHY ADDRS**********************/

    __SYS_TABLES_PHY            = 0x00000000;
    __SYS_TABLES_TSS_PHY        = 0x00001000;
    __SYS_TABLES_PAG_PHY        = 0x00010000;
    __SYS_TABLES_PAG_T1_PHY     = 0x01000000;
    __SYS_TABLES_PAG_T2_PHY     = 0x02000000;
    __SYS_TABLES_PAG_T3_PHY     = 0x03000000;
    __SYS_TABLES_PAG_T4_PHY     = 0x04000000;  

    __PAGE_TABLES_PHY           = 0x00010000; 
 
    __VIDEO_PHY                 = 0x000B8000; 
    __ISR_AND_KEYBOARD_PHY      = 0x00100000; 
    __DATA_PHY                  = 0x00200000; 
    __TABLE_KEYBOARD_PHY        = 0x00210000; 
    __KERNEL_32_PHY             = 0x00220000;
    __FUNCTIONS_PHY             = 0x00230000;

    __TASK_1_TEXT_PHY           = 0x00310000; 
    __TASK_1_BSS_PHY            = 0x00320000; 
    __TASK_1_DATA_PHY           = 0x00330000; 
    __TASK_1_RODATA_PHY         = 0x00340000;

    __TASK_2_TEXT_PHY           = 0x00410000; 
    __TASK_2_BSS_PHY            = 0x00420000; 
    __TASK_2_DATA_PHY           = 0x00430000; 
    __TASK_2_RODATA_PHY         = 0x00440000;

    __TASK_3_TEXT_PHY           = 0x00510000; 
    __TASK_3_BSS_PHY            = 0x00520000; 
    __TASK_3_DATA_PHY           = 0x00530000; 
    __TASK_3_RODATA_PHY         = 0x00540000;

    __TASK_4_TEXT_PHY           = 0x00610000; 
    __TASK_4_BSS_PHY            = 0x00620000; 
    __TASK_4_DATA_PHY           = 0x00630000; 
    __TASK_4_RODATA_PHY         = 0x00640000;    

    __STACK_START_32_PHY        = 0x1FFF8000; 
    __STACK_END_32_PHY          = 0x1FFF8FFF;

    __TASK_1_STACK_START_PHY    = 0x1FFFF000; 
    __TASK_1_STACK_PHY_END      = 0x1FFFFFFF; 

    /*each stack have same size 0x1000*/
    __STACK_KERNEL_PHY          = 0x1FFF8000;     
    __STACK_KERNEL_PHY_END      = 0x1FFF8FFF;
    
    __STACK_TASK1_PHY           = 0x1FFFF000;            
    __STACK_TASK1_PHY_END       = 0x1FFFFFFF;

    __STACK_TASK2_PHY           = 0x2FFF1000;              
    __STACK_TASK2_PHY_END       = 0x2FFF1FFF;

    __STACK_TASK3_PHY           = 0x2FFF2000;               
    __STACK_TASK3_PHY_END       = 0x2FFF2FFF;

    __STACK_TASK4_PHY           = 0x2FFF3000;               
    __STACK_TASK4_PHY_END       = 0x2FFF3FFF;

/*****VMA******/

    __SYS_TABLES_VMA            = 0x00000000; /*GDT location*/   
    __SYS_TABLES_IDT            = 0x00000000; /*IDT BEGIN*/
    __SYS_TABLES_GDT            = 0x00000100; /*GDT STARTS AFTER IDT.*/
    __PAGE_TABLES_VMA           = 0x00010000;

    __SYS_TABLES_TSS_VMA        = 0x00001000;
    __SYS_TABLES_PAG_VMA        = 0x00010000;
    __SYS_TABLES_PAG_T1_VMA     = __SYS_TABLES_PAG_T1_PHY;
    __SYS_TABLES_PAG_T2_VMA     = __SYS_TABLES_PAG_T2_PHY;
    __SYS_TABLES_PAG_T3_VMA     = __SYS_TABLES_PAG_T3_PHY;
    __SYS_TABLES_PAG_T4_VMA     = __SYS_TABLES_PAG_T4_PHY;

 

    __FUNCTIONS_VMA             = 0x01230000;      
    __VIDEO_VMA                 = 0x00E80000;
    __ISR_AND_KEYBOARD_VMA      = 0x00100000;
    __DATA_VMA                  = 0x01200000;
    __TABLE_KEYBOARD_VMA        = 0x01210000;              
    __KERNEL_32_VMA             = 0x01220000;

    __TASK_1_TEXT_VMA           = 0x01310000; 
    __TASK_1_BSS_VMA            = 0x01320000; 
    __TASK_1_DATA_VMA           = 0x01330000; 
    __TASK_1_RODATA_VMA         = 0x01340000;

    __TASK_2_TEXT_VMA           = 0x01410000; 
    __TASK_2_BSS_VMA            = 0x01420000; 
    __TASK_2_DATA_VMA           = 0x01430000; 
    __TASK_2_RODATA_VMA         = 0x01440000;

    __TASK_3_TEXT_VMA           = 0x01510000; 
    __TASK_3_BSS_VMA            = 0x01520000; 
    __TASK_3_DATA_VMA           = 0x01530000; 
    __TASK_3_RODATA_VMA         = 0x01540000;

    __TASK_4_TEXT_VMA           = 0x01610000; 
    __TASK_4_BSS_VMA            = 0x01620000; 
    __TASK_4_DATA_VMA           = 0x01630000; 
    __TASK_4_RODATA_VMA         = 0x01640000;    




    __STACK_START_32            = 0x1FFF8000;
    __STACK_END_32              = 0x1FFF8FFF;

    __STACK_TASK1_VMA          = 0x0078F000;  
    __STACK_TASK1_VMA_END      = 0x0078FFFF;

    __STACK_TASK2_VMA          = 0x00790000;
    __STACK_TASK2_VMA_END      = 0x00790FFF;
    
    __STACK_TASK3_VMA          = 0x00791000;
    __STACK_TASK3_VMA_END      = 0x00791FFF;

    __STACK_TASK4_VMA          = 0x00792000;
    __STACK_TASK4_VMA_END      = 0x00792FFF;

    __INIT_16_VMA               = __INIT_16_LMA;
    __INIT_32_VMA               = __INIT_32_LMA;
    __FUNCTIONS_ROM_VMA         = __FUNCTIONS_ROM_LMA;    
    __RESET_VMA                 = __RESET_LMA;                                    
    



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
    .codigo_KERNEL32 __KERNEL_32_VMA :
        AT (__KERNEL_32_LMA)
        { *(.kernel32); } > ram
    __codigo_KERNEL32_size = SIZEOF(.codigo_KERNEL32);

    __FUNCTIONS_LMA = LOADADDR(.codigo_KERNEL32) + SIZEOF(.codigo_KERNEL32);
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
    .TASK_1_data __TASK_1_DATA_VMA :
        AT (__TASK_1_DATA_LMA)
        {./bin/task01.elf(.data_01);
        *(.data_01);} > ram
    TASK_1_data_size = SIZEOF(.TASK_1_data);       

    __TASK_1_RODATA_LMA = LOADADDR(.TASK_1_data) + SIZEOF(.TASK_1_data); 
    .TASK_1_rodata __TASK_1_RODATA_VMA :
        AT (__TASK_1_RODATA_LMA)
        {./bin/task01.elf(.rodata);} > ram
    TASK_1_rodata_size = SIZEOF(.TASK_1_rodata);  

    __TASK_2_TEXT_LMA = LOADADDR(.TASK_1_rodata) + SIZEOF(.TASK_1_rodata);    
    .TASK_2_TEXT_o __TASK_2_TEXT_VMA :
        AT (__TASK_2_TEXT_LMA)
        { *(.task02_functions);
        ./bin/taskk02.elf(.text);
        ./bin/taskk02.elf(.note*); } > ram  
    TASK_2_TEXT_size = SIZEOF(.TASK_2_TEXT_o);

    __TASK_2_BSS_LMA = LOADADDR(.TASK_2_TEXT_o) + SIZEOF(.TASK_2_TEXT_o);
    .TASK_2_BSS_o __TASK_2_BSS_VMA :
        AT (__TASK_2_BSS_LMA)
        {./bin/taskk02.elf(.bss);} > ram
    TASK_2_bss_size = SIZEOF(.TASK_2_BSS_o); 

    __TASK_2_DATA_LMA = LOADADDR(.TASK_2_BSS_o) + SIZEOF(.TASK_2_BSS_o); 
    .TASK_2_data __TASK_2_DATA_VMA :
        AT (__TASK_2_DATA_LMA)
        {./bin/taskk02.elf(.data_02);
        *(.data_02);} > ram
    TASK_2_data_size = SIZEOF(.TASK_2_data);       

    __TASK_2_RODATA_LMA = LOADADDR(.TASK_2_data) + SIZEOF(.TASK_2_data); 
    .TASK_2_rodata __TASK_2_RODATA_VMA :
        AT (__TASK_2_RODATA_LMA)
        {./bin/taskk02.elf(.rodata);} > ram
    TASK_2_rodata_size = SIZEOF(.TASK_2_rodata);     TASK_4_rodata_size = SIZEOF(.TASK_4_rodata);  

    __TASK_3_TEXT_LMA = LOADADDR(.TASK_2_rodata) + SIZEOF(.TASK_2_rodata);    
    .TASK_3_TEXT_o __TASK_3_TEXT_VMA :
        AT (__TASK_3_TEXT_LMA)
        { *(.task03_functions); } > ram  
    TASK_3_TEXT_size = SIZEOF(.TASK_3_TEXT_o);

    __TASK_3_BSS_LMA = LOADADDR(.TASK_3_TEXT_o) + SIZEOF(.TASK_3_TEXT_o);
    .TASK_3_BSS_o __TASK_3_BSS_VMA :
        AT (__TASK_3_BSS_LMA)
        {./bin/task03.elf(.bss);} > ram
    TASK_3_bss_size = SIZEOF(.TASK_3_BSS_o); 

    __TASK_3_DATA_LMA = LOADADDR(.TASK_3_BSS_o) + SIZEOF(.TASK_3_BSS_o); 
    .TASK_3_data __TASK_3_DATA_VMA :
        AT (__TASK_3_DATA_LMA)
        {./bin/task03.elf(.data_03);
        *(.data_03);} > ram
    TASK_3_data_size = SIZEOF(.TASK_3_data);       

    __TASK_3_RODATA_LMA = LOADADDR(.TASK_3_data) + SIZEOF(.TASK_3_data); 
    .TASK_3_rodata __TASK_3_RODATA_VMA :
        AT (__TASK_3_RODATA_LMA)
        {./bin/task03.elf(.rodata);} > ram
    TASK_3_rodata_size = SIZEOF(.TASK_3_rodata); 


    __TASK_4_TEXT_LMA = LOADADDR(.TASK_3_rodata) + SIZEOF(.TASK_3_rodata);    
    .TASK_4_TEXT_o __TASK_4_TEXT_VMA :
        AT (__TASK_4_TEXT_LMA)
        { *(.task04_functions);} > ram  
    TASK_4_TEXT_size = SIZEOF(.TASK_4_TEXT_o);

    __TASK_4_BSS_LMA = LOADADDR(.TASK_4_TEXT_o) + SIZEOF(.TASK_4_TEXT_o);
    .TASK_4_BSS_o __TASK_4_BSS_VMA :
        AT (__TASK_4_BSS_LMA)
        {./bin/task04.elf(.bss);} > ram
    TASK_4_bss_size = SIZEOF(.TASK_4_BSS_o); 

    __TASK_4_DATA_LMA = LOADADDR(.TASK_4_BSS_o) + SIZEOF(.TASK_4_BSS_o); 
    .TASK_4_data __TASK_4_DATA_VMA :
        AT (__TASK_4_DATA_LMA)
        {./bin/task04.elf(.data_04);} > ram
    TASK_4_data_size = SIZEOF(.TASK_4_data);       

    __TASK_4_RODATA_LMA = LOADADDR(.TASK_4_data) + SIZEOF(.TASK_4_data); 
    .TASK_4_rodata __TASK_4_RODATA_VMA :
        AT (__TASK_4_RODATA_LMA)
        {./bin/task04.elf(.rodata);} > ram
    TASK_4_rodata_size = SIZEOF(.TASK_4_rodata);

/*Start at INIT_16_LMA from now on again*/

    .init16 __INIT_16_VMA :
        AT (__INIT_16_LMA)
        {   *(.init16);
            *(.entry); } > rom 

    __INIT_32_LMA = LOADADDR(.init16) + SIZEOF(.init16); 
    .init32 __INIT_32_VMA : /*VMA*/
        AT (__INIT_32_LMA)
        { *(.init32);
          *(.go_paging);
          *(.load_tss); } > rom

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

