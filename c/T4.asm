assume cs:codesg

codesg segment
	
	mov ax,20h
	mov ds,ax
	sub bx,bx
	mov cx,64

s:	mov [bx],bl
	inc bx
	loop s
	
	mov ax,4c00h
	int 21h
	
codesg ends

end
