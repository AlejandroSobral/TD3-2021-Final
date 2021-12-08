#include "../inc/functions_rom.h"
#include "../inc/defines_rom.h"


__attribute__(( section(".functions_rom"))) byte __fast_memcpy_rom(bits32_v* src,bits32_v *dst,bits32_v length)
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



__attribute__(( section(".functions_rom"))) byte IDT_handler_loader_rom(bits32_v *exception_num,
                                                             bits32_v *cs, 
                                                             bits32_v *handler,
                                                             bits32_v *attr, 
                                                             bits32_v *idt_dir){ 
    bits32_v i;
    for (i = 0; i < (2 * (bits32_v)exception_num) ; i++){
        *idt_dir++;
    }

    bits32_v high = (((bits32_v)cs)<<0x10);
    bits32_v low = (0x0000FFFF&(bits32_v)handler);

    *idt_dir = high|low;
    *idt_dir++;

    high = (0xFFFF0000&(bits32_v)handler);
    low = (0xFFFF & ((bits32_v)attr)<<0x8);

    *idt_dir = high|low;
    
    return 1;
}



 



__attribute__((section(".functions_rom"))) void __load_DTP_entry_rom(bits32_v init_phy_dtp,
														bits32_v VMA,
                                                        byte _ps,
                                                        byte _a,
                                                        byte _pcd,
                                                        byte _pwt,
                                                        byte _us,
                                                        byte _rw,
                                                        byte _p)
{
	bits32_v entry_dtp = 0x00;
	bits32_v init_pt = 0x00;
	bits32_v dpte = 0;
        
    bits32_v *dst = (bits32_v *)init_phy_dtp;

	entry_dtp = Get_Entry_DTP (VMA); //Get DTP Entry Index from VMA Addr bits 31-22
	init_pt = (init_phy_dtp + 0x1000 )+ (0x1000*entry_dtp); // Set Init PT from DTP BASE + DTP SIZE + DEFAULT_SIZE*INDEX

    dpte |= (init_pt & 0xFFFFF000);
    dpte |= (_ps << 7);
    dpte |= (_a << 5);
    dpte |= (_pcd << 4);
    dpte |= (_pwt << 3);
    dpte |= (_us << 2);
    dpte |= (_rw << 1);
    dpte |= (_p << 0);

	

    *(dst + entry_dtp) = dpte;
}



__attribute__((section(".functions_rom"))) bits32_v Get_Entry_DTP_rom(bits32_v init_dpt) //Get DTP from VMA
{
	bits32_v DTP = 0x00;

	DTP = (init_dpt >> 22) & 0x03FF ;//31-22 bits

	return DTP;

}

__attribute__((section(".functions_rom"))) void __load_TP_entry_rom(bits32_v init_phy_dtp,
                                                       bits32_v VMA,
                                                       bits32_v dir_phy,
                                                       byte _g,
                                                       byte _pat,
                                                       byte _d,
                                                       byte _a,
                                                       byte _pcd,
                                                       byte _pwt,
                                                       byte _us,
                                                       byte _rw,
                                                       byte _p)
{
	
	bits32_v entry_tp = 0x0, entry_dtp = 0x0, init_pt = 0x0;
    bits32_v pte = 0;


	entry_dtp = Get_Entry_DTP_rom (VMA); //Get DTP Entry Index from VMA Addr
	entry_tp = Get_Entry_TP_rom(VMA);
	init_pt = (init_phy_dtp + 0x1000)+(0x1000*entry_dtp); // Set Init PT from DTP BASE + DTP SIZE + DEFAULT_SIZE*INDEX


    bits32_v *dst = (bits32_v*)init_pt;

    pte |= (dir_phy & 0xFFFFF000); // Entries use PHY ADDR!
    pte |= (_g << 8);
    pte |= (_pat << 7);
    pte |= (_d << 6);
    pte |= (_a << 5);
    pte |= (_pcd << 4);
    pte |= (_pwt << 3);
    pte |= (_us << 2);
    pte |= (_rw << 1);
    pte |= (_p << 0);
    *(dst + entry_tp) = pte;


}


	__attribute__((section(".functions_rom"))) bits32_v Get_Entry_TP_rom(bits32_v init_dpt)  //Get PTE from VMA
{
	bits32_v PTE = 0x00;

	PTE = (init_dpt >> 12) & 0x3FF ;//21-12 bits
	return PTE;

}

__attribute__(( section(".functions_rom")))bits32_v LOAD_CR3_ROM (bits32_v init_dpt, byte _pcd, byte _pwt)
{
    bits32_v cr3 = 0;

    cr3 |= (init_dpt & 0xFFFFF000);
    cr3 |= (_pcd << 4);
    cr3 |= (_pwt << 3);
    return cr3;
}


/*Fewer lines to be written if using defines such as present page for any entry*/
__attribute__(( section(".functions_rom")))void set_dtp_pt_merged_rom (bits32_v init_phy_dtp, bits32_v VMA, bits32_v dir_PHY, byte ATR)
{
    bits32_v pte = 0, dpte = 0, entry_pte = 0, init_pt = 0, entry_dtp = 0;

    bits32_v *dst_dpt = (bits32_v*)init_phy_dtp; // DPT Base Address
    entry_dtp = Get_Entry_DTP_rom(VMA);     //B31-22 
    entry_pte = Get_Entry_TP_rom(VMA);      //B21-12 
    init_pt = (init_phy_dtp + 0x1000 ) + (0x1000*entry_dtp); 

   dpte  = (init_pt & 0xFFFFF000);
   dpte = dpte + ATR;
    *(dst_dpt + entry_dtp) = init_pt + ATR;

        
    bits32_v *dst_pt = (bits32_v*)init_pt; //Tp Base Address
   pte = (dir_PHY & 0xFFFFF000);
   pte = pte + ATR;
    *(dst_pt + entry_pte) = dir_PHY + ATR;

}

