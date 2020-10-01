data segment
    tip db "Please input a number(0-9):",'$';
    aid db 0dh,0ah,'$';
    tipDec db "Decimal:",'$';
    tipHex db "HexaDecimal:",'$';
    resultDec db "00",0ah,0dh,'$';两个个位相加，最多变成2位，这里存放十进制答案
    resultHex db "00",0ah,0dh,'$';

data ends

code segment
    assume ds:data,cs:code;
    start:
        mov ax,data;
        mov ds,ax;

        mov ah,09h;提示
        mov dx,offset tip;
        int 21h;

        mov ah,01h;
        int 21h;
        mov bl,al;bl存储第一个数字


        mov ah,09h;
        mov dx,offset aid;回车换行
        int 21h;

        mov ah,09h;提示
        mov dx,offset tip;
        int 21h;

        mov ah,01h;
        int 21h;
        mov bh,al;bh存储第二个数字

        mov ah,09h;
        mov dx,offset aid;回车换行
        int 21h;

;        mov cx,bx;备份bx中的两个数字

        sub bl,30h;
        sub bh,30h;
        add bl,bh;
        ;此时bl即为答案，但是是16进制，如9+8=17,此时bl=11

        mov si,bx;输出16进制的答案
        mov al,bl;这三步为区分10进制和16进制答案的关键！！！
        daa;
        mov bl,al;将16进制转为10进制放回bl中



        mov bh,bl;bh临时存放下
        mov di,offset  resultDec;这是答案的位置

        and bl,11110000b;
        mov cl,04;
        shr bl,cl;移位操作好像必须在cl中读取

        add bl,30h;
        mov [di],bl;
        inc di;

        mov bl,bh;
        and bl,00001111b;获取个位，此时bl仅有个位的值
        add bl,30h;

        mov [di],bl;
        inc di;
        mov bl,bh;


        mov ah,09h;
        mov dx,offset tipDec;
        int 21h;
        mov dx,offset resultDec;
        int 21h;

    Hex:
        mov bx,si;si临时保存bx的值，
        mov bh,bl;bh临时存放下
        mov di,offset resultHex;这是答案的位置

        and bl,11110000b;获取十位的值
        mov cl,04;
        shr bl,cl;移位操作好像必须在cl中读取
        cmp bl,9h;
            ja dealCase1;
    Hex2:
        add bl,30h;
        mov [di],bl;
        inc di;

        mov bl,bh;
        and bl,00001111b;获取个位，此时bl仅有个位的值
        cmp bl,9h;
            ja dealCase2;

    Hex1:
        add bl,30h;
        mov [di],bl;
        inc di;
        mov bl,bh;

        mov ah,09h;
        mov dx,offset tipHex;
        int 21h;
        mov dx,offset resultHex;
        int 21h;

    exit:
        mov ah,4ch
        int 21h;

    dealCase2:
        add bl,07h;
        jmp Hex1;
    dealCase1:
        add bl,07h;
        jmp Hex2;
code ends
    end start



