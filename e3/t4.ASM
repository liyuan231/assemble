
data segment
	menu db "1.Bin:",0dh,0ah,"2.Dec:",0dh,0ah,"3.Hex:",0dh,0ah,"4.Exit",'$';

	io8255a        equ 288h;
	io8255b        equ 28bh;
	io8255c        equ 28ah;
data ends


code   segment
      assume cs:code,ds:data;
start:
	mov ax,data;
	mov ds,ax; 
 
	mov dx,io8255b           ;设8255为C口输入,A口输出
      mov al,8bh
      out dx,al
inout:  mov dx,io8255c             ;从C口输入一数据
      in al,dx;
	mov bl,al;
	
	lea dx,menu;
	call printString;	

	call printEnter;
	call inputAChar;

		
	cmp al,'1';
		je printBin;
	cmp al,'2';
		je printDec;
	cmp al,'3';
		je printHex;

      mov dl,0ffh                ;判断是否有按键
      mov ah,06h
      int 21h
      jz inout                ;若无,则继续自C口输入,A口输出
      mov ah,4ch              ;否则返回
      int 21h;



;-------------辅助函数----
printString proc near
	mov ah,09h;
	int 21h;
	ret;
printString endp;

printEnter proc near
	mov dl,0ah;
	mov ah,02h;
	int 21h;
	mov dl,0dh;
	mov ah,02h;
	int 21h;
	ret;
printEnter endp;

inputAChar proc near
	mov ah,01h;
	int 21h;
	ret;
inputAChar endp;

printBin:
	call printEnter;
	mov cx,08h;循环8位
	call again;
	call printEnter;
	jmp exit;
printDec:
	jmp exit;
printHex:
	call printEnter
	call hexTo;
	call printEnter;
	jmp exit;
hexTo:
        mov bh,bl;bh临时存下bl值，以下为输出高位的字符
        mov cl,04;
        and bl,11110000b;高位最高为1，因为两个十进制单位相加
        shr bl,cl;
        add bl,30h;
        mov dl,bl;
        call printAChar;

        mov bl,bh;输出低位字符
        and bl,00001111b;
        cmp bl,09h;
            ja l1;[a-z]若该值介于[a-z]，需加上37h，故特殊处理
        add bl,30h;补上30h
        mov dl,bl;
        call printAChar;输出该字符
        ret;


l1:
    add bl,37h;
    mov dl,bl;
    call printAChar;
    ret;
again:
	ror bl,1;
	mov dl,0;
	adc dl,30h;
	call printAChar;
	loop again;
	ret;

printAChar:
   	mov ah,02h;
	int 21h;
	ret;

exit:
	mov ah,4ch;
	int 21h;

code   ends
      end start
