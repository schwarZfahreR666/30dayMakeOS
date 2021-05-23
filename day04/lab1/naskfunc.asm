;naskfunc,用汇编实现HALT(HLT)
;TAB = 4 

; [FORMAT"WCOFF"]                     ;制作目标文件的模式,创建对象文件的模式；在NASM中出错，因此删除该行
[BITS 32]                           ;制作32位模式用的机器语言

;制作目标文件的信息

;[FIEL"naskfunc.nas"]               ;源文件名信息
; GLOBAL _io_hlt                    nasm中出错,修正
GLOBAL io_hlt,write_mem8	        ;程序中包含的函数名,需以下划线开头.注意要在函数名的前面加上“_”，否则就不能很好地与C语言函数链接。需要链接的函数名，都要用GLOBAL1指令声明。

[SECTION .text]                     ;目标文件中写了这些之后再写程序

;_io_hlt:	; void io_hlt(void);    nasm中出错,修正
io_hlt:    ;void io_hlt(void);

    HLT
    RET     ;RET:Return缩写
write_mem8:                         ;void write_mem8(int addr,int data);
    MOV     ECX,[ESP+4]             ;[ESP+4]中存放的是地址,将其读入ECX
    MOV     AL,[ESP+8]              ;[ESP+8]存放的是数据,将其读入AL
    MOV     [ECX],AL
    RET