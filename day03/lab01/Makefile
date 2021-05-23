MAKE = make -r
NASM = nasm
DEL = rm -f
default :
	$(MAKE) img

ipl.bin : ipl.asm
	$(NASM) ipl.asm -o ipl.bin -l ipl.lst


img : ipl.bin
	dd if=ipl.bin of=./cherryOS.img count=1 bs=512b

run : img
	qemu-system-i386 -drive file=cherryOS.img,format=raw,if=floppy -boot a

clean :
	$(DEL) *.bin *.lst *.img
	