assume cs:code

a segment
	dw 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0ffh
a ends

b segment
	dw 0,0,0,0,0,0,0,0
b ends

code segment

	dw 0,0,0,0,0,0,0,0
start:
	mov ax,a
	mov ds,ax

	mov ax,code
	mov ss,ax
	mov sp,10h

	mov bx,0
	mov cx,8
	s:
		push [bx]
		inc bx
		loop s
	
	mov cx,8
	mov bx,02h
	s0:
		pop [bx]
		inc bx
		loop s0

	mov ah,4ch
	int 21h


code ends

end start