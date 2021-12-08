Chnl0_Data_port         EQU 0x40
Mode_Command_register   EQU 0x43


section .init_timer0

GLOBAL init_timer0

init_timer0:

mov al, 00110100b; Channel cero both parts
out Mode_Command_register, al; Data out
mov ax, 11932; 11931181h Hz / 65536 ; lowest time I can get 54,94mS
out Chnl0_Data_port, al ; Low register nibble
mov al, ah
out Chnl0_Data_port, al; High register nibble

ret

