data segment
    tip db "Please input a String:",'$';
    menu db 0dh,0ah,"1.print num",0dh,0ah
         db "2.print lower-case:",0dh,0ah
         db "3.print capitals",0dh,0ah
         db "4.exit",0ah,0dh,'$';
    buf db 100
        db ?
        db 100 dup(0);输入的字符串
    numbuf db 100 dup (0);
    lowercasebuf db 100 dup(0)
    uppercasebuf db 100 dup(0)
data ends
code segment
    assume cs:code,ds:data
    start:
        ;输出tip
        mov ax,data;
        mov ds,ax;
        mov dx,offset tip;
        mov ah,09h;
        int 21h;

        ;输入字符串
        mov dx,offset buf;
        mov ah,0ah;
        int 21h;

        ;输出menu
        mov dx,offset menu;
        mov ah,09h;
        int 21h;

        ;我认为先全部统计归类完最好
        mov bx,offset buf+1;用户输入的字符串的开始
        mov cx,[bx];
        mov si,offset numbuf;
        mov di,offset lowercasebuf;
        ;mov dx,offset uppercasebuf;大写字母模仿老师直接打印
        jmp dealing;

    dealing:
        inc bx;
        mov al,[bx];依次比较其中的字符串
           mov dl,al;
           mov ah,02h;
           int 21h;
        cmp al,'$';'$'字符串遍历结束
        jz complete;

        cmp al,'0';c<'0',直接跳过
        jb dealing;

        cmp al,'z';c>'z'直接跳过
        ja dealing;

        cmp al,'0';与aboveZero一起存储[0,9]的字符
        jae aboveZero;

        cmp al,'A';[A-Z]
        jae aboveUpperCaseA;

        cmp al,'a';[a-z]
        jae abovelowercasea;

    aboveZero:
        cmp al,'9';
        jbe storeANumber;

    aboveUpperCaseA:
        cmp al,'Z';
        jbe storeAUpperCase;


    abovelowercasea:
        cmp al,'z';
        jbe storeALowerCase;

    storeANumber:
        mov [si],al;
        inc si;
    storeAUpperCase:
        mov dl,al;
        mov ah,02h;
        int 21h;
       ;mov [dl],al;
       ;inc dl;
    storeALowerCase:
        mov [di],al;
        inc di;
    complete:
        mov byte ptr[si],'$';
        mov byte ptr[di],'$';
        ;mov byte ptr[sp],'$';

    exit:
        mov ah,4ch;
        int 21h;
code ends
    end start