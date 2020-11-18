 ;*******************************;
;* 8255方式0的C口输入,A口输出  *;
;*******************************;
data segment
	menu db "1.bit-1:",0dh,0ah,"2.bit-2:",0dh,0ah,"3.bit-3:",0dh,0ah,"4.Exit",'$';

	io8255a        equ 288h;
	io8255b        equ 28bh;
	io8255c        equ 28ah;
	
	num db 0;

data ends

code   segment
      assume cs:code
start:  mov dx,io8255b           ;设8255为C口输入,A口输出
      mov al,8bh
      out dx,al
	mov bh,00000000b;
	mov al,10000000b;
	mov cx,0fffh;
	
inout:  
	mov dx,io8255a             ;从A口输出刚才自C口
      out dx,al;               ;所输入的数据
	mov bh,cl;
	
	ror al,01h;

	mov cl,bh;  

   	call delay;
	loop inout;
	
	jmp exit;

delay proc near
	mov bx,700;
l2:
	mov cx,0h;
	l1:	dec cx;	
		jnz l1;
	dec bx;
	jnz l2;
	ret;
delay endp;
	
printString proc near
	mov ah,09h;
	int 21h;
	ret;
printString endp;

inputAChar proc near
	mov ah,01h;
	int 21h;
	ret;
inputAChar endp;

exit:
	mov ah,4ch;
	int 21h;

code   ends
      end start
