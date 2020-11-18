 ;*******************************;
;* 8255方式0的C口输入,A口输出  *;
;*******************************;
io8255a        equ 288h
io8255b        equ 28bh
io8255c        equ 28ah
code   segment
      assume cs:code
start:  mov dx,io8255b           ;设8255为C口输入,A口输出
      mov al,8bh
      out dx,al
	mov bh,00000000b;
	mov al,11110000b;
mov cx ,0ffffh;
inout:  
	mov dx,io8255a             ;从A口输出刚才自C口
      out dx,al;               ;所输入的数据
	ror al,1;  
   	call delay;
	push ax;
	mov al,bh;
	out dx,al;
	pop ax;
	loop inout;
	
	jmp exit;

delay proc near
	mov bx,50;
l2:
	mov cx,0h;
	l1:	dec cx;	
		jnz l1;
	dec bx;
	jnz l2;
	ret;
delay endp;
	

exit:
	mov ah,4ch;
	int 21h;

code   ends
      end start
