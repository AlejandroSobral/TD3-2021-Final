

LINKER_OBJECTS = ./bin/memcopy.o ./bin/init16.o ./bin/init32.o ./bin/reset.o
LINKER_SCRIPT = ./linker.ld
LINKER_DEPENDENCIES = init16 init32 reset memcopy
LINKER_ENTRY_POINT = reset
OUTPUT = bios.bin

$(OUTPUT): $(LINKER_DEPENDENCIES)
	@echo Generando $@...
	ld -z max-pag-size=0x01000 --oformat=binary -m elf_i386 -T $(LINKER_SCRIPT) -e $(LINKER_ENTRY_POINT) $(LINKER_OBJECTS) -o ./bin/$(OUTPUT)


init16: ./src/init16.asm
	@echo Generando $@.asm
	mkdir -p bin
	mkdir -p sup
	nasm -f elf32 ./src/$@.asm -o ./bin/$@.o -l ./sup/$@.lst

memcopy: ./src/memcopy.asm
	@echo Generando $@.asm
	mkdir -p bin
	mkdir -p sup
	nasm  -f elf32  ./src/$@.asm -o ./bin/$@.o -l ./sup/$@.lst	


init32: ./src/init32.asm
	@echo Generando $@.asm
	mkdir -p bin
	mkdir -p sup
	nasm -f elf32 ./src/$@.asm -o ./bin/$@.o -l ./sup/$@.lst


exec:
	$(OUTPUT)

reset: ./src/reset.asm
	@echo Generando $@.asm...
	mkdir -p bin
	mkdir -p sup
	nasm -f elf32 ./src/$@.asm -o ./bin/$@.o -l ./sup/$@.lst

bless:
	bless ./bin/bios.bin
elf:
	objdump -s $(OUTPUT)
clean:
	rm -f -r ./src/*.lst ./bin/*.elf ./bin/*.o ./bin/*.bin
bochs:
	bochs -qf bochsrc

