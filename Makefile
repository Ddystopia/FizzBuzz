.PHONY: all clear

CC=nasm
CFLAGS=-f elf
LFLAGS=-m elf_i386 -s
OUTPUT=run
SOURCES=main.asm

OBJECTS=$(SOURCES:.asm=.o)

all: run

run: $(OBJECTS)
	ld $(LFLAGS) -o $(OUTPUT) $^

%.o: %.asm
	$(CC) $(CFLAGS) $< -o $@

clear:
	rm -rf $(OUTPUT) *.o
