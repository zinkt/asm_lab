assume cs:code,ds:data

data segment
	year	db 2 dup(0)
			db '/'
	mon		db 2 dup(0)
			db '/'
	day		db 2 dup(0)
			db '-'
	hour	dw 0
			db ':'
	min		dw 0
			db ':'
	sec		dw 0
			db '$'
data ends

stacksg segment stack
	db 16 dup(0)
stacksg ends

code segment
split_al_bcd2ascii:		;ah=十位，al为个位
	push cx
	mov ah,al
	mov cl,4
	shr ah,cl
	and al,00001111b
	add al,30h
	add ah,30h
	pop cx
	ret
start:
	mov ax,data
	mov ds,ax
	mov ax,stacksg
	mov ss,ax
	mov sp,16

	mov al,9					;year
	out 70h,al
	in al,71h
	call split_al_bcd2ascii	
	mov ds:[0],ah
	mov ds:[1],al

	mov al,8					;month
	out 70h,al
	in al,71h
	call split_al_bcd2ascii	
	mov ds:[3],ah
	mov ds:[4],al

	mov al,7					;day
	out 70h,al
	in al,71h
	call split_al_bcd2ascii	
	mov ds:[6],ah
	mov ds:[7],al

	mov al,4					;hour
	out 70h,al
	in al,71h
	call split_al_bcd2ascii	
	mov ds:[9],ah
	mov ds:[10],al

	mov al,2					;minute
	out 70h,al
	in al,71h
	call split_al_bcd2ascii	
	mov ds:[12],ah
	mov ds:[13],al

	mov al,0					;second
	out 70h,al
	in al,71h
	call split_al_bcd2ascii	
	mov ds:[15],ah
	mov ds:[16],al

	mov dx,0			;显示数据段字符串
	mov ah,9
	int 21h

	mov ah,4ch
	int 21h

code ends
end start