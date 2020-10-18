data segment
	mess 	db "please input", 0dh,0ah,'$';
	source db "1234567890abceFGHIJ";
	count equ $-source;
 	dst db 20 dup(?);
data ends

code segment
	assume cs:code,ds:data
    start:
        mov ax,data;
        mov ds,ax;

        mov dx,offset mess;
        mov ah,09h;
        int 21h

        mov ah,08h;
        int 21h
        cmp al,'1'
        jz num

    num:
        mov ah,09h;
        mov dx,offset source;
        int 21h;

        mov bx,offset source
        mov si,offset dst
        mov cl,count

    next:	mov al,[bx]
        cmp al,30h
        jb l1
        cmp al,39h
        ja l1
        mov [si],al
        inc si

    l1:	inc bx
        jnz next
        mov byte ptr[si],'$'
        mov dx,offset dst
        mov ah,9
        int 21
        jmp exit

    exit:	mov	ah, 4cH		;否则，返回DOS
            int	21H
code	ends
    end	start