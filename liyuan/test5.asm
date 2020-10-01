;将buf中的数以16进制显示到屏幕
data segment
    buf db "123456",'$';
data ends

code segment
    assume cs:code,ds:data;
    start:
        mov ax,data;
        mov ds,ax;

        mov al,buf;将buf字符串中第一位送入al中，此时al = 31(0的ASCII);
        mov bh,al;
        mov cl,4;

        shr al,cl;al中内容右移cl位
        cmp al,10h;若al中内容>=A，加37A
            jb next;
        add al,7h;

    next:
        add al,30h;否则，加30h
        mov dl,al;
        mov ah,2;
        int 21h;

        mov al,bh;
        and al,0fh;屏蔽掉高四位，再处理低四位
        cmp al,0ah;
        jb next1;
            add al,7h;
    next1:
        add al,30h;
        mov dl,al;
        mov ah,2;
        int 21h;

code ends
    end start