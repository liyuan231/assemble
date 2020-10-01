data segment
    tip db "Please input a String:",'$';
    menu db 0dh,0ah,"1.print num",0dh,0ah
         db "2.print lower-case:",0dh,0ah
         db "3.print capitals",0dh,0ah
         db "4.exit",0ah,0dh,'$';
    buf db 100
        db ?
        db 100 dup(0);输入的字符串

    numbuf db 100 dup (0);
    lowercasebuf db 100 dup(0)
    uppercasebuf db 100 dup(0)
data ends
code segment
    assume cs:code,ds:data
    start:
        ;输出tip
        mov ax,data;
        mov ds,ax;

        mov dx,offset tip;
        mov ah,09h;
        int 21h;

        ;输入字符串
        mov dx,offset buf;
        mov ah,0ah;
        int 21h;

        ;输出menu
        mov dx,offset menu;
        mov ah,09h;
        int 21h;

        ;我认为先全部统计归类完最好
        mov bx,0;
        mov bx,offset buf+1;用户输入的字符串的开始
        mov cx,[bx];用户字符串长度

        mov bp,offset numbuf;

        mov di,offset lowercasebuf;
        mov si,offset uppercasebuf;
        jmp dealing;

    dealing:
        cmp cl,0;
        jz complete;
        dec cl;
        inc bx;
        mov al,[bx];依次比较其中的字符串
           ;mov dl,al;
           ;mov ah,02h;
           ;int 21h;
        cmp al,'z';
            ja dealing;
        cmp al,'0';
            jb dealing;

        cmp al,'9';
            jbe regionOfNumber;

        cmp al,'a';
            jae regionOfLowercase;

        cmp al,'A';
            jae regionUppercase;

        jmp dealing

    ;全部工作已经完成了！bx,cx可以使用了
    complete:
        mov byte ptr[si],'$';
        inc si;
        mov byte ptr[di],'$';
        inc di;
        mov byte ptr[bp],'$';
        inc bp;
        ;输入选项
        mov ah,01h;
        int 21h;
        mov bl,al;因为al的值随下面回车换行改变，因此临时保存下

        mov ah,02h;
        mov dl,0dh;
        int 21h;

        mov ah,02h;
        mov dl,0ah;
        int 21h;

        mov al,bl;

        cmp al,'1';
            je printnums;
        cmp al,'2';
            je printLowercase;
        cmp al,'3';
            je printUppercase;
        cmp al,'4';
            je exit;
        jmp exit;

    regionOfNumber:
        mov [bp],al;
        inc bp;
        jmp dealing;

        ;mov []
        ;mov dl,al;
        ;mov ah,02h;
        ;int 21h;
        ;jmp dealing;

    regionOfLowercase:
        mov [di],al;
        inc di;
        jmp dealing;

    regionUppercase:
        cmp al,5bh;
            je dealing;
        cmp al,5dh;
            je dealing;
        cmp al,5eh;
            je dealing;
        cmp al,60h;
            je dealing;
        cmp al,'Z';Y,[在Z的后面
            jbe storeAUppercase;

    storeAUppercase:
        mov [si],al;
        inc si;
        jmp dealing;

    ;小写字母 lowercasebuf->di
    printLowercase:
        mov ah,09h;
        mov dx,offset lowercasebuf;
        int 21h;
        jmp exit;

    ;大写字母 uppercasebuf->si
    printUppercase:
        mov ah,09h;
        mov dx,offset uppercasebuf;
        int 21h;
        jmp exit;

    printnums:
        mov ah,09h;
        mov dx,offset numbuf;
        int 21h;
        jmp exit;

    exit:
        mov ah,4ch;
        int 21h;
code ends
    end start