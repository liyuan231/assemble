;输出一个字符
code segment
    assume cs:code
    start:
        mov dl,"A"
        mov ah,2
        int 21h
    exit:
        mov ah,4ch
        int 21h
code ends
    end start

