data segment
    array db -2,-1,0,0,0,0,1,2,3;
    count equ $-array;
    numOfPos db 0;
    numOfNeg db 0;
    numOfZero db 0;

    tipZero db "zero:",'$';
    tipNeg db "negative:",'$';
    tipPos db "positive:",'$';
data ends

code segment
    assume cs:code,ds:data;
    start:
        mov ax,data;
        mov ds,ax;
        mov cx,count;
        lea bx,array;

        jmp again;

    again:
        mov al,[bx];
        inc bx;

        call isNeg;
        ;不是负数说明剩下的是0或整数
        add al,30h;
        call isZero;
        call isPos;
    loop again;
    jmp printNumbers;

    printNumbers:
        lea dx,tipZero;
        call printString;
        lea bx,numOfZero;
        call transferAndOutput;

        lea dx,tipPos;
        call printString;
        lea bx,numOfPos;
        call transferAndOutput;

        lea dx,tipNeg;
        call printString;
        lea bx,numOfNeg;
        call transferAndOutput;

        jmp exit;

    isZero:
        cmp al,30h;
            je countZero;
        ret;
    isPos:
        cmp al,30h;
            ja aboveZero;
        ret;
    isNeg:
        mov ah,al;ah备份
        and ah,10000000b;
        cmp ah,80h;若最高位为1则证明其为负数
            je countNeg;
        ret;

    countNeg:
        inc numOfNeg;
        ret;

    countZero:
        inc numOfZero;
        ret;

    aboveZero:
        cmp al,39h;
            jbe countPos;
        ret;
    countPos:
        inc numOfPos;
        ret;

    exit:
        mov ah,4ch;
        int 21h;

;--------------辅助函数------------------
;输出dx开始的字符串
printString proc near
    mov ah,09h;
    int 21h;
    ret;
printString endp;

;转换并输出bx中的值
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
    add al,30h;
    mov dl,al;

    mov ah,02h;
    int 21h;

    call printEnter;
    ret;
;回车换行
printEnter proc near
    mov dl,0ah;
    mov ah,02h;
    int 21h;

    mov dl,0dh;
    mov ah,02h;
    int 21h;
    ret;
printEnter endp;

code ends
    end start;