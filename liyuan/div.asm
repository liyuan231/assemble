data segment
data ends

code segment
    assume cs:code,ds:data;
    start:
        mov ax,data;
        mov ds,ax;

        mov ax,10;
        mov bl,2;
        div bl;
code ends
    end start