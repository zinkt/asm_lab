assume cs:code

a segment
	db 1,2,3,4,5,6,7,8
a ends

b segment
	db 1,2,3,4,5,6,7,8
b ends

c segment
	db 0,0,0,0,0,0,0,0
c ends

code segment
start:
	mov ax,c
	mov ds,ax

	mov ax,a
	mov es,ax

	mov bx,0
	mov cx,8
	s:
		mov ax,0
		add al,es:[bx]
		add al,es:[bx+16]
		mov [bx],ax
		inc bx
		loop s
	
	mov ah,4ch
	int 21h

code ends

end start