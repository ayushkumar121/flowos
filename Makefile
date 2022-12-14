PNAME=flowos
IDIR=src/include
SDIR=src
ODIR=bin
CC=gcc

DIRS=$(ODIR) $(ODIR)/x86 $(ODIR)/kernel $(ODIR)/kernel \
	$(ODIR)/arch/x86/dev $(ODIR)/arch/x86/gfx $(ODIR)/arch/x86/lib $(ODIR)/arch/x86/sys


DEPS   := $(shell find $(IDIR) -name "*.h")
SFILES := $(shell find $(SDIR) -name "*.c")
OBJ=$(patsubst $(SDIR)/%.c, $(ODIR)/%.o, $(SFILES))

CFLAGS=-std=gnu17 -Wall -nostdlib -fno-stack-protector -ffreestanding -m64 -masm=intel -mgeneral-regs-only -I$(IDIR)

$(shell mkdir -p $(DIRS))

$(ODIR)/%.o: $(SDIR)/%.c $(DEPS)
	$(CC) -c $< -o $@ $(CFLAGS)

build: $(OBJ)
	nasm -f elf64 $(SDIR)/kernel/kernel_entry.asm -o $(ODIR)/kernel/kernel_entry.o
	ld  -o $(ODIR)/x86/full_kernel.bin -Ttext 0x1000 $(ODIR)/kernel/kernel_entry.o $(OBJ) --oformat binary 

	nasm -f bin $(SDIR)/boot/boot.asm -o $(ODIR)/x86/boot.bin
	nasm -f bin $(SDIR)/boot/padding.asm -o $(ODIR)/x86/padding.bin
	cat  $(ODIR)/x86/boot.bin $(ODIR)/x86/full_kernel.bin $(ODIR)/x86/padding.bin > $(ODIR)/x86/$(PNAME).bin

clean:
	rm -rdf bin

run:
	qemu-system-x86_64 -drive file=$(ODIR)/x86/$(PNAME).bin,format=raw \
	-serial stdio -vga std -display sdl