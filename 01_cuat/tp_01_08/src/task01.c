#include "../inc/task01.h"

__attribute__(( section(".data")))
 byte  dummy_bss = 2; //.data


__attribute__(( section(".task01_functions"))) void Load_KeyBoardTable(Table_Buffer* table_p, Keyboard_buffer* buff_p)
{
	static char table_index = 0;
	bits16_v i=0;
	byte data = 0xFF;
	bits64_v nmbr = 0;
	bits32_v L_data = 0;
	bits32_v H_data = 0;	
	byte Loaded_ = 0;

	Loaded_ = buff_p->Loaded_elements; //Set the stored elements
	for(i = 0; i < Loaded_; i++)
	{
		data = buffer_Pop(buff_p);	
		if( data != 0xFF) // Did I collect smth?
		{
			nmbr = nmbr*10 + data;
			if(i < Keyb_buffer_size/2)
			{
				L_data = L_data*10 + data;
			}
			else
			{
				H_data = H_data*10 + data;				
			}
		}
	}

    if (table_index == Keyboard_Table_size)
	{
        table_index = 0; //Reset the table index
    }
    //Load data itself
	if(table_index <= Keyboard_Table_size)
	{
		table_p->table[table_index] = nmbr;
		table_index++;
	}
}

__attribute__(( section(".task01_functions"))) void __Keyboard_Buffer_func( Keyboard_buffer* key_buffer, byte value_to_store){ 
    
    if(key_buffer->in_index >= Keyb_buffer_size)
    { //Set the circular buffer right here
        key_buffer->in_index = 0; //Replace first entry

    }
    if (value_to_store >= 0 && value_to_store <= 9)
    {
        key_buffer->in_index++;
        key_buffer->Loaded_elements++;
        key_buffer->Buffer_info[key_buffer->in_index] = value_to_store;
    }
    if( key_buffer->Loaded_elements>= Keyb_buffer_size)
    {
        key_buffer->Loaded_elements = Keyb_buffer_size; //Prevent any type of overflow from now on
        //asm("xchg %bx, %bx");
    }

}

__attribute__(( section(".task01_functions"))) byte buffer_Pop(Keyboard_buffer* key_buffer) 
{
	byte PopValue = 0x00;

	if(key_buffer->Loaded_elements > 0)	
	{
		PopValue = key_buffer->Buffer_info[key_buffer->out_index];
        key_buffer->Loaded_elements--;
		key_buffer->out_index++;

		if(key_buffer->out_index == Keyb_buffer_size)
		{
			key_buffer->out_index = 0;
		}
		return PopValue;
	}
	else
	{	
		return PopValue;				//Void buffer
	}
}

__attribute__(( section(".task01_functions"))) void buffer_Clear(Keyboard_buffer* Table_keyboard_buffer)
{
    byte i=0;
	for(i=0; i<Keyb_buffer_size; i++)
	{
	    Table_keyboard_buffer->Buffer_info[i] = 0;
	}               
    Table_keyboard_buffer->in_index = 0;
    Table_keyboard_buffer->out_index = 0;
    Table_keyboard_buffer->Loaded_elements = 0;       
}



__attribute__(( section(".task01_functions"))) void _64bits_average_func(Table_Buffer* Table_Buffer, _64bits_average* avrg_p)
{
	bits16_v i = 0;
	bits16_v div = 0;

	avrg_p->aux = 0;
	avrg_p->Add = 0;
	avrg_p->avrg = 0;

	for(i=0; i < Keyboard_Table_size; i++)
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