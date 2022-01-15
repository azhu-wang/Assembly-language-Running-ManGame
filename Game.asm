include game_function.h
.8086
.model small
.stack 512
.data
	stringS0 db "Welcome to Running Man $"
	stringS1 db "[A]Press A to start the game $"
	stringS2 db "[B]Press B to escape the game$"
	changeLine db 10,13,'$'
	spaceLine db "                     $"
	
	x dw 50
	y dw 280
	valuex dw 50
	valuey dw 280
	colorMain db 1001b
	
	xRock dw 0
	yRock dw 0
	valuexRock dw 0
	valueyRock dw 0
	colorRock db 01h
	
	xRock2 dw 0
	yRock2 dw 0
	valuexRock2 dw 0
	valueyRock2 dw 0
	colorRock2 db 1001b
	
	player dw 0                  ;player狀態
	enemy1 dw 0                  ;怪1狀態
	enemy2 dw 0                  ;怪2狀態
	enemyclock1 dw 0             ;怪1時間
	enemyclock2 dw 0             ;怪2時間
	color1 db 01h                ;怪1顏色
	color2 db 1001b              ;怪2顏色
	PRN dw ?                     
	random db 0                  ;亂數
	score dw 0                   ;分數
	score_num db "score=", 3 dup(' '), '$'  ;顯示分數
	speed dw 20                  ;角色移動速度
	speed1 dw 23                 ;怪1移動速度
	speed2 dw 30                 ;怪2移動速度
	str1 db "Press ENTER to return or other key to left", '$'  ;結尾
.code
.startup
Start:
	setMode 12h
	setBackgroundColor 00h   ;start
		PrintStr changeLine
		PrintStr changeLine
		PrintStr changeLine
		PrintStr changeLine
		PrintStr changeLine
		PrintStr changeLine
		PrintStr spaceLine
		PrintStr stringS0
		PrintStr changeLine
		PrintStr changeLine
		PrintStr changeLine
		PrintStr spaceLine
		PrintStr stringS1
		PrintStr changeLine
		PrintStr changeLine
		PrintStr changeLine
		PrintStr spaceLine
		PrintStr stringS2
		PrintStr changeLine
		getChar2
		cmp al,61h
		je start2	
		cmp al,62h
		je escape
		jmp Start
	start2:
;start ch	
L1:
	setMode 12h                   ;進入繪圖模式
	setBackgroundColor 00h        ;背景
	writeline 320, 0, 04h         ;畫底線
	mov ax, score                 ;將分數顯示
	mov di, offset score_num
	call tran
	SET_CUR 0,144
	PrintStr score_num
	;;;;
	;;;;rock 400~493
	mov ax, enemy1                ;確認怪1狀態
	cmp ax, 0
	je OverR3
	mov cx,0
	mov dx,0
LR1:
	cmp cx,10
	je OverR1
	push cx
	add valuexRock,cx
	LR11:
		cmp dx,10
		je LR111
		push dx
		add valueyRock,dx
		WrPixel valuexRock,valueyRock,colorRock
		mov dx,yRock
		mov valueyRock,dx
		pop dx
		inc dx
		jmp LR11
	LR111:	
		mov dx,0
		mov cx,xRock
		mov valuexRock,cx
		pop cx
		inc cx
		jmp LR1
OverR1:
mov cx,xRock															
sub cx,2
mov valuexRock,cx
mov xRock,cx
mov cx,yRock
add cx,2
mov valueyRock,cx
mov yRock,cx
mov cx,0
mov dx,0
LR2:
	cmp cx,14
	je OverR2
	push cx
	add valuexRock,cx
	LR22:
		cmp dx,6
		je LR222
		push dx
		add valueyRock,dx
		WrPixel valuexRock,valueyRock,colorRock
		mov dx,yRock
		mov valueyRock,dx
		pop dx
		inc dx
		jmp LR22
	LR222:	
		mov dx,0
		mov cx,xRock
		mov valuexRock,cx
		pop cx
		inc cx
		jmp LR2	
OverR2: 
mov cx,xRock															
add cx,4
mov valuexRock,cx
mov xRock,cx
mov cx,yRock
sub cx,4
mov valueyRock,cx
mov yRock,cx
mov cx,0
mov dx,0
LR3:
	cmp cx,6
	je OverR3
	push cx
	add valuexRock,cx
	LR33:
		cmp dx,14
		je LR333
		push dx
		add valueyRock,dx
		WrPixel valuexRock,valueyRock,colorRock
		mov dx,yRock
		mov valueyRock,dx
		pop dx
		inc dx
		jmp LR33
	LR333:	
		mov dx,0
		mov cx,xRock
		mov valuexRock,cx
		pop cx
		inc cx
		jmp LR3
