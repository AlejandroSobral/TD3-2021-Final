#include "../inc/functions.h"

        //asm("xchg %bx, %bx"); asm input exmpl
__attribute__(( section(".functions"))) byte __fast_memcpy(bits32_v*src,bits32_v *dst,bits32_v length)
{
    byte status = ERROR_CODE;

    if(length>0)
    {
        while(length)
        {
            length--;
            *dst++=*src++;
        }
        status = OK_CODE;
    }
     return (status);
}

__attribute__(( section(".functions"))) byte IDT_handler_loader(bits32_v *exception_num,
                                                             bits32_v *cs, 
                                                             bits32_v *handler,
                                                             bits32_v *attr, 
                                                             bits32_v *idt_dir){ 
    byte i;
    for (i = 0; i < (2 * (bits32_v)exception_num) ; i++){
        *idt_dir++;
    }

    bits32_v high = (((bits32_v)cs)<<0x10);
    bits32_v low = (0x0000FFFF&(bits32_v)handler);

    *idt_dir = high|low;
    *idt_dir++;

    high = (0xFFFF0000&(bits32_v)handler);
    //low = 0x00008E00;
    low = (0xFFFF & ((bits32_v)attr)<<0x8);

    *idt_dir = high|low;
    
    return 1;
}

__attribute__(( section(".functions"))) void __Keyboard_Buffer_func( Keyboard_buffer* key_buffer, byte value_to_store){ 
    
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

__attribute__(( section(".functions"))) byte buffer_Pop(Keyboard_buffer* key_buffer) 
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

__attribute__(( section(".functions"))) void buffer_Clear(Keyboard_buffer* Table_keyboard_buffer)
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

__attribute__(( section(".functions"))) void Load_KeyBoardTable(Table_Buffer* table_p, Keyboard_buffer* buff_p)
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
                                                                

__attribute__(( section(".functions"))) void Screen_Writing(Video_Buffer* Video_Buff_v, _64bits_average* avrg_p, bits16_v row, bits16_v column)
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
	for(offset = 0; offset < Keyb_buffer_size; offset++)
	{
		if(offset < Keyb_buffer_size/2)
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
		for(offset = 0; offset < Keyb_buffer_size; offset++)
		{
			Video_Buff_v->buffer[((column + offset) * 2) + (row * 160)] = 48 + nmbr[Keyb_buffer_size-1 - offset];	///Set Data & data offset
			Video_Buff_v->buffer[((column + offset) * 2 + 1) + (row * 160)] = 0x07;	///Set attrb.
		}
	}
	for(offset = 0; offset < length; offset++)
	{
		Video_Buff_v->buffer[((0 + offset) * 2) + (24 * 160)] = string[offset];	//Set Data
		Video_Buff_v->buffer[((0 + offset) * 2 + 1) + (24 * 160)] = 0x07;	//Set attrb.
    }        
}




__attribute__(( section(".task_01"))) void _64bits_average_func(Table_Buffer* Table_Buffer, _64bits_average* avrg_p)
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

__attribute__(( section(".functions")))bits64_v division_64(bits64_v Addprom, bits16_v div)
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