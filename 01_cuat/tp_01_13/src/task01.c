#include "../inc/task01.h"


__attribute__(( section(".rodata_1")))
const byte rodata_dummy_task1 = 1; 

__attribute__(( section(".bss_01")))
byte bss_dummy_task1; 

__attribute__(( section(".data_01")))
byte data_dummy_task1 = 0; 

__attribute__(( section(".task01_functions"))) void _64BITS_AVERAGE_FUNC(Table_Buffer* Table_Buffer, _64bits_average* avrg_p)
{
	bits16_v i = 0;
	bits16_v div = 0;

	avrg_p->aux = 0;
	avrg_p->Add = 0;
	avrg_p->avrg = 0;

	for(i=0; i < DIGIT_TABLE_SIZE; i++)
	{
		avrg_p->aux = Table_Buffer->table[i];

		if(avrg_p->aux > 0)
		{
			avrg_p->Add = avrg_p->Add + avrg_p->aux;
			div++;
			avrg_p->aux = 0;
		}
	}
	if(div > 0)
	{
		avrg_p->avrg = division_64(avrg_p->Add, div);
	}
}

__attribute__(( section(".task01_functions")))bits64_v division_64(bits64_v Addprom, bits16_v div)
{
    static byte i=0;
    static bits64_v result_64,aux;         //Addprom/div  
    
    result_64=0;
    aux=0;   

    for(i=0;i<64;i++)
    {
        
        aux=aux | ( ( Addprom>>(64-1-i) ) & ( 0x01 ) );
        if(aux>=div)
        {
        result_64=result_64|0x1;            
        aux=aux-div;
        }
        result_64=result_64<<1;
        aux=aux<<1;
    }
    result_64=result_64>>1;
    return result_64;
}


__attribute__(( section(".task01_functions"))) void Screen_Writing_task01(Video_Buffer* Video_Buff_v, _64bits_average* avrg_p, bits16_v row, bits16_v column)
{	bits16_v offset = 0;
	bits64_v aux = 0;
	bits32_v aux_L = 0;
	bits32_v aux_H = 0;
	byte Aux_var = 0;
	byte string[] = "Alejandro Sobral - UTN FRBA - TDIII - 2021.";
    byte nmbr[16];
	bits16_v length = 0;
	length = sizeof(string);

	aux = avrg_p->avrg;
	aux_L = avrg_p->avrg;
	aux_H = (avrg_p->avrg) >> 32;
	for(offset = 0; offset < KEYBOARD_BUFFER_SIZE; offset++)
	{
		if(offset < KEYBOARD_BUFFER_SIZE/2)
		{
			Aux_var = aux_L % 16; // From DEC to HEX
			aux_L = aux_L / 16;
			if(Aux_var>=10)
    		{
    			Aux_var=Aux_var+7;
    		}
			nmbr[offset] = Aux_var;
		}
		else
		{	
			Aux_var = aux_H % 16; // From DEC to HEX			
			aux_H = aux_H / 16;	
			if(Aux_var>=10)
    		{
    			Aux_var=Aux_var+ASCII_OFFSET_LETTERNUMBER; //ASCII offset between letters and numbers
    		}
			nmbr[offset] = Aux_var;	
		}
	}

	if((row < 25) & (column < 80))
	{
		for(offset = 0; offset < KEYBOARD_BUFFER_SIZE; offset++)
		{
			Video_Buff_v->buffer[((column + offset) * 2) + (row * 160)] = 48 + nmbr[KEYBOARD_BUFFER_SIZE-1 - offset];	///Set Data & data offset
			Video_Buff_v->buffer[((column + offset) * 2 + 1) + (row * 160)] = 0x09;	///Set attrb.
		}
	}
	for(offset = 0; offset < length; offset++)
	{
		Video_Buff_v->buffer[((0 + offset) * 2) + (24 * 160)] = string[offset];	//Set Data
		Video_Buff_v->buffer[((0 + offset) * 2 + 1) + (24 * 160)] = 0x09;	//Set attrb.
    }        
}


