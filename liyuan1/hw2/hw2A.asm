data segment
    tip db "Please input a number(0-9):",'$';提示用户输入数字
    menu db "1.Bin:",0dh,0ah,"2.Dec:",0dh,0ah,"3.Hex:",0dh,0ah,"4.Exit",'$';提示用户要使用哪一项功能
    numA db 0;存取用户输入的第一个数字
    numB db 0;存取用户输入的第二个数字
data ends

code segment
    assume cs:code,ds:data;
    start:
        mov ax,data;
        mov ds,ax;

        lea dx,tip;
        call printString;输出提示用户输入第一个数字
        call inputAChar;用户输入一个数字
        lea bx,numA;
        mov [bx],al;将用户输入的第一个数字保存到numA中

        call printEnter;回车换行

        lea dx,tip;同上，不过用户输入第二个数字
        call printString;
        call inputAChar;
        lea bx,numB;
        mov [bx],al;
        call printEnter;

    addOperation:
        lea dx,menu;
        call printStringEnter;提示用户要使用哪项功能
        call inputAChar;此时al中即为选择的答案
        cmp al,'1';
            je printBin;输出二进制答案
        cmp al,'2';
            je printDec;输出十进制答案
        cmp al,'3';
            je printHex;输出十六进制答案

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

    ;输出二进制答案
    printBin:
        call printEnter;回车换行
        ;mov bx,0;
        call readAddToBl;将numA，numB相加存到bl中,此时依旧需要解析bl中的十六进制的数字 0F
        mov cx,08h;0F即为8位
        call again;
        call printEnter;
        jmp exit;
        ;ret;

    ;使用循环左移的方法依次得到每一位，
    again:
        ;mov bh,bl;
        rol bl,1;左移一位
        mov dl,0;先置零
        ;and bh,10000000b;
        ;add bh,30h;
        ;mov dl,bh;
        adc dl,30h;由于adc为带进位加法指令，故直接相加，结果即为该位上的值 1h +30h =31h(数字1) 0h+30h= 30h(数字0)
        call printAChar;输出该值

    loop again;

    readAddToBl:
        lea bx,numA;
        mov al,[bx];
        lea bx,numB;
        mov ah,[bx];
        add al,ah;//常规两数相加
        sub al,60h;差值为30h+30h,因此此时dl即为答案，不过本身为16进制，需要转换为十进制，二进制，16进制
        mov bl,al;在此程序中约定将两数相加的和存到bl中；
        ret;

    printDec:
        call printEnter;
        lea bx,numA;
        mov al,[bx];
        sub al,30h;
        lea bx,numB;
        mov ah,[bx];
        sub ah,30h;
        add al,ah;两数相加
        daa;此时就可以了al中存的为10进制的值
        mov bl,al;在此程序中约定将两数相加的和存到bl中
        call hexTo;输出结果
        ;ret;
        call printEnter;回车换行
        jmp exit;

    printHex:
        call printEnter;
        call readAddToBl;本身答案即为16进制，得到和存在bl后直接调用输出
        call hexTo;输出bl中值
        call printEnter;
        jmp exit;
        ;ret;
    hexTo:
        mov bh,bl;bh临时存下bl值，以下为输出高位的字符
        mov cl,04;
        and bl,11110000b;高位最高为1，因为两个十进制单位相加
        shr bl,cl;
        add bl,30h;
        mov dl,bl;
        call printAChar;

        mov bl,bh;输出低位字符
        and bl,00001111b;
        cmp bl,09h;
            ja l1;[a-z]若该值介于[a-z]，需加上37h，故特殊处理
        add bl,30h;补上30h
        mov dl,bl;
        call printAChar;输出该字符
        ret;

    l1:
        add bl,37h;
        mov dl,bl;
        call printAChar;
        ret;


    ;-------------------------以下均为辅助函数--------------------------------
    ;输出一个字符
    printAChar:
        mov ah,02h;
        int 21h;
        ret;

    ;输出字符串以及回车换行
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

    ;输出字符串
    printString proc near
        mov ah,09h;
        int 21h;
        ret;
    printString endp

    ;输出回车换行
    printEnter proc near
        mov dl, 0ah;
        mov ah,02h;
        int 21h;
        mov dl,0dh;
        mov ah,02h;
        int 21h
        ret
    printEnter endp

    ;输入一个字符
    inputAChar proc near
        mov ah,01h;
        int 21h;
        ret;
    inputAChar endp;

code ends
    end start