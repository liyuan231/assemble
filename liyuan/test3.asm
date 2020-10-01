;输入一个字符串
data segment
    tip db "please input a String:$";字符串以$符号结尾
    buf db 64h
        db ?
        db 64h dup(0)
    crlf db 0ah,0dh,'$';
data ends
code segment
    assume cs:code,ds:data
    start:
       ;输出tip
        mov ax,data;
        mov ds,ax;
        mov dx,offset tip;
        mov ah,9;
        int 21h;

        ;输入字符串
        mov dx,offset buf;
        mov ah,10;
        int 21h;

        ;为字符串末尾添上$
        mov bx,offset buf;;此处获取保存该字符串的长度的位置
        mov ax,[bx+1];依照位置获取其中的值，该值为字符串长度
        add al,bl;
        add al,2;al里存有输入字符串的结尾index+1
        mov ah,00;
        mov si,ax;
        mov byte ptr[si],0dh;
        add si,1;
        mov byte ptr[si],0ah;
        add si,1;
        mov byte ptr[si],'$';

        ;临时保存
        mov si,dx;
        ;先输出回车换行
        mov ah,02h;
        mov dl,0ah;
        int 21h;
        mov ah,02h;
        mov dl,0dh;
        int 21h;
        ;输出字符串
        mov dx,si;
        mov ah,09h;
        add dx,2;
        int 21h;

    exit:
        mov ah,4ch;
        int 21h;
code ends
    end start
