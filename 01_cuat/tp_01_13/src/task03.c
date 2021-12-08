#include "../inc/task03.h"

 __attribute__(( section(".rodata_3")))
const byte rodata_dummy_task3 = 1; 

__attribute__(( section(".bss_03")))
byte bss_dummy_task3; 

__attribute__(( section(".data_03")))
byte data_dummy_task3 = 0; 

__attribute__(( section(".task03_functions")))
void sum_all_task3(Table_Buffer* Table_Buffer, _64bits_average* avrg_p)
 {  byte a = 0;
	bits16_v i = 0;
	bits16_v div = 0;

	avrg_p->aux = 0;
	avrg_p->Add = 0;
	avrg_p->avrg = 0;
	for(i=0; i < DIGIT_TABLE_SIZE; i++)
	{
		avrg_p->aux = Table_Buffer->table[i];
		avrg_p->avrg = avrg_p->avrg + avrg_p->aux;
		avrg_p->aux = 0;

	}
	
}