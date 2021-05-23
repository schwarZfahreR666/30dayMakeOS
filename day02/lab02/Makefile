lab02.bin : lab02.asm Makefile
	nasm lab02.asm -o lab02.bin

install :
	dd if=lab02.bin of=../../cherryOS.img count=1 bs=512b