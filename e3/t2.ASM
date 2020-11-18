  ;*******************************;
;* 8255方式0的C口输入,A口输出  *;
;*******************************;
io8255a        equ 288h
io8255b        equ 28bh
io8255c        equ 28ah
code   segment
      assume cs:code
start: 
inout: 
	call init;
	call inputSignal;
	call outputSignal;
 
    	mov dl,0ffh                ;判断是否有按键
      mov ah,06h
      int 21h
      jz inout                ;若无,则继续自C口输入,A口输出
      mov ah,4ch              ;否则返回
      int 21h


init proc near
	mov dx,io8255b           ;设8255为C口输入,A口输出
      mov al,8bh
      out dx,al
	ret;
init endp;

inputSignal proc near
	mov dx,io8255c             ;从C口输入一数据
      in al,dx
	ret;
inputSignal endp;

outputSignal proc near
 	mov dx,io8255a  ;从A口输出刚才自C口
      out dx,al ;所输入的数据
	ret;
outputSignal endp;

code   ends
      end start
