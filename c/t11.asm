assume cs:code,ds:data,ss:stack

data segment
	db "Beginner's All-purpose Symbolic Instruction Code.",0
data ends

stack segment
	db 160 dup(0)
stack ends

code segment
start:
	mov ax,data
	mov ds,ax
	mov si,0
	call letterc

	mov ax,4c00h
	int 21h

letterc:
	push ax
	push ds
	push si
letterc_sub:	
	mov al,[si]
	cmp	al,65
	jb notletter
	cmp al,122
	ja notletter

letter2upper:
	and al,11011111b
	mov [si],al

notletter:
	cmp al,0
	je finish
	inc si
	jmp short letterc_sub

finish:
	pop si
	pop ds
	pop ax
	ret

code ends
end start
