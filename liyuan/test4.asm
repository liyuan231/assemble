;测试 xlat指令
data segment
   tip db "Please input a String:",'$';
data ends

code segment
    assume cs:code,ds:data
    start:
        mov ax,data;以下两步为调整数据段的位置，因为默认从0开始
        mov ds,ax;

        mov ah,01h;
        int 21h;
        sub al,30h;
        mov bx,offset tip;

        mov al,al;
        xlat;

        mov dl,al;
        mov ah,02h;
        int 21h;

    exit:
        mov ah,4ch;
        int 21h;
code ends
    end start