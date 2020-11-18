
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
 
	mov dx,io8255b           ;��8255ΪC������,A�����
      mov al,8bh
      out dx,al
inout:  mov dx,io8255c             ;��C������һ����
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

      mov dl,0ffh                ;�ж��Ƿ��а���
      mov ah,06h
      int 21h
      jz inout                ;����,�������C������,A�����
      mov ah,4ch              ;���򷵻�
      int 21h;



;-------------��������----
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
	mov cx,08h;ѭ��8λ
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
        mov bh,bl;bh��ʱ����blֵ������Ϊ�����λ���ַ�
        mov cl,04;
        and bl,11110000b;��λ���Ϊ1����Ϊ����ʮ���Ƶ�λ���
        shr bl,cl;
        add bl,30h;
        mov dl,bl;
        call printAChar;

        mov bl,bh;�����λ�ַ�
        and bl,00001111b;
        cmp bl,09h;
            ja l1;[a-z]����ֵ����[a-z]�������37h�������⴦��
        add bl,30h;����30h
        mov dl,bl;
        call printAChar;������ַ�
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