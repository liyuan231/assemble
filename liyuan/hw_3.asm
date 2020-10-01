data segment
    tip db "Please input a string:",'$';
    buf db 100
        db ?
        db 100 dup(0);
data ends

code segment
    assume cs:code,ds:data;
    start:
        mov ax,data;
        mov ds,ax;

        mov ah,09h;输出提示
        mov dx,offset tip;
        int 21h;

        ;输入字符串
        mov dx,offset buf;
        mov ah,0ah;
        int 21h;

        mov ah,02h;回车
        mov dl,0dh;
        int 21h;

        mov ah,02h;换行
        mov dl,0ah;
        int 21h;

        mov bx,offset buf+1;该位置的下一位置即为用户真正的字符串开始
        mov cx,[bx];此时cx中cl存储了用户输入字符串的长度
        ;mov si,bx;


    ;现在已经将用户输入的字符串存入了stringbuf中了，现在开始处理用户输入的字符串
    deal:
        cmp cl,0;
            jz print;全部处理完输出即可
        dec cl;
        inc bx;
        mov al,[bx];依次比较其中每一个字符
        cmp al,'a';
            jae greaterThana;
        jmp deal;

    ;比'a'大
    greaterThana:
        cmp al,'z';
            jbe betweenaAndz;在 a-z区间则在处理
        jmp deal;否则返回遍历下一个字符

    ;此时的字符便是[a,z]区间，直接替换即可
    betweenaAndz:
        sub al,20h;
        mov [bx],al;
;        mov dl,al;
;        mov ah,02h;
;        int 21h;
        jmp deal;处理完便返回

    print:
        inc bx;
        mov byte ptr[bx],'$';
        mov dx, offset buf+2;前两位分别存储开辟的空间大小以及实际长度
        mov ah,09h;
        int 21h;
        jmp exit;
    exit:
        mov ah,4ch;
        int 21h;

code ends
    end start