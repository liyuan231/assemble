;输出一个字符串
data segment
    tip db "please input",0dh,0ah,'$'
data ends

code segment
    assume cs:code,ds:data
    start:
        mov ax,data;
        mov ds,ax;
        mov dx,offset tip;
        mov ah,09h;
        int 21h;
    exit:
        mov ah,4ch;
        int 21h;
code ends
    end start

