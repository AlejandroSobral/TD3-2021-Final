.PHONY: clean

BINPATH = ./bin/
DOCPATH = ./doc/
INCPATH = ./inc/
LIBPATH = ./lib/
SRCPATH = ./src/
SUPPATH = ./sup/

AC = nasm
CC = gcc
AFLAGS = -f elf32
CFLAGS = -c -m32 -fno-stack-protector -fno-asynchronous-unwind-tables -Wall -fno-PIC

LDFLAGS = -z max-page-size=0x01000 --oformat=binary -m elf_i386

LDSCRIPT = linker.ld
ODFLAGS = -CprsSx --prefix-addresses
#en objs guardo todos mis objetos elf
OBJS = $(BINPATH)init32.elf $(BINPATH)reset.elf $(BINPATH)sys_tables.elf $(BINPATH)init16.elf $(BINPATH)main.elf  $(BINPATH)functions.elf $(BINPATH)functions_rom.elf $(BINPATH)init_pic.elf $(BINPATH)init_IDT.elf $(BINPATH)handlers.elf $(BINPATH)sys_data.elf $(BINPATH)init_timer0.elf

SRC_NAME = mi_bios

all: $(BINPATH)$(SRC_NAME).bin $(BINPATH)$(SRC_NAME).elf bochs
	mkdir -p doc
	hexdump -C $(BINPATH)$(SRC_NAME).bin > $(DOCPATH)$(SRC_NAME)_hexdump.txt
	objdump $(ODFLAGS) $(BINPATH)$(SRC_NAME).elf > $(DOCPATH)$(SRC_NAME)_objdump.txt
	readelf -a $(BINPATH)$(SRC_NAME).elf > $(DOCPATH)$(SRC_NAME)_readelf.txt


$(BINPATH)$(SRC_NAME).bin: $(OBJS)
	ld $(LDFLAGS) -T $(LDSCRIPT) $(OBJS) -o $@ -Map $(SRC_NAME).map

$(BINPATH)$(SRC_NAME).elf: $(OBJS)
	ld -z max-page-size=0x01000 -m elf_i386 -T $(LDSCRIPT) $(OBJS) -o $@

$(BINPATH)main.elf: $(SRCPATH)main.asm
	@echo Generando $@
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst

$(BINPATH)sys_tables.elf: $(SRCPATH)sys_tables.asm
	@echo Generando $@
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst

$(BINPATH)reset.elf: $(SRCPATH)reset.asm
	@echo Generando $@
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst

$(BINPATH)init16.elf: $(SRCPATH)init16.asm
	@echo Generando $@
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst

$(BINPATH)init32.elf: $(SRCPATH)init32.asm
	@echo Generando $@
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst

$(BINPATH)init_pic.elf: $(SRCPATH)init_pic.asm
	@echo Generando $@
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst

$(BINPATH)init_IDT.elf: $(SRCPATH)init_IDT.asm
	@echo Generando $@
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst

$(BINPATH)handlers.elf: $(SRCPATH)handlers.asm
	@echo Generando $@
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst

$(BINPATH)sys_data.elf: $(SRCPATH)sys_data.asm
	@echo Generando $@
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst

$(BINPATH)init_timer0.elf: $(SRCPATH)init_timer0.asm
	@echo Generando $@
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst


$(BINPATH)functions_rom.elf: $(SRCPATH)functions_rom.c
	@echo Generando $@
	mkdir -p bin
	$(CC) $(CFLAGS) $< -o $@

$(BINPATH)functions.elf: $(SRCPATH)functions.c
	@echo Generando $@
	mkdir -p bin
	$(CC) $(CFLAGS) $< -o $@

bochs:

	bochs -f bochsrc

clean:

	rm $(BINPATH)*.bin $(BINPATH)*.elf $(BINPATH)*.lst *.map

