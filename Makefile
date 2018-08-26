ODIR=bin
ARCH_DIR=arch
KERNEL_DIR=kernel

X86_ODIR=$(ODIR)/x86
X86_SDIR=$(ARCH_DIR)/x86

AC=i686-elf-as
CC=i686-elf-gcc
LD=$(CC)

AFLAGS=
CFLAGS= -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS=-T linker.ld -ffreestanding -O2 -nostdlib

OBJ=$(X86_ODIR)/boot.o $(X86_ODIR)/kernel.o

OS_BIN=$(X86_ODIR)/os.bin

x86-iso: x86-odir x86-link
	mkdir -p $(X86_ODIR)/iso/boot


x86-link: $(OBJ)
	$(LD) $(LDFLAGS) -o $(OS_BIN) $^ -lgcc
	grub-file --is-x86-multiboot $(OS_BIN)


$(X86_ODIR)/boot.o: $(X86_SDIR)/boot/boot.s
	$(AC) $(AFLAGS) $< -o $@

$(X86_ODIR)/kernel.o: $(KERNEL_DIR)/kernel.c
	$(CC) $(CFLAGS) -c $< -o $@


x86-odir:
	mkdir -p bin/x86