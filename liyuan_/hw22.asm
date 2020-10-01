data segment
    tip db "Please input a number(0-9):",'$';
    menu db "1.Bin:",0dh,0ah,"2.Dec:",0dh,0ah,"3.Hex:",0dh,0ah,"4.Exit",'$';
    numA db 0;
    numB db 0;
data ends

code segment
    assume cs:code,ds:data;
    start:
        mov ax,data;
        mov ds,ax;

        lea dx,tip;
        call printString;
        call inputAChar;
        lea bx,numA;
        mov [bx],al;

        call printEnter;

        lea dx,tip;
        call printString;
        call inputAChar;
        lea bx,numB;
        mov [bx],al;
        call printEnter;

    addOperation:
        lea dx,menu;
        call printStringEnter;
        call inputAChar;此时al中即为选择的答案
        cmp al,'1';
            je printBin;
        cmp al,'2';
            je printDec;
        cmp al,'3';
            je printHex;

        call printEnter;
        jmp exit;

        ;call printHex;
        ;call printEnter;

        ;call printDec;
        ;call printEnter;

        ;call printBin;

    exit:
        mov ah,4ch;
        int 21h;

    printBin:
        call printEnter;
        ;mov bx,0;
        call readAddToBl;此时依旧需要解析bl中的十六进制的数字 0F
        mov cx,08h;0F即为8位
        call again;
        call printEnter;
        jmp exit;
        ;ret;

    again:
        ;mov bh,bl;
        rol bl,1;
        mov dl,0;
        ;and bh,10000000b;
        ;add bh,30h;
        ;mov dl,bh;
        adc dl,30h;
        call printAChar;

    loop again;

    readAddToBl:
        lea bx,numA;
        mov al,[bx];
        lea bx,numB;
        mov ah,[bx];
        add al,ah;
        sub al,60h;差值为30h+30h,因此此时dl即为答案，不过本身为16进制，需要转换为十进制，二进制，16进制
        mov bl,al;
        ret;

    printDec:
        call printEnter;
        lea bx,numA;
        mov al,[bx];
        sub al,30h;
        lea bx,numB;
        mov ah,[bx];
        sub ah,30h;
        add al,ah;
        daa;此时就可以了al中存的为10进制的值
        mov bl,al;
        call hexTo;
        ;ret;
        call printEnter;
        jmp exit;

    printHex:
        call printEnter;
        call readAddToBl;
        call hexTo;
        call printEnter;
        jmp exit;
        ;ret;
    hexTo:
        mov bh,bl;
        mov cl,04;
        and bl,11110000b;高位最高为1，因为两个十进制单位相加
        shr bl,cl;
        add bl,30h;
        mov dl,bl;
        call printAChar;

        mov bl,bh;
        and bl,00001111b;
        cmp bl,09h;
            ja l1;[a-z]
        add bl,30h;
        mov dl,bl;
        call printAChar;
        ret;

    l1:
        add bl,37h;
        mov dl,bl;
        call printAChar;
        ret;


    ;-------------------------以下均为辅助函数--------------------------------
    printAChar:
        mov ah,02h;
        int 21h;
        ret;

    printStringEnter proc near
        mov ah,09h;
        int 21h;
        mov dl, 0ah;
        mov ah,02h;
        int 21h;
        mov dl,0dh;
        mov ah,02h;
        int 21h
        ret
    printStringEnter endp

    printString proc near
        mov ah,09h;
        int 21h;
        ret;
    printString endp

    printEnter proc near
        mov dl, 0ah;
        mov ah,02h;
        int 21h;
        mov dl,0dh;
        mov ah,02h;
        int 21h
        ret
    printEnter endp

    inputAChar proc near
        mov ah,01h;
        int 21h;
        ret;
    inputAChar endp;

code ends
    end start