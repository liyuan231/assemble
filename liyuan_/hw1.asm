data segment
     menu db 0dh,0ah,"1.print num",0dh,0ah
             db "2.print lower-case:",0dh,0ah
             db "3.print capitals",0dh,0ah
             db "4.exit",0ah,0dh,'$';
     tipOfNumberOfNum db "The number of number is ",'$';
     tipOfNumberOfLowercase db "The numbe of lowercase is: ",'$';
     tipOfNumberOfUppercase db "The number of uppercase is: ",'$';
     source db "1aA";
     count equ $-source;
     numbuf db 100 dup(0);
     lowercasebuf db 100 dup(0);
     uppercasebuf  db 100 dup(0);


data ends

code segment
    assume cs:code,ds:data;
    start:
        mov ax,data;
        mov ds,ax;

        mov dx,offset menu;
        mov ah,09h;
        int 21h;

        mov bx,offset source;字符串的开始
        mov al,count;al中存储字符串的长度

        mov bp,offset numbuf;这样相对简单一些
        mov di,offset lowercasebuf;
        mov si,offset uppercasebuf;

        jmp dealing;

    dealing:
        cmp al,0;
            jz complete;
        dec al;
        inc bx;当前字符的位置

        mov cl,[bx];当前字符

        cmp cl,'z';
            ja dealing;
        cmp cl,'0';
            jb dealing;

        cmp cl,'9';
            jbe regionOfNumber;

        cmp cl,'a';
            jae regionOfLowercase;

        cmp cl,'A';
            jae regionUppercase;

        jmp dealing;

    regionOfNumber:
        mov [bp],cl;
        inc bp;
        jmp dealing;

    regionOfLowercase:
         mov [di],cl;
         inc di;
         jmp dealing;

    regionUppercase:
         cmp cl,5bh;
            je dealing;
        cmp cl,5dh;
            je dealing;
        cmp cl,5eh;
            je dealing;
        cmp cl,60h;
            je dealing;
        cmp cl,'Z';Y,[在Z的后面
            jbe storeAUppercase;


    storeAUppercase:
        mov [si],cl;
        inc si;
        jmp dealing;

    complete:
       mov byte ptr[si],'$';
       inc si;
       mov byte ptr[di],'$';
       inc di;
       mov byte ptr[bp],'$';

       inc bp;
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

       ;输出“数字字符的个数为：”
       mov ah,09h;
       mov dx,offset tipOfNumberOfNum;
       int 21h;

       mov ah,02h;
       mov dl,bp;
       int 21h;

        ;输出“小写字母的个数为：”
       mov ah,09h;
       mov dx,offset tipOfNumberOfLowercase;
       int 21h;

       mov ah,02h;
       mov dl,di;
       int 21h;

     ;输出“大写字母的个数为：”
       mov ah,09h;
       mov dx,offset tipOfNumberOfUppercase;
       int 21h;

       mov ah,02h;
       mov dl,di;
       int 21h;

       cmp al,'1';
            je printnums;
       cmp al,'2';
            je printLowercase;
       cmp al ,'3';
            je printUppercase;
       cmp al,'4';
            je exit;
       jmp exit;

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