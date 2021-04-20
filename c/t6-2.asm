assume cs:code,ss:stack,ds:data

stack segment
	dw 8 dup (0)
stack ends

data segment
	db '1. display      '
	db '2. brows        '
	db '3. replace      '
	db '4. modify       '
data ends

code segment
start:
	mov ax,stack
	mov ss,ax
	mov sp,16
	mov ax,data
	mov ds,ax
	mov bx,0

	mov cx,4			;set extenal loop

	s:
		push cx
		mov si,0
		mov cx,



code ends
end start