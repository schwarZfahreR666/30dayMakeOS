;naskfunc,用汇编实现HALT(HLT)
;TAB = 4 

; [FORMAT"WCOFF"]                     ;制作目标文件的模式,创建对象文件的模式；在NASM中出错，因此删除该行
[BITS 32]                           ;制作32位模式用的机器语言

;制作目标文件的信息

;[FIEL"naskfunc.nas"]               ;源文件名信息
; GLOBAL _io_hlt                    nasm中出错,修正
; GLOBAL io_hlt,write_mem8	        ;程序中包含的函数名,需以下划线开头.注意要在函数名的前面加上“_”，否则就不能很好地与C语言函数链接。需要链接的函数名，都要用GLOBAL1指令声明。
GLOBAL io_hlt,io_cli,io_sti,io_stihlt
GLOBAL io_in8,io_in16,io_in32
GLOBAL io_out8,io_out16,io_out32
GLOBAL io_load_eflags,io_store_eflags
[SECTION .text]                     ;目标文件中写了这些之后再写程序

;_io_hlt:	; void io_hlt(void);    nasm中出错,修正
io_hlt:    ;void io_hlt(void);  停止CPU函数

    HLT
    RET     ;RET:Return缩写

io_cli:     ;void io_cli(void);  关中断
    CLI
    RET

io_sti:     ;void io_sti(void);  开中断
    STI
    RET
io_stihlt:  ;void io_stihlt(void); 
    STI
    HLT
    RET
io_in8:     ;int io_in8(int port);
    MOV     EDX,[ESP+4]     ;port
    MOV     EAX,0
    IN      AL,DX           ;IN input from port(存在DX中)
    RET
io_in16:     ;int io_in16(int port);
    MOV     EDX,[ESP+4]     ;port
    MOV     EAX,0
    IN      AL,DX
    RET
io_in32:     ;int io_in32(int port);
    MOV     EDX,[ESP+4]     ;port
    IN      EAX,DX           
    RET
io_out8:    ;void io_out8(int port,int data);
    MOV     EDX,[ESP+4]     ;port
    MOV     AL,[ESP+8]      ;data
    OUT     DX,AL
    RET
io_out16:    ;void io_out16(int port,int data);
    MOV     EDX,[ESP+4]     ;port
    MOV     AL,[ESP+8]      ;data
    OUT     DX,AL
    RET
io_out32:    ;void io_out32(int port,int data);
    MOV     EDX,[ESP+4]     ;port
    MOV     AL,[ESP+8]      ;data
    OUT     DX,EAX
    RET    



;介绍一下EFLAGS这一特别的寄存器。这是由名为FLAGS的16位寄存器扩展而来的32位寄存器。
;FLAGS是存储进位标志和中断标志等标志的寄存器。进位标志可以通过JC或JNC等跳转指令来
;简单地判断到底是0还是1。但对于中断标志，没有类似的JI或JNI命令，所以只能读入EFLAGS，
;再检查第9位是0还是1。顺便说一下，进位标志是EFLAGS的第0位。
io_load_eflags: ;int io_load_elfags(void);
    PUSHFD      ;指PUSH EFLAGS
    POP     EAX
    RET
io_store_eflags:    ;void io_store_eflags(int eflags);
    MOV     EAX,[ESP+4]
    PUSH  EAX
    POPFD           ;指POP EFLAGS
    RET



; write_mem8:                         ;void write_mem8(int addr,int data);
;     MOV     ECX,[ESP+4]             ;[ESP+4]中存放的是地址,将其读入ECX
;     MOV     AL,[ESP+8]              ;[ESP+8]存放的是数据,将其读入AL
;     MOV     [ECX],AL
;     RET