data segment
    menu  db 0dh,0ah,"1.print num",0dh,0ah
          db "2.print lower-case:",0dh,0ah
          db "3.print capitals",0dh,0ah
          db "4.exit",'$';

    tipOfNum db "number:",'$';
    tipOfLow db "lower:",'$';
    tipOfCap db "Cap:",'$';

    resultNum db "00",'$';
    resultLow db "00",'$';
    resultCap db "00",'$';

    numbuf db 100 dup(0);
    lowercasebuf db  100 dup(0);
    uppercasebuf db 100 dup(0);
    ;9数字，10小写字母；11大写字母
    source db "1111111111 aaaaaaaaa A";
    count equ $-source;字符串长度

data ends

code segment
    assume cs:code,ds:data;
    start:
        mov ax,data;数据段调整
        mov ds,ax;
        mov dx,offset menu;
        call disp;

        mov si,offset uppercasebuf;
        mov di,offset lowercasebuf;
        mov bp,offset numbuf;

        mov bx,offset source;bx指向字符串
        mov al,count;al存储字符串长度
        jmp dealing;

    dealing:
        cmp al,0;
            jz complete;
        dec al;
        mov cl,[bx];遍历每一个字符
        inc bx;

        cmp cl,'0';
            jb dealing;
        cmp cl,'z';
            ja dealing;
        cmp cl,'9';
            jbe regionOfNum;
        cmp cl,'a';
            jae regionOfLow;
        cmp cl,'A';
            jae greaterThanA;

        ;mov ah,02h;
        ;mov dl,cl;
        ;int 21h;
        jmp dealing;


    greaterThanA:
        cmp cl,'Z';
            jbe regionOfCap;
        jmp dealing;

    regionOfNum:
        mov [bp],cl;
        inc bp;
        jmp dealing;

    regionOfLow:
        mov [di],cl;
        inc di;
        jmp dealing;

    regionOfCap:
        mov [si],cl;
        inc si;
        jmp dealing;

    complete:
        mov byte ptr[si],'$';
        mov byte ptr[di],'$';
        mov byte ptr[bp],'$';

        sub si,offset uppercasebuf;
        mov dx,0;
        mov dx,si;
        mov ax,0;
        mov al,dl;
        daa;
        mov si,ax;
        ;call disp2;此时si为0001

         mov bx,si;临时存下
         mov bh,bl;
         mov si,offset resultNum;
         and bl,11110000b;
         mov cl,04;
         shr bl,cl;
         add bl,30h;
         mov [si],bl;
         inc si;

         mov bl,bh;
         and bl,00001111b;
         add bl,30h;
         mov [si],bl;
         inc si;

         mov dx,offset resultNum;
         call disp;


        sub di,offset lowercasebuf;
        mov dx,0;
        mov dx,di;
        mov ax,0;
        mov al,dl;
        daa;
        mov di,ax;
        mov bx,di;
        mov bh,bl;
        mov di,offset resultLow;
        and bl,11110000b;
        mov cl,04;
        shr bl,cl;
        add bl,30h;
        mov [di],bl;
        inc di;

        mov bl,bh;
        and bl,00001111b;
        add bl,30h;
        mov [di],bl;
        inc di;
        mov dx,offset resultLow;
        call disp;
        ;//此时di中存放的即为个数答案 0011，小写字母
        ;call disp2;
;----------------------------
        sub bp,offset numbuf;
        mov dx,0;
        mov dx,bp;
        mov ax,0;
        mov al,dl;
        daa;
        mov bp,ax;此时bp中的即为答案
;------------------------------------
        mov bx,bp;
        mov bh,bl;
        mov bp,offset resultCap;
        and bl,11110000b;
        mov cl,04;
        shr bl,cl;
        add bl,30h;
        mov [bp],bl;
        inc bp;

        mov bl,bh;
        and bl,00001111b;
        add bl,30h;
        mov [bp],bl;
        inc bp;
        mov dx,offset resultCap;
        call disp;
        ;call disp2;

        mov ah,08h;
        int 21h;

        cmp al,'1';
            jz printnum;
        cmp al,'2';
            jz printlow;
        cmp al,'3';
            jz printcap;

        jmp exit;

    exit:
        mov ah,4ch;
        int 21h;

    printnum  :
        mov dx,offset numbuf;
        call disp;
        jmp exit;

    printlow:
        mov dx,offset lowercasebuf;
        call disp;
        jmp exit;
    printcap:
        mov dx,offset uppercasebuf;
        call disp;
        jmp exit;
    ;子程序，输出dx指向的字符串并回车换行

    disp proc near
        mov ah,09h;
        int 21h;
        mov dl, 0ah;
        mov ah,02h;
        int 21h;
        mov dl,0dh;
        mov ah,02h;
        int 21h
        ret
    disp endp

    ;此时存储的是si(0011),di(0010),bp(0009),需移位操作
    disp2 proc near
        ;add dl,30h;
        mov ah,02h;
        int 21h;


        mov dl, 0ah;回车
        mov ah,02h;
        int 21h;
        mov dl,0dh;换行
        mov ah,02h;
        int 21h
        ret
    disp2 endp
code ends
    end start