data segment
     array dw -99h,-30h,-20h,-10h,0h,0h,1h,10h,20h,99h,1h,2h,3h,4h,5h,6h,7h;
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
        lea bx,array;bx指向该数组
        jmp again;

    again:
        dec cx;因为是一个字，所以这里额外减去1,这样就恰好达到正常的循环次数
        mov al,[bx];
        inc bx;
        mov ah,[bx];
        inc bx;
        call isNeg;
        call isZero;
        inc numOfPos;剩下的都是正数
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
        mov dl,[bx];

        ;为实现老师功能而设置
        lea bx,numOfPos;
        mov dh,[bx];

        lea bx,numOfNeg;
        mov dl,[bx];

        lea bx,numOfZero;
        mov bh,[bx];

        jmp exit;


    exit:
        mov ah,4ch;
        int 21h;


    isZero:
        cmp ax,0000h;
            je countZero;
        ret;


    isNeg:
        mov dx,ax;ax中不动
        and dx,1000000000000000b;
        cmp dx,8000h;若最高位为1则证明其为负数
            je countNeg;
        ret;

    countNeg:
        inc numOfNeg;
        loop again;
        jmp printNumbers;

    countZero:
        inc numOfZero;
        loop again;
        jmp printNumbers;



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
