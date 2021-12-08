.PHONY: clean

BINPATH = ./bin/
DOCPATH = ./doc/
INCPATH = ./inc/
LIBPATH = ./lib/
SRCPATH = ./src/
SUPPATH = ./sup/
COMPATH = ./commons/
OBJPATH = ./obj/

CC = gcc
CFLAGS=  -c 
OUTPUT = ./bin/MyTCPServer.o
NEONFLAGS = -S   
OFLAGS = -lm -o
OBJS = $(SRCPATH)TCPServer.o $(SRCPATH)Misc.o $(SRCPATH)MPU_Filter.o $(SRCPATH)ConfigFile.o $(COMPATH)config.o $(COMPATH)string.o $(COMPATH)collections/dictionary.o

all: build clean_obj

build: $(OBJS) 
	$(CC) $(OBJS) $(OFLAGS) $(OUTPUT)
$(OBJPATH)Misc.o: $(SRCPATH)Misc.c
	$(CC) $< $(CFLAGS) -o $@

$(OBJPATH)TCPServer.o: $(SRCPATH)TCPServer.c
	$(CC) $< $(CFLAGS) -o $@

$(OBJPATH)ConfigFile.o: $(SRCPATH)ConfigFile.c
	$(CC) $< $(CFLAGS) -o $@

$(OBJPATH)MPU_Filter.o: $(SRCPATH)MPU_Filter.c
	$(CC) $< -c -Wall -Ofast -pthread -lrt -o $@

$(OBJPATH)config.o: $(COMPATH)config.c 
	$(CC) $< $(CFLAGS) -o $@

$(OBJPATH)string.o: $(COMPATH)string.c 
	$(CC) $< $(CFLAGS) -o $@

$(OBJPATH)dictionary.o: $(COMPATH)collections/dictionary.c
	$(CC) $< $(CFLAGS) -o $@

GET_ASM:
	$(CC) $(NEONFLAGS) $(SRCPATH)MPU_Filter.c

make:
	$(CC) $(CFLAGS) $(BINPATH)$(OUTPUT) $(OBJS)
run: 
	$(BINPATH)$(OUTPUT)
clean:
	rm $(BINPATH)*.bin $(BINPATH)*.elf $(BINPATH)*.lst $(BINPATH)*.o

clean_obj:
	rm $(SRCPATH)*.o


	
	

