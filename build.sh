#!/bin/bash
rm out/* isodir/boot/myos.bin
i686-elf-as src/boot.s -o out/boot.o
i686-elf-gcc -c src/kernel.c -o out/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
i686-elf-gcc -T src/linker.ld -o out/myos.bin -ffreestanding -O2 -nostdlib out/boot.o out/kernel.o -lgcc
if grub-file --is-x86-multiboot out/myos.bin; then
    echo multiboot confirmed
else
    echo the file is not multiboot
fi
cp out/myos.bin isodir/boot/myos.bin
grub-mkrescue -o out/myos.iso isodir
qemu-system-i386 -cdrom out/myos.iso