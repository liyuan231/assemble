data segment
    buf db "1234567890abceFGHIJ_1234567890abceFGHIJ";
    count equ $-buf;
    numOfCap db 0;
    numOfLow db 0;
    numOfNum db 0;
    numOfOther db 0;

     menu db "1.print num",0dh,0ah
         db "2.print lower-case:",0dh,0ah
         db "3.print capitals",0dh,0ah
         db "4.exit",'$';
     numbuf db 100 dup(0);
     lowbuf db 100 dup(0);
     capbuf  db 100 dup(0);
     choise db 0;

     pointerNum dw 0;
     pointerLow dw 0;
     pointerCap dw 0;

     tipNum db "numbers:",'$';
     tipLow db "lowers:",'$';
     tipCap db "caps:",'$';

     ;dst db 100 dup(0);

data ends

code segment
    assume cs:code,ds:data
    start:
        mov ax,data;
        mov ds,ax;

        mov dx,offset menu;
        call disp;

        mov cx,0;
        mov cx,count;字符串长度
        lea si,buf;取输入字符的偏移地址

       mov ah,08h;
       ;int 21h;
       ;call printEnter;
       ;mov [choise],al;选择值在choise中
       lea ax,capbuf;
       mov [pointerCap],ax;cap指针

       lea ax,lowbuf;
       mov [pointerLow],ax;low指针

       lea ax,numbuf;
       mov [pointerNum],ax;

       again:
           ;0-9
           cmp byte ptr[si],30h;其他字符加一
           jb l1;
           cmp byte ptr[si],39h;
           jbe l2;
           ;A-Z
           cmp byte ptr[si],41h;其他字符加一
           jb l1;
           cmp byte ptr[si],5ah;
           jbe l3;
           ;a-z
           cmp byte ptr[si],61h;其他字符加一
           jb l1;
           cmp byte ptr[si],7ah;
           jbe l4;
        l1:
            inc numOfOther;
            jmp l5;
        l2:
            mov bx,[pointerNum];
            mov al,byte ptr[si];待存储的值，loop已使用cx
            mov [bx],al;将cl代表的字符放置在相应地址
            inc bx;
            mov [pointerNum],bx;

            inc numOfNum;
            jmp l5;
        l3:
            mov bx,[pointerCap];
            mov al,byte ptr[si];
            mov [bx],al;
            inc bx;
            mov [pointerCap],bx;

            inc numOfCap;
            jmp l5;
        l4:
            mov bx,[pointerLow];
            mov al,byte ptr[si];
            mov [bx],al;
            inc bx;
            mov [pointerLow],bx;

            inc numOfLow;
            jmp l5;
        l5:
            add si,1;
            loop again;
        complete:
            mov bx,[pointerLow];
            mov byte ptr[bx],'$';

            mov bx,[pointerCap];
            mov byte ptr[bx],'$';

            mov bx,[pointerNum];
            mov byte ptr[bx],'$';
            ;此时 numOfCap,numOfLow,numOfNum分别存储相应的长度

            ;call printNumbers;我移到了exit处
            mov ah,08h;
            int 21h;
            ;call printEnter;
            ;mov al,[choise];此处有个bug，但我不想改正 TODO
            cmp al,'1';
                je printNum;
            cmp al,'2';
                je printLow;
            cmp al,'3';
                je printCap;
            jmp exit;

    printNum:
        mov dx,offset numbuf;
        call disp;
        jmp exit;
    printCap:
        mov dx,offset capbuf;
        call disp;
        jmp exit;
    printLow:
        mov dx,offset lowbuf;
        call disp;
        jmp exit;

    exit:
        call printNumbers;完成扩展2
        mov ah,4ch
        int 21h;

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


    printNumbers:
        mov ah,09h;
        mov dx,offset tipNum;
        int 21h;
        lea bx,numOfNum;
        call transferAndOutput;

       mov ah,09h;
       mov dx,offset tipLow;
       int 21h;
       lea bx,numOfLow;
       call transferAndOutput;

        mov ah,09h;
        mov dx,offset tipCap;
        int 21h;
        lea bx,numOfCap;
        call transferAndOutput;
       ; call printEnter;
        ret;

    printEnter:
        mov dl, 0ah;
        mov ah,02h;
        int 21h;
        mov dl,0dh;
        mov ah,02h;
        int 21h
        ret;

    ;在此处将其中对应的值转为十进制并输出
    transferAndOutput:
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
code ends
    end start;


;ax(ah+al) bx(bh+bl) cx(ch,cl) dx(dh,dl)
;si di bp