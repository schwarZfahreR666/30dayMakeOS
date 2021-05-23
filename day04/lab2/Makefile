MAKE = make -r
NASM = nasm
DEL = rm -f
CAT = cat
default :
	$(MAKE) img

ipl10.bin : ipl10.asm
	$(NASM) ipl10.asm -o ipl10.bin -l ipl10.lst

asmhead.bin : asmhead.asm
	$(NASM) asmhead.asm -o asmhead.bin -l asmhead.lst

naskfunc.o : naskfunc.asm Makefile          # naskfunc.asm创建二进制文件
	$(NASM) -g -f elf naskfunc.asm -o naskfunc.o -l naskfunc.lst

bootpack.hrb : naskfunc.o bootpack.c hrb.ld       # 使用脚本编译C文件
	i386-elf-gcc -march=i486 -m32 -nostdlib -T hrb.ld -g bootpack.c naskfunc.o -o bootpack.hrb
# i386-elf-gcc -T script
        #    Use script as the linker script.  This option is supported by most
        #    systems using the GNU linker.

sys : asmhead.bin bootpack.hrb
	$(CAT) asmhead.bin bootpack.hrb > os.sys

img : ipl10.bin sys
	mformat -f 1440 -C -B ipl10.bin -i helloos.img ::
	mcopy -i helloos.img os.sys ::
run : img
	qemu-system-i386 -drive file=helloos.img,format=raw,if=floppy -boot a

clean :
	$(DEL) *.bin *.lst *.img *.sys *.hrb *.o
	