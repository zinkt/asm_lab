assume cs:code,ds:data,ss:stack
data segment
	db	'I love asm!  test:  awudkkkkhkahkfhwkdkasnckajnwkdhahwdkadkawdkahwdkhakdhawkdhkauwdkawdh',0
data ends

stack segment
	db 160 dup (0)
stack ends

code segment
start:
	mov ax,stack
	mov ss,ax
	mov sp,160
	mov dh,8
	mov dl,3
	mov cl,2
	mov ax,data
	mov ds,ax
	mov si,0
	call show_str

	mov ax,4c00h
	int 21h
show_str:
	push dx
	push di
	push cx
	push bx
	push ax
	push es				;储存调用前的寄存器值
	
	mov ax,0B800h
	mov es,ax
	mov al,dh
	mov bl,160
	mul bl
	mov bx,ax
	mov dh,0
	add bx,dx
	add bx,dx
	mov di,0			;es:[bx+di+idata]
s:
	mov cx,[si]
	mov es:[bx+di],cx
	mov byte ptr es:[bx+di+1],02h
	jcxz finish	
	inc si
	add di,2
	jmp short s

finish:
	pop es
	pop ax
	pop bx
	pop cx
	pop di
	pop dx
	ret

code ends
end start