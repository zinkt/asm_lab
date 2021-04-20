assume cs:code,ds:data, es:data ;为啥需要关联es才能用变量名

data segment
	x dw 0f006h
	y dw 0f005h
	m dw 0008h
	n dw 0001h
	d dw 000ah
	g dw 0000h
	r dw 0000h

data ends


code segment
start:
	mov ax,data
	mov ds,ax

	mov cx,0	;高八位置0
	mov bx,x
	add bx,y	;低八位存加法和
	adc cx,0	;加上可能的进位

	mov ax,m 	;乘法
	mul n		;此时ax存结果的低八位

	sub bx,ax
	sbb cx,dx	;带借位的减法

	mov ax,bx
	mov dx,cx	;为除法做准备
	
	mov bx,d
	add bx,6
	div bx

	mov g,ax	;存储值
	mov r,dx

	mov ax,4c00H
	int 21H

code ends

end start