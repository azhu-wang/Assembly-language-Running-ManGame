setMode macro mode
	mov ah,0
	mov al,mode
	int 10h
endm

setBackgroundColor macro color
	mov ah,0Bh
	mov bh,0
	mov bl,color
	int 10h
endm
WrPixel	macro col,row,color
	mov	ah,0ch
	mov	bh,00h
	mov al,color
	mov cx,col
	mov dx,row
	int 10h
endm
writePixel macro row,column,color
	push cx	;int 10h may change cx,we push cx first
	
	mov ah,0Ch
	mov bh,0
	mov al,color
	mov cx,column
	mov dx,row
	int 10h
	
	pop cx	;pop cx
endm
writeline macro row, column, color
	local W1, W2,Over22
	mov dx, row
	mov cx, column
W1:
	cmp cx, 640
	jz W2
	writePixel dx, cx, color
	inc cx
	jmp W1
W2:
	inc dx
	mov cx, column
	cmp dx, 326
	jz Over11
	jmp W1
Over11:
endm
getChar macro
	mov ah,06h
	mov dl,0ffh
	int 21h
endm
getChar2 macro
	mov ah, 07h
	int 21h
endm
writeplayer macro row, column, color, player
	local P1,P11,P2,DD,Over22
	mov dx, row
	mov cx, column
	mov bx, 0
P1:
	cmp cx, 100
	jz P2
	push bx
	getColor dx, cx
	pop bx
	cmp al, 00h
	jne DD
P11:
	writePixel dx, cx, color
	inc cx
	jmp P1
P2:
	inc bx
	mov cx, column
	mov dx, row
	add dx, bx
	cmp bx, 50
	jz Over22
	jmp P1
DD:
	mov ax, 3
	mov player, 3
	jmp P11
Over2:
endm
enemywrite macro row, column, color, enemy
	local E1,E2,E3,Over44
	mov ax, enemy
	cmp ax, 0
	jz Over44
E1:
	mov dx, row
	mov cx, column
	mov bx, 0
E2:
	cmp ax, 50
	jz E3
	push ax
	writePixel dx, cx, color
	pop ax
	inc cx
	inc ax
	jmp E2
E3:
	inc bx
	mov cx, column
	mov dx, row
	add dx, bx
	cmp bx, 50
	jz Over44
	mov ax, 0
	jmp E2
Over44:	
endm
getColor macro row, column
	mov ah, 0dh
	mov bh, 0
	mov dx, row
	mov cx, column
	int 10h
endm
getclock macro
	mov ah,2CH
	int 21h
endm
playermov macro player, row, speed        ;角色移動
	local  jump,up,u1,u2
	local  down,down1,down2,Over33
	mov bx, player                        ;確認角色狀態
	cmp bx, 2
	jz down
	cmp bx, 1
	jz up
	cmp al,20h                            ;確認是否按下space
	jz jump
	jmp Over33
jump:
	getColor 319, 50                      ;確保角色在平面上
	cmp al, 00h
	jz Over33
	mov bx, player                        ;改變角色狀態為上升
	mov bx, 1
	mov player, bx
	getclock                              ;取得時間
	push dx
	jmp Over33
up:
	getColor 130, 55                      ;確定角色是否到達最高點
	cmp al, 1010b
	jz u1
	getclock                              ;取得時間
	pop bx
	push dx
	sub dx, bx
	cmp bx, 2
	jae u2
u1:                                       ;改變角色狀態為下降
	mov bx, player
	mov bx, 2
	mov player, bx
	jmp Over33
u2:                                       ;角色往上移動
	mov dx, row
	sub dx, speed
	mov row, dx
	jmp Over33
down:                                     
	getColor 319, 55                      ;確認角色是否到達平面
	cmp al, 1010b
	jz down1
	getclock                              ;取得時間
	pop bx
	push dx
	sub dx, bx
	cmp bx, 2
	jae down2
down1:                                    ;改變角色狀態為在平面
	mov bx, player
	mov bx, 0
	mov player, bx
	jmp Over33
down2:                                    ;角色往下移動
	mov dx, row
	add dx, speed
	cmp dx, 280
	jae down3
	mov row, dx
	jmp Over33
down3:                                    ;確保角色停在平面上
	mov dx, 280
	mov row, dx
Over33:
endm
checkenemy macro enemy1, enemy2, random, enemyclock1, enemyclock2, column1, column2,score  ;變更角色狀態
	mov dx, enemy1
	mov cx, enemy2
	mov bl, random
	mov bh, 0
	cmp dx, 0
	jne quit1
Ch1:                        ;亂數為0、7到9不生成怪
	cmp bx, 0
	je quit2
	cmp bx, 7
	jae quit2
EN1:                        ;將亂數為1到3變成怪1狀態
	cmp bx, 4               
	jae EN2
	cmp dx, 0
	jne quit2
	mov ax, 590
	mov column1, ax
	mov dx, bx
	mov enemy1, dx
	getclock
	mov enemyclock1, dx
	mov ax, score
	inc ax
	mov score, ax
	jmp quit2
EN2:                         ;將亂數為4到6變成怪2狀態
	cmp cx, 0
	jne quit2
	mov ax, 590
	mov column2, ax
	mov cx, bx
	mov enemy2, cx
	getclock
	mov enemyclock2, dx
	mov ax, score
	inc ax
	mov score, ax
	jmp quit2
quit1:
	cmp cx, 0
	je Ch1
quit2:
endm
SET_CUR macro row, col
	mov dh, row
	mov dl, col
	mov bx, 0000h
	mov ah, 02h
	int 10h
endm
Printstr macro string
	mov ah, 09h
	mov dx, offset string
	int 21h
endm
enemymov macro enemy,enemyclock,row, column, color, speed  ;移動怪座標
	local EM1,END1,Left,LE1,LE2,RE1,Over55
	mov bx, enemy
	cmp bx, 0
	je Over55
	cmp bx, 3
	jbe EM1
	sub bx, 3
EM1:                             ;設定座標
	mov ax, 60
	mul bx
	mov dx, 330
	sub dx, ax
	mov row, dx
	jmp END1
END1:
	getColor dx, 5               ;確認是否到達最左
	cmp al, color
	je RE1
	jmp Left
Left:                            
	getclock
	mov bx, enemyclock
	sub dx, bx
	cmp bx, 2
	jae LE1
LE1:                             ;往左移動
	mov enemyclock, dx
	mov cx, column
	cmp cx, speed
	jb LE2
	sub cx, speed
	mov column, cx
	jmp Over55
LE2:                             ;到最左邊
	mov cx, 0
	mov column, cx
	jmp Over55
RE1:                             ;將到最左邊的怪清掉
	mov bx, 0
	mov enemy, bx
	mov enemyclock, bx
	mov row, bx
	mov column, bx
Over55:
endm
