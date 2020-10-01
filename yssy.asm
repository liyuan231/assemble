;键盘输入字母数字混合串，菜单选1输出其中数字串、选2输出其中小写字母串、
;选3按字符输出大写字母
data segment
	mess 	db "please input", 0dh,0ah,'$'
	menu    db "1 print num", 0dh,0ah
		db "2 print lower-case", 0dh,0ah
		db "3 print capitals", 0dh,0ah
		db "4 exit", 0dh,0ah,'$'
	buf     db 100 
    		db 	?
		db 	100 dup (0)
	lowbuf  db 100 dup (0)
	numbuf 	db 100 dup (0)
    ;source db "1234567890abceFGHIJ"
    ;count equ $-source
    ;dst db 20 dup(?)
data ends
code segment
   assume cs:code,ds:data,es:data
start:	mov ax,data
	mov ds,ax
	mov dx,offset mess
	mov ah,9
	int 21h
	mov dx,offset buf
	mov ah,10
	int 21h
	mov dl,0ah
	mov ah,2
	int 21h
	mov dl,0dh
	mov ah,2
	int 21h
	mov dx,offset menu
	mov ah,9
	int 21h
	mov ah,8
	int 21h
	cmp al,'1'
	jz num
	cmp al,'2'
	jz low1
	cmp al,'3'
	jz cap
	jmp exit
num:	
	mov bx,offset buf+2
	mov si,offset numbuf
	mov cl,buf+1
next1:	mov al,[bx]
	cmp al,30h
	jb l1
	cmp al,39h
	ja l1
	mov [si],al
	inc si
l1:	inc bx
	dec cl
	jnz next1
	mov byte ptr[si],'$'
	mov dx,offset numbuf
	mov ah,9
	int 21h
	jmp exit
	

low1:	mov bx,offset buf+2
	mov si,offset lowbuf
	mov cl,buf+1
next2:	mov al,[bx]
	cmp al,61h
	jb l2
	cmp al,7ah
	ja l2
	mov [si],al
	inc si
l2:	inc bx
	dec cl
	jnz next2
	mov byte ptr[si],'$'
	mov dx,offset lowbuf
	mov ah,9
	int 21h
	jmp exit
	
cap:	mov bx,offset buf+2
	mov cl,buf+1
	
next3:	mov al,[bx]
	cmp al,41h
	jb l3
	cmp al,5ah
	ja l3
	mov dl,al
	mov ah,2
	int 21h
	inc si
l3:	inc bx
	dec cl
	jnz next3
exit:	mov	ah, 4cH		;否则，返回DOS
		int	21H
	code	ends
		end	start

