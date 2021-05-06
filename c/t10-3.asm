assume cs:code,ss:stack

stack segment
	db 32 dup(0)
stack ends

code segment

show_num_ax:
	jmp short s
	db 6 dup('$'),'$'			;16位二进制数最多为5位十进制，因pop对字操作，因此再预留一位给0
s:
	push ax 					;保护寄存器
	push bx
	push cx
	push dx
	push si
	push ds
	push di
	mov si,0
	mov bx,10					;设置进制
s0:
	mov dx,0
	div bx
	add dx,30h
	push dx
	mov cx,ax
	inc si

	jcxz s1						;判断是否商为0，即进制转换完成
	jmp short s0
s1:
	mov ax,code
	mov ds,ax
	mov cx,si
	mov di,2
lop:
	pop [di]					;pop到预留内存中
	inc di
	loop lop

	mov dx,2
	mov ah,9
	int 21h						;显示数字

	pop di
	pop ds
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret

start:
	mov ax,stack
	mov ss,ax
	mov sp,32

	mov ax,1234
	call show_num_ax

	mov ah,4ch
	int 21h

code ends
end start