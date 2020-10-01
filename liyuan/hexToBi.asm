;16位2进制转10进制
data segment
      tip db "please input",0dh,0ah,'$';
data ends
 assume cs:code,ds:data;
code segment
    start:
        mov ax,data;
        mov ds,ax;

        and ah,0;
        mov bl,100;
        div bl;
        mov cl,ah;
        add al,30h;
        mov dl,al;

        mov ah,02h;
        int 21h;

        mov al,cl;
        mov bl,10;
        and ah,0;
        div bl;

        add al,30h;
        mov dl,al;
        mov cl,ah;
        mov ah,02h;
        int 21h;

        mov al,cl;
        add al,30h;
        mov dl,al;
        mov ah,02h;
        int 21h;
        ret;

code ends
    end start