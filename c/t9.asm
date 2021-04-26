assume cs:code,ss:stack,ds:data

data segment
	db "-wjc @ cxy-"
data ends

stack segment
	db 16 dup (0)
stack ends

code segment
start:
	mov ax,stack
	mov ss,ax
	mov sp,16

	mov ax,data
	mov ds,ax

	mov ax,0B800h
	mov es,ax

	mov bx,460h
	mov si,0
	mov di,0
	mov cx,100
s0:
	mov si,0
	push cx
	mov cx,11
s:
	mov al,[si]
	mov ah,11001010b;01001010b
	mov es:[bx+di],ax		;set
	inc si
	add di,2
	loop s

	pop cx
	loop s0	

	mov ax,4c00h
	int 21h
code ends
end start