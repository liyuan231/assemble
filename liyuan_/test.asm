data segment
    menu  db 0dh,0ah,"1.print num",0dh,0ah
          db "2.print lower-case:",0dh,0ah
          db "3.print capitals",0dh,0ah
          db "4.exit",'$';

    resultOfNum db "00",'$';
    resultOfLow db "00",'$';
    resultOfCap db "00",'$';

    pointerNum dw 0;
    pointerLow dw 0;
    pointerCap dw 0;

    source db "123 a AA";

    numbuf db 100 dup(0);
    lowerbuf db 100 dup(0);
    upperbuf db 100 dup(0);

    count equ $-source;

data ends

code segment
    assume cs:code,ds:data;
    start:
         mov ax,data;数据段调整
         mov ds,ax;

         mov dx ,offset menu;
         call disp;


         mov ptr[pointerNum],offset upperbuf;
         mov ptr[pointerLow],offset lowerbuf;
         mov ptr[pointerCap],offset upperbuf;
         mov bx,offset source;
         mov ax,count;

    dealing:
        cmp al,0;
            jz complete;
        dec al;
        mov cl,[bx];
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
        jmp dealing;

    regionOfNum:
        mov ptr[pointerNum],cl;
        inc pointerNum;
        jmp dealing;
    regionOfLow:
        mov ptr[pointerLow],cl;
        inc pointerLow;
        jmp dealing;
    greaterThanA:
        cmp cl,'Z';
            jbe regionOfCap;
        jmp dealing;
    regionOfCap:
        mov ptr[pointerCap],cl;
        inc pointerCap;
        jmp dealing;

    complete:
        mov byte ptr[pointerCap],'$';
        mov byte ptr[pointerNum],'$';
        mov byte ptr[pointerNum],'$';

        sub si,offset upperbuf;
        sub di,offset lowerbuf;
        sub bp,offset numbuf;
        ;此时si，di，bi分别存储了大写，小写，数字的个数

        mov dx,offset numbuf;
        call disp;
        mov dx,offset lowerbuf;
        call disp;
        mov dx,offset upperbuf;
        call disp;


    exit:
        mov ah,4ch;
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



code ends
    end start