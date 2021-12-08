#include "../inc/functions.h"


__attribute__(( section(".functions"))) byte __fast_memcpy(dword*src,dword *dst,dword length)
{
    byte status = ERROR_DEFECTO;

    if(length>0)
    {
        while(length)
        {
            length--;
            *dst++=*src++;
        }
        status = EXITO;
    }

    return (status);
}

__attribute__(( section(".functions"))) byte IDT_handler_loader(dword *exception_num,
                                                             dword *cs, 
                                                             dword *handler,
                                                             dword *attr, 
                                                             dword *idt_dir){ 
    byte i;
    for (i = 0; i < (2 * (dword)exception_num) ; i++){
        *idt_dir++;
    }

    dword high = (((dword)cs)<<0x10);
    dword low = (0x0000FFFF&(dword)handler);

    *idt_dir = high|low;
    *idt_dir++;

    high = (0xFFFF0000&(dword)handler);
    //low = 0x00008E00;
    low = (0xFFFF & ((dword)attr)<<0x8);

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

__attribute__(( section(".functions"))) void Load_KeyBoardTable(Table_Buffer* Load_Keyboard_table_Itself, Keyboard_buffer* Keyboard_Buffer_Itself)
{
    static int i =0;
    byte buffer_pop_data;
    dword High_data = 0x00; //4 bytes mas significatvos (8 teclas)
    dword Low_data = 0x00; //4 bytes menos significativos (8 teclas)
  
    /* Leo el buffer con la cantidad de numeros ingresados. Las pos. restantes deberían ser 0 por el limpiar_buffer */
    for (i=0;i<Keyb_buffer_size;i++)
    {
        buffer_pop_data = buffer_Pop(Keyboard_Buffer_Itself); //Comienzo a leerlo desde la última posición [16]
        if(i<8)
        {
            Low_data = Low_data + (buffer_pop_data << 4*i);
        }
        else
        {
            High_data = High_data + (buffer_pop_data << 4*i);
        }      
    }
    
    if(Load_Keyboard_table_Itself->table_index < Keyboard_Table_size){

        Load_Keyboard_table_Itself->table[Load_Keyboard_table_Itself->table_index]= High_data ;
        Load_Keyboard_table_Itself->table_index++; //Sumo el índice para el siguiente dígito de 32 bits (8 bytes, 16 números ingresados)
        Load_Keyboard_table_Itself->table[Load_Keyboard_table_Itself->table_index]= Low_data ;
        Load_Keyboard_table_Itself->table_index++; //Sumo el índice para el siguiente dígito de 32 bits (8 bytes, 16 números ingresados)

    }
    else{

        Load_Keyboard_table_Itself->table_index = 0;    //Reseteo índice para empezar a sobreescribir la tabla por si me guardan más de 10 
    }
    buffer_Clear(Keyboard_Buffer_Itself);                 //Limpio el buffer para la próxima entrada de datos.


    return;
    /* Escribo el numero en la tabla de dígitos de 64 bits */
    
}