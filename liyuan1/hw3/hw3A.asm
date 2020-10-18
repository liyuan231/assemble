data segment


    tipNum db "numbers:",'$';
    tipLow db "lowers:",'$';
    tipCap db "caps:",'$';

    numOfCap db 0;
        numOfLow db 0;
        numOfNum db 0;

    buf db 100
        db ?
        db 100 dup(0);输入字符串

    result db 100
           db ?
           db 100 dup(0);存储小写转为大写的结果

    pointerCap dw 0;

data ends

code segment
    assume cs:code,ds:data
    start:
        mov ax,data;
        mov ds,ax;

        lea dx,buf;
        call inputString;
        call printEnter;

        lea dx,result;
        mov [pointerCap],dx;

        lea bx,buf+1;
        mov cx,[bx];
        mov ch,0;

    again:
        inc bx;
        mov al,[bx];
        cmp al,61h;
            jae aboveEqualLowa;
        cmp al,41h;
            jae aboveEqualCapA;
        cmp al,30h;
            jae aboveEqualZero;
        call store;


    aboveEqualZero:
        cmp al,39h;
            jbe countNum;
        jmp store;

    countNum:
        inc numOfNum;
        jmp store;

    aboveEqualCapA:
        cmp al,5ah;
            jbe countCap;
        jmp store;

    countCap:
        inc numOfCap;
        jmp store;

    aboveEqualLowa:
        cmp al,7ah;
            jbe transferAndStore;
        jmp store;

    ;小写字母匹配
    transferAndStore:
        inc numOfLow;
        sub al,20h;
        mov dx,bx;临时存储bx
        mov bx,[pointerCap];
        mov [bx],al;
        inc bx;
        mov [pointerCap],bx;
        mov bx,dx;还回bx
        jmp store;

    store:
        mov [bx],al;
        loop again;
        jmp complete;


    complete:
        inc bx;
        mov byte ptr[bx],'$';

        mov bx,[pointerCap];
        mov byte ptr[bx],'$';


        ;lea dx,buf+2;
        lea dx,result;
        call printString;
        call printEnter;

        lea dx,tipLow;
        call printString;
        lea bx,numOfLow;
        call transferAndOutput;

        lea dx,tipCap;
        call printString;
        lea bx,numOfCap;
        call transferAndOutput;

        lea dx,tipNum;
        call printString;
        lea bx,numOfNum;
        call transferAndOutput;

    exit:
        mov ah,4ch;
        int 21h;


;-----------------辅助函数---------------------
    inputString proc near
        mov ah,0ah;
        int 21h;
        ret;
    inputString endp;

    printString proc near
        mov ah,09h;
        int 21h;
        ret;
    printString endp;

    printEnter proc near
        mov dl,0ah;
        mov ah,02h;
        int 21h;

        mov dl,0dh;
        mov ah,02h;
        int 21h;
        ret;
    printEnter endp;

    printChar:
        mov ah,02h;
        int 21h;
        ret;

    transferAndOutput:
        add al,0;置零cf位
                mov al,[bx];
                daa;此时al中即为相应的答案，但需要转换为10进制
                mov bl,al;ah临时保存
                mov cl,04;
                and al,11110000b;
                shr al,cl;
                add al,30h;
                mov dl,al;

                mov ah,02h;
                int 21h;

                mov al,bl;
                and al,00001111b;
                ;cmp al,09h;
                ;    ja l1;[a-z]
                add al,30h;
                mov dl,al;

                mov ah,02h;
                int 21h;

                call printEnter;
                ret;
    l1:
        add al,37h;
        mov dl,al;
        mov ah,02h;
        int 21h;
        ret;

code ends
    end start;