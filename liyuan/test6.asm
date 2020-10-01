data segment
    buf db "123",'$';
data ends

code segment
    assume ds:data,cs:code;
    start:
        mov ax,data;
        mov ds,ax;

        mov al,buf
        mov bl,8
    l1:mov dl,0
       shl al,1
       mov bh，al
       adc dl,3o0h  ;显示数据到屏幕
       mov ah, 02
       int 21h
       mov al，bh
       dec bl	;8位完否
       jnz l1
       mov dl,0dh ;加回车，换行符
       mov ah, 02
       int 21h
       mov dl,0ah
       mov ah, 02
       int 21h

code ends
    end start