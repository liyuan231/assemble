 ;*******************************;
;* 8255��ʽ0��C������,A�����  *;
;*******************************;
io8255a        equ 288h
io8255b        equ 28bh
io8255c        equ 28ah
code   segment
      assume cs:code
start:  mov dx,io8255b           ;��8255ΪC������,A�����
      mov al,8bh
      out dx,al
inout:  mov dx,io8255c             ;��C������һ����
      in al,dx
      mov dx,io8255a             ;��A������ղ���C��
      out dx,al               ;�����������


      ;mov dl,0ffh                ;�ж��Ƿ��а���
      mov ah,01h
      int 21h
      jnz inout                ;����,�������C������,A�����
      mov ah,4ch              ;���򷵻�
      int 21h
code   ends
      end start