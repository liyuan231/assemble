 ;*******************************;
;* 8255��ʽ0��C������,A�����  *;
;*******************************;
io8255a        equ 288h
io8255b        equ 28bh
io8255c        equ 28ah
code   segment
      assume cs:code
start:  mov dx,io8255b           ;��8255ΪC������,A�����
      mov al,8bh
      out dx,al
	mov bh,00000000b;
	mov al,11110000b;
mov cx ,0ffffh;
inout:  
	mov dx,io8255a             ;��A������ղ���C��
      out dx,al;               ;�����������
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