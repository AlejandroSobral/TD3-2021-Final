#include "../inc/task02.h"


__attribute__(( section(".data_02")))
 byte  dummy_bss_02 = 2; //.data


__attribute__(( section(".task02_functions")))
void sum_all_task2(Table_Buffer* Table_Buffer, _64bits_average* avrg_p)
 {  byte a = 0;
	bits16_v i = 0;
	bits16_v div = 0;

	avrg_p->aux = 0;
	avrg_p->Add = 0;
	avrg_p->avrg = 0;
	for(i=0; i < Keyboard_Table_size; i++)
	{
		avrg_p->aux = Table_Buffer->table[i];
		avrg_p->avrg = avrg_p->avrg + avrg_p->aux;
		avrg_p->aux = 0;

	}
	
}