OverR3: 
	
	;;;;Rock2
	;;;;rock 501~596
	mov ax, enemy2                   ;確認怪2狀態
	cmp ax, 0
	jz OverRx3
	
	mov cx,0
	mov dx,0
	mov colorRock2,1001b
LRx1:
	cmp cx,50
	je OverRx1
	push cx
	add valuexRock2,cx
	LRx11:
		cmp dx,3
		je LRx111
		push dx
		add valueyRock2,dx
		WrPixel valuexRock2,valueyRock2,colorRock2
		mov dx,yRock2
		mov valueyRock2,dx
		pop dx
		inc dx
		jmp LRx11
	LRx111:	
		mov dx,0
		mov cx,xRock2
		mov valuexRock2,cx
		pop cx
		inc cx
		jmp LRx1
OverRx1:
mov cx,xRock2															
sub cx,1
mov valuexRock2,cx
mov xRock2,cx
mov cx,yRock2
add cx,1
mov valueyRock2,cx
mov yRock2,cx
mov cx,0
mov dx,0
LRx2:
	cmp cx,52
	je OverRx2
	push cx
	add valuexRock2,cx
	LRx22:
		cmp dx,1
		je LRx222
		push dx
		add valueyRock2,dx
		WrPixel valuexRock2,valueyRock2,colorRock2
		mov dx,yRock2
		mov valueyRock2,dx
		pop dx
		inc dx
		jmp LRx22
	LRx222:	
		mov dx,0
		mov cx,xRock2
		mov valuexRock2,cx
		pop cx
		inc cx
		jmp LRx2	
OverRx2: 
mov cx,xRock2															
add cx,2
mov valuexRock2,cx
mov xRock2,cx
mov cx,yRock2
sub cx,2
mov valueyRock2,cx
mov yRock2,cx
mov cx,0
mov dx,0
LRx3:
	cmp cx,48
	je OverRx3
	push cx
	add valuexRock2,cx
	LRx33:
		cmp dx,5
		je LRx333
		push dx
		add valueyRock2,dx
		WrPixel valuexRock2,valueyRock2,colorRock2
		mov dx,yRock2
		mov valueyRock2,dx
		pop dx
		inc dx
		jmp LRx33
	LRx333:	
		mov dx,0
		mov cx,xRock2
		mov valuexRock2,cx
		pop cx
		inc cx
		jmp LRx3
OverRx3: 
	;;;;writeplayer
	mov cx ,x
	push cx
	mov cx, y
	push cx
	mov cx,0
	mov dx,0
	mov colorMain,1010b
Lx1:
	cmp cx,30
	je Over1
	push cx
	add valuex,cx
	Lx11:
		cmp dx,30
		je Lx111
		push dx
		add valuey,dx
		push bx
		getColor valuey, valuex                  ;確認是否有撞到
		pop bx
		cmp al, 01h
		je DX1
		cmp al, 1001b
		je DX1
	LW11:	WrPixel valuex,valuey,colorMain
		mov dx,y
		mov valuey,dx
		pop dx
		inc dx
		jmp Lx11
	Lx111:	
		mov dx,0
		mov cx,x
		mov valuex,cx
		pop cx
		inc cx
		jmp Lx1
	DX1:                                    ;撞到則改變player狀態
		mov ax, 3
		mov player, 3
		jmp LW11
Over1:
mov cx,x											;left
add cx,6
mov valuex,cx
mov x,cx
mov cx,y
add cx,30
mov valuey,cx
mov y,cx
mov cx,0
mov dx,0
Lx2:
	cmp cx,6
	je Over2
	push cx
	add valuex,cx
	Lx22:
		cmp dx,5
		je Lx222
		push dx
		add valuey,dx
		WrPixel valuex,valuey,colorMain
		mov dx,y
		mov valuey,dx
		pop dx
		inc dx
		jmp Lx22
	Lx222:	
		mov dx,0
		mov cx,x
		mov valuex,cx
		pop cx
		inc cx
		jmp Lx2	
Over2: 
mov cx,x												;right
add cx,12
mov valuex,cx
mov x,cx
mov cx,y
mov valuey,cx
mov y,cx
mov cx,0
mov dx,0
Lx3:
	cmp cx,6
	je Over3
	push cx
	add valuex,cx
	Lx33:
		cmp dx,5
		je Lx333
		push dx
		add valuey,dx
		WrPixel valuex,valuey,colorMain
		mov dx,y
		mov valuey,dx
		pop dx
		inc dx
		jmp Lx33
	Lx333:	
		mov dx,0
		mov cx,x
		mov valuex,cx
		pop cx
		inc cx
		jmp Lx3
