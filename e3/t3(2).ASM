 ;*******************************;
;* 8255��ʽ0��C������,A�����  *;
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
start:  mov dx,io8255b           ;��8255ΪC������,A�����
      mov al,8bh
      out dx,al
	mov bh,00000000b;
	mov al,10000000b;
	mov cx,0fffh;
	
inout:  
	mov dx,io8255a             ;��A������ղ���C��
      out dx,al;               ;�����������
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