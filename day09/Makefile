MAKE = make -r
NASM = nasm
DEL = rm -f
CAT = cat

HPATH = include

default :
	$(MAKE) img

txt2fontc : txt2font.c
	gcc txt2font.c -o txt2fontc


hankaku.c : hankaku.txt txt2fontc
	./txt2fontc

ipl10.bin : ipl10.asm
	$(NASM) ipl10.asm -o ipl10.bin -l ipl10.lst

asmhead.bin : asmhead.asm
	$(NASM) asmhead.asm -o asmhead.bin -l asmhead.lst

naskfunc.o : naskfunc.asm Makefile          # naskfunc.asm创建二进制文件
	$(NASM) -g -f elf naskfunc.asm -o naskfunc.o -l naskfunc.lst

bootpack.hrb : naskfunc.o bootpack.c hankaku.c hrb.ld dsctbl.c graphic.c sprintf.c int.c fifo.c mouse.c keyboard.c    # 使用脚本编译C文件
	i386-elf-gcc -march=i486 -m32 -nostdlib -nostdinc -I $(HPATH)  -T hrb.ld -g  bootpack.c int.c dsctbl.c graphic.c sprintf.c fifo.c hankaku.c mouse.c keyboard.c naskfunc.o  -o bootpack.hrb
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
	# qemu-system-i386 -drive file=helloos.img,index=0,media=disk,format=raw,if=floppy

clean :
	$(DEL) *.bin *.lst *.img *.sys *.hrb *.o
	