Over3: 
mov cx,x											;right foot
mov valuex,cx
mov x,cx
mov cx,y
add cx,5
mov valuey,cx
mov y,cx
mov cx,0
mov dx,0
Lx4:
	cmp cx,12
	je Over4
	push cx
	add valuex,cx
	Lx44:
		cmp dx,5
		je Lx444
		push dx
		add valuey,dx
		WrPixel valuex,valuey,colorMain
		mov dx,y
		mov valuey,dx
		pop dx
		inc dx
		jmp Lx44
	Lx444:	
		mov dx,0
		mov cx,x
		mov valuex,cx
		pop cx
		inc cx
		jmp Lx4
Over4:
mov cx,x											;left foot
sub cx,18
mov valuex,cx
mov x,cx
mov cx,y
mov valuey,cx
mov y,cx
mov cx,0
mov dx,0
Lx5:
	cmp cx,12
	je Over5
	push cx
	add valuex,cx
	Lx55:
		cmp dx,5
		je Lx555
		push dx
		add valuey,dx
		WrPixel valuex,valuey,colorMain
		mov dx,y
		mov valuey,dx
		pop dx
		inc dx
		jmp Lx55
	Lx555:	
		mov dx,0
		mov cx,x
		mov valuex,cx
		pop cx
		inc cx
		jmp Lx5
Over5: 
;eyes
mov cx,x										;left eyes
add cx,6
mov valuex,cx
mov x,cx
mov cx,y
sub cx,23
mov valuey,cx
mov y,cx
mov cx,0
mov dx,0
mov colorMain,0b
Lx6:
	cmp cx,6
	je Over6
	push cx
	add valuex,cx
	Lx66:
		cmp dx,6
		je Lx666
		push dx
		add valuey,dx
		WrPixel valuex,valuey,colorMain
		mov dx,y
		mov valuey,dx
		pop dx
		inc dx
		jmp Lx66
	Lx666:	
		mov dx,0
		mov cx,x
		mov valuex,cx
		pop cx
		inc cx
		jmp Lx6
Over6: 
mov cx,x										;right eyes
add cx,12
mov valuex,cx
mov x,cx
mov cx,y
mov valuey,cx
mov y,cx
mov cx,0
mov dx,0
mov colorMain,0b
Lx7:
	cmp cx,6
	je Over7
	push cx
	add valuex,cx
	Lx77:
		cmp dx,6
		je Lx777
		push dx
		add valuey,dx
		WrPixel valuex,valuey,colorMain
		mov dx,y
		mov valuey,dx
		pop dx
		inc dx
		jmp Lx77
	Lx777:	
		mov dx,0
		mov cx,x
		mov valuex,cx
		pop cx
		inc cx
		jmp Lx7
Over7: 												;hat
mov cx,x															
sub cx,18
mov valuex,cx
mov x,cx
mov cx,y
sub cx,14
mov valuey,cx
mov y,cx
mov cx,30
mov dx,0
mov colorMain,1100b
Lx8:
	push cx
	inc valuex
	WrPixel valuex,valuey,colorMain
	pop cx
	loop Lx8
mov cx,x															
add cx,3
mov valuex,cx
mov x,cx
mov cx,y
sub cx,2
mov valuey,cx
mov y,cx
mov cx,24
Lx88:
	push cx
	inc valuex
	WrPixel valuex,valuey,colorMain
	pop cx
	loop Lx88
mov cx,x															
add cx,3
mov valuex,cx
mov x,cx
mov cx,y
sub cx,2
mov valuey,cx
mov y,cx
mov cx,18
Lx888:
	push cx
	inc valuex
	WrPixel valuex,valuey,colorMain
	pop cx
	loop Lx888
mov cx,x															
add cx,3
mov valuex,cx
mov x,cx
mov cx,y
sub cx,2
mov valuey,cx
mov y,cx
mov cx,12
Lx8888:
	push cx
	inc valuex
	push bx
	getColor valuey, valuex                      ;確認是否有撞到
	pop bx
	cmp al, 01h
	je DX2
	cmp al, 1001b
	je DX2
LW22: WrPixel valuex,valuey,colorMain
	pop cx
	loop Lx8888
	jmp Lx88881
DX2:                                            ;撞到則改變player狀態
	mov ax, 3
	mov player, ax
	jmp LW22
Lx88881:	
mov cx,x															
add cx,3
mov valuex,cx
mov x,cx
mov cx,y
sub cx,2
mov valuey,cx
mov y,cx
mov cx,6
Lx88888:
	push cx
	inc valuex
	WrPixel valuex,valuey,colorMain
	pop cx
	loop Lx88888
