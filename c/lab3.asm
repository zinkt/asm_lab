assume cs:code,ds:data

data segment
	db 30			;最大字符存放数
	db ?			;实际输入数
	db 30 dup(0)	;存放
	dw 4 dup(0)		;大写，小写，数字，其他(word) 计数区域

upperCase	db "   Upper: $"			;大写
lowerCase	db "   Lower: $"			;小写
numberCase	db "   Numbers: $"			;数字
otherCase	db "   Others: $"			;其他
crlf db 0Ah,0Dh,'$'						;回车换行
str db "Please enter a string to be counted: ","$"
data ends

stacksg segment stack
	db 64 dup(0)
stacksg ends

code segment

show_num_ax:			;显示数字通用函数
	jmp short s
	db 6 dup('$')		;预留给输出字符的内存，16位二进制数最多为5位十进制
						;因pop对字操作，因此再预留一位,并最后作为$结束符
	s:
	push ax 			;保护寄存器
	push bx
	push cx
	push dx
	push si
	push ds
	push di
	mov si,0
	mov bx,10			;设置输出进制
	s0:
	mov dx,0
	div bx
	add dx,30h
	push dx
	mov cx,ax
	inc si

	jcxz s1				;判断是否商为0，即进制转换完成
	jmp short s0		;转换未完成则跳转到s0继续
	s1:
	mov ax,code
	mov ds,ax
	mov cx,si
	mov di,2
	lop:
	pop [di]			;pop到预留内存中
	inc di 				;正好低位是有效ASCII码，高位无效，所以每次di只加1
	loop lop
	mov byte ptr [di],'$'		;结尾$符

	mov dx,2			;jmp指令占2字节
	mov ah,9
	int 21h						;显示数字

	pop di
	pop ds
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret					;函数返回

start:
	mov ax,data
	mov ds,ax
	mov ax,stacksg
	mov ss,ax
	mov sp,64
	lea dx,str 			;显示提示字符串
	mov ah,9
	int 21h				

	mov dx,0
	mov ah,0Ah
	int 21h				;等待输入

	;mov cl,ds:[1]		;可用此字节获取输入字符数，从而统计无$符结尾的字符串，只需修改循环条件（方法二）
	;mov ch,0
	mov si,2			;从[2]处开始为读入的字符串
count:
	mov al,[si]

	cmp al,48
	jb other			;比0小
	cmp al,58			
	jb num				;比:小
	cmp al,65
	jb other			;比A小
	cmp al,91
	jb upper			;比[小
	cmp al,97
	jb	other			;比a小
	cmp al,123
	jb lower			;比{小

	jmp other			;剩余其他

upper:
	inc byte ptr ds:[32]	;计数
	jmp short count_end
lower:
	inc byte ptr ds:[34]
	jmp short count_end	
num:
	inc byte ptr ds:[36]
	jmp short count_end	

other:
	inc byte ptr ds:[38]
	jmp short count_end

count_end:
	inc si
	cmp al,'$'				;（方法一）
	jne count 				;用$作为指示符结束循环（方法一）
	dec byte ptr ds:[38]	;对$多计了一次
	;loop count 			;用cx循环计数（方法二）

	lea dx,crlf 			;回车换行
	mov ah,9
	int 21h

	lea dx,upperCase 		;显示计数结果
	mov ah,9
	int 21h
	mov ax,ds:[32]
	call show_num_ax

	lea dx,lowerCase
	mov ah,9
	int 21h
	mov ax,ds:[34]
	call show_num_ax

	lea dx,numberCase
	mov ah,9
	int 21h
	mov ax,ds:[36]
	call show_num_ax

	lea dx,otherCase
	mov ah,9
	int 21h
	mov ax,ds:[38]
	call show_num_ax


	mov ah,4ch
	int 21h

code ends
end start