Over8: 
mov cx,x												;hat2
add cx,3
mov valuex,cx
mov x,cx
mov cx,y
sub cx,3
mov valuey,cx
mov y,cx
mov cx,0
mov dx,0
mov colorMain,1111b
Lx9:
	cmp cx,2
	je Over9
	push cx
	add valuex,cx
	Lx99:
		cmp dx,2
		je Lx999
		push dx
		add valuey,dx
		WrPixel valuex,valuey,colorMain
		mov dx,y
		mov valuey,dx
		pop dx
		inc dx
		jmp Lx99
	Lx999:	
		mov dx,0
		mov cx,x
		mov valuex,cx
		pop cx
		inc cx
		jmp Lx9
Over9:
mov cx,x											;right eyes
sub cx,19
mov valuex,cx
mov x,cx
mov cx,y
add cx,34
mov valuey,cx
mov y,cx
mov cx,0
mov dx,0
mov colorMain,1010b
Lxa:
	cmp cx,38
	je Overa
	push cx
	add valuex,cx
	Lxaa:
		cmp dx,4
		je Lxaaa
		push dx
		add valuey,dx
		WrPixel valuex,valuey,colorMain
		mov dx,y
		mov valuey,dx
		pop dx
		inc dx
		jmp Lxaa
	Lxaaa:	
		mov dx,0
		mov cx,x
		mov valuex,cx
		pop cx
		inc cx
		jmp Lxa
Overa: 
	pop cx
	mov y, cx
	pop cx
	mov x, cx
	;;
	mov dx, speed1              ;設定最高速
	cmp dx, 42
	jae CHANGE
	mov dx, score               ;設定加速分數
	cmp dx, 20
	je INCS
	cmp dx, 40
	je INCS
	cmp dx, 60
	je INCS
CHANGE:
	cmp player, 3               ;確認player是否死亡
	je Dead
	call Delay
	call Delay
	getChar                     ;取得鍵盤值
	cmp al,1Bh	                ;escape   
	jz escape
	playermov player, y, speed  ;player移動
	call RANDGEN                ;亂數
	mov random, dl
	checkenemy enemy1, enemy2, random, enemyclock1, enemyclock2, xRock, xRock2,score   ;確定怪狀態
	enemymov enemy1,enemyclock1,yRock, xRock,color1,speed1       ;怪1生成及移動
	enemymov enemy2,enemyclock2,yRock2, xRock2,color2,speed2     ;怪2生成及移動
	jmp L1
INCS:                 ;速度增加
	mov dx, speed1
	mov cx, speed2
	add dx, 2
	add cx, 1
	mov speed1, cx
	mov speed2, dx
	jmp CHANGE
Dead:                 
	SET_CUR 4, 18    
	PrintStr str1
	getChar2         ;取得鍵盤值
	cmp al, 0Dh      ;enter重新開始遊戲其他跳出
	je Return
	jne escape
Return:
	call Retset      ;恢復初值
	jmp L1
escape:
	setMode 03h      ;跳出繪圖模式
.exit
tran proc near
	mov cx, 0
Hex2Dec:
	inc cx
	mov bx, 10
	mov dx, 0
	div bx
	push dx
	cmp ax, 0
	jne Hex2Dec
Dec2Ascii:
	pop ax
	add al, 30h
	mov [di+6], al
	inc di
	loop Dec2Ascii
	ret
tran endp
	
Delay proc
	mov  cx,400
D1:
	push cx
	mov cx,65535
D2:
	loop D2
	pop cx
	loop D1
	ret
Delay endp

Retset proc
	mov dx, 280
	mov y, dx
	mov dx, 50
	mov x, dx
	mov dx, 40
	mov dx, 0
	mov yRock, dx
	mov xRock, dx
	mov yRock2, dx
	mov xRock2, dx
	mov player, dx
	mov enemy1, dx
	mov enemy2, dx
	mov enemyclock1, dx
	mov enemyclock2, dx
	mov score, dx
	mov score_num[6], dl
	mov score_num[7], dl
	mov score_num[8], dl
	mov dx, 23
	mov speed1, dx
	mov dx, 35
	mov speed2, dx
	mov dx, 20
	mov speed, dx
	ret
Retset endp

RANDGEN proc
	MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
	INT     1AH
	mov     [PRN], dx
	call    CalcNew   ; -> AX is a random number
	xor     dx, dx
	mov     cx, 10    
	div     cx        ; here dx contains the remainder - from 0 to 9
	ret
RANDGEN endp
; ----------------
; inputs: none  (modifies PRN seed variable)
; clobbers: DX.  returns: AX = next random number
CalcNew proc
    mov     ax, 25173          ; LCG Multiplier
    mul     word ptr [PRN]     ; DX:AX = LCG multiplier * seed
    add     ax, 13849          ; Add LCG increment value
    ; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
    mov     [PRN], ax          ; Update seed = return value
    ret
CalcNew endp
end
