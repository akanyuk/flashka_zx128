; Based on `Voice metter` by Himik's ZxZ

SCR_A1	equ #4f60
SCR_A2	equ #4880

ADR_TAB2	equ consts.AnalyzeBuffers1        ; #00b0 (alligned)
TO_VIW_PROC	equ consts.AnalyzeBuffers1 + #e0  ; #0103
TO_VIW_ADDR	equ consts.AnalyzeBuffers1 + #200 ; #0020 (alligned)
ADR_TAB	equ consts.AnalyzeBuffers1 + #220 ; #5280


Main	call TEST
	jr 1f
	; скорость в два раза меньше
MainSlow	call TEST
//slowler	ld a, #01 : inc a : and #01 : ld (slowler + 1), a : or a : ret nz
1	ld hl, SCR_A1 - #0100
	ld de, SCR_A1
	ld  b, 15
1	push bc, hl, hl
	dup 11 : ldi : edup
	pop de : pop hl : call lib.UpHL
	pop bc
	djnz 1b

	ld hl, SCR_A2 + #0200
	ld de, SCR_A2 + #0100
	ld  b, 14
1	push bc, hl, hl
	dup 11 : ldi : edup
	pop de : pop hl : call lib.DownHL
	pop bc
	djnz 1b

	ld hl, SCR_A1 - #0100 + 21
	ld de, SCR_A1 + 21
	ld  b, 15
1	push bc, hl, hl
	dup 11 : ldi : edup
	pop de : pop hl : call lib.UpHL
	pop bc
	djnz 1b

	ld hl, SCR_A2 + #0200 + 21
	ld de, SCR_A2 + #0100 + 21
	ld  b, 14
1	push bc, hl, hl
	dup 11 : ldi : edup
	pop de : pop hl : call lib.DownHL
	pop bc
	djnz 1b

	ret

;Чтение портов AY,просчёт и вывод частоты.
;-----------------------------------------
 
TEST    	LD      L,1
BCK_A   	LD      H,#50
	LD      DE,(A_FRQ)
	CALL    IN_C
	LD      (BCK_A+1),A     ; запомнили столбик частоты
	LD      (A_FRQ),DE      ; запомнили частоту канала
	LD      E,8
	CALL    WWW
CHN_B
        	LD      L,3
BCK_B   	LD      H,#50
	LD      DE,(B_FRQ)
	CALL    IN_C
	LD      (BCK_B+1),A
	LD      (B_FRQ),DE
	LD      E,9
	CALL    WWW
CHN_C
        	LD      L,5
BCK_C   	LD      H,#50
	LD      DE,(C_FRQ)
	CALL    IN_C
	LD      (BCK_C+1),A
	LD      (C_FRQ),DE
	LD      E,10
	CALL    WWW

;Обработчик шума
;---------------
 
NS      	LD      A,#06
	LD      BC,#FFFD
	OUT     (C),A
	EX      AF,AF'
	IN      A,(C)
	CPL
	AND     #1F
	EX      AF,AF'
	LD      A,#07
	OUT     (C),A
	IN      A,(C)
	RRA
	RRA
	RRA
	RRA
 
;Узнаём, в каком канале разрешен шум
	LD      E,#08
	PUSH    AF
	CALL    NC, SH_NOISE
	POP     AF
	RRA
	LD      E,#09
	PUSH    AF
	CALL    NC, SH_NOISE
	POP     AF
	RRA
	LD      E,#0A
	RET  C
SH_NOISE
	OUT     (C),E
	IN      A,(C)
	jr      WWW3

WWW     	LD      BC, #FFFD
	OUT     (C), E
	IN      A, (C)
	BIT     4,A
        	jr      NZ, CHN_E         	; Проверка на огибающую
WWW3	and #0f
	or a : ret z
WWW2    	ex af, af' 			; Берём N столбика,
        	add a, a         		; умножили на 2
	cp 84 * 2 : jr c, $+4 : ld a, 84 * 2	; непонятное переполнение
	ld l, a
	ld h, ADR_TAB2/256 	; Получим адрес начала таблицы вывода столбика.
	ld a, (hl)     	
	inc hl       	
	ld h, (hl)
	ld l, a
	ex af, af'
	add a, a 			; Умнож. громкость на 2

ADR_WSP 	ld (#0000), sp
	ld sp, hl
	ld h, TO_VIW_ADDR/256 : ld l, a		; получаем адрес процедуры вывода столбика
	ld e, (hl) : inc l : ld d, (hl) : ex de, hl	
	jp (hl)

CHN_E   	LD      L,12
BCK_E   	LD      H,#50
	LD      DE,(E_FRQ)
	CALL    IN_C
	LD      (BCK_E+1),A
	LD      (E_FRQ),DE
	LD      A,#0F
	jr      WWW2
 
;Читаем из портов частоту тона и высчитываем номер столбика...
IN_C    	PUSH    DE
	LD      A,H
	LD      (PISK2+1),A
	LD      BC,#FFFD
	OUT     (C),L
	IN      A,(C)
	AND     #0F
	LD      D,A
	DEC     L
	OUT     (C),L
	IN      A,(C)
	LD      E,A
	INC     A
	JR      C,PISKA
	DEC     E

PISKA	pop hl    		; Сравнение текущей и предыдущей частоты.
	or a     
	sbc hl, de 		; Если равны,получаем
	jr nz, PISK1
	ex af, af'  		; Номер предыдущего столбика, не тратя время на просчёт частоты
PISK2 	ld a, #00           
	ld b, a       
	ex af,af'
	ld a, b
	ret
 
PISK1	push de
	call SELECT_TAB
	ex af,af'
	ld b, a
	ex af,af'
	ld a, b
	pop de
	ret

;Пересчет частоты тона в номер столбика.
SELECT_TAB
	ex af, af'
	xor a 
	ex af, af'

	ld a, d : or e : ret z

	ld a, d : add a, a : ld l, a : ld h, #00 : ld bc, FRQ_T : add hl, bc
	ld a, (hl) : inc hl : ld h, (hl) : ld l, a
	ld (PI + 1), sp
	ld sp, hl
ST_NEXT 	pop hl
        	; L - FRQ ; H - STOLB
	ld a, h
	or l
	ld a, e
	jr z, ST_PRED
	bit 7,H
	jp NZ, ST_OK
	cp l
	jr z, ST_OK
	jr c, ST_NEXT
ST_PRED	dec sp : dec sp : dec sp : dec sp : pop hl
ST_OK	ex af,af'
	ld a,h
	and #7f
	ex af, af'
 
PI 	ld sp, #0000
	ret

A_FRQ   	dw #5000
B_FRQ   	dw #5000
C_FRQ   	dw #5000
E_FRQ   	dw #5000	

	align #100
FRQ	; Адрес частотной таблицы
FRQ_F	db #00,#00+#80
FRQ_E   	db #DC,#00,#07,#01+#80
FRQ_D   	db #3E,#02+#80
FRQ_C   	db #80,#03+#80
FRQ_B   	db #CC,#04,#22,#05+#80
FRQ_A	db #82,#06+#80
FRQ_9	db #EC,#07,#5C,#08+#80
FRQ_8	db #D6,#09,#58,#0A+#80
FRQ_7	db #E0,#0B,#6E,#0C,#04,#0D+#80
FRQ_6   	db #9F,#0E,#40,#0F+#80
FRQ_5   	db #E6,#10,#91,#11,#41,#12+#80
FRQ_4   	db #F6,#13,#AE,#14,#6B,#15,#2C,#16+#80
FRQ_3   	db #F0,#17,#B7,#18,#82,#19,#4F,#1A,#20,#1B+#80
FRQ_2   	db #F3,#1C,#C8,#1D,#A1,#1E,#7B,#1F,#57,#20,#36,#21,#16,#22+#80
FRQ_1   	db #F8,#23,#DC,#24,#C1,#25,#A8,#26,#90,#27,#79,#28,#64,#29,#50,#2A,#3D,#2B,#2C,#2C,#1B,#2D,#0B,#2E+#80
FRQ_0  	db #FC,#2F,#EE,#30,#E0,#31,#D4,#32,#C8,#33,#BD,#34,#B2,#35,#A8,#36,#9F,#37,#96,#38,#8D,#39,#85,#3A,#7E,#3B,#77,#3C,#70,#3D,#6A,#3E,#64,#3F,#5E,#40,#59,#41,#54,#42,#50,#43,#4B,#44,#47,#45,#43,#46,#3F,#47,#3C,#48,#38,#49,#35,#4A,#32,#4B,#2F,#4C,#2D,#4D,#2A,#4E,#28,#4F,#26,#50,#24,#51,#22,#52,#20,#53,#1E,#54,#00,#00 
FRQ_T	dw FRQ_0, FRQ_1, FRQ_2, FRQ_3, FRQ_4, FRQ_5, FRQ_6, FRQ_7, FRQ_8, FRQ_9, FRQ_A, FRQ_B, FRQ_C, FRQ_D, FRQ_E, FRQ_F
 
       
Init	
;Генератор таблицы для печати столбика
;Генератор процедур вывода столбика
	ld hl, ADR_TAB
	ld ix, ADR_TAB2

	ld  b, 11
I0 	push bc

	ld bc, %0000011111100000 : call MK_STOLB
	ld bc, %0000011111100000 : call MK_STOLB
	ld bc, %0000011111100000 : call MK_STOLB
	ld bc, %0000011111100000 : call MK_STOLB
	ld bc, %0111000000001110 : call MK_STOLB
	ld bc, %0111000000001110 : call MK_STOLB
	ld bc, %0111000000001110 : call MK_STOLB
	ld bc, %0111000000001110 : call MK_STOLB

	; ld bc, %0000001111000000 : call MK_STOLB
	; ld bc, %0000001111000000 : call MK_STOLB
	; ld bc, %0000110000110000 : call MK_STOLB
	; ld bc, %0000110000110000 : call MK_STOLB
	; ld bc, %0011000000001100 : call MK_STOLB
	; ld bc, %0011000000001100 : call MK_STOLB
	; ld bc, %1100000000000011 : call MK_STOLB
	; ld bc, %1100000000000011 : call MK_STOLB

	; ld bc, %0000000110000000 : call MK_STOLB
	; ld bc, %0000001001000000 : call MK_STOLB
	; ld bc, %0000010000100000 : call MK_STOLB
	; ld bc, %0000100000010000 : call MK_STOLB
	; ld bc, %0001000000001000 : call MK_STOLB
	; ld bc, %0010000000000100 : call MK_STOLB
	; ld bc, %0100000000000010 : call MK_STOLB
	; ld bc, %1000000000000001 : call MK_STOLB

MKS_D1	ld de, SCR_A1 : inc de : ld (MKS_D1 + 1), de
MKS_D2	ld de, SCR_A2 : inc de : ld (MKS_D2 + 1), de
MKS_D3	ld de, SCR_A1 + #1f : dec de : ld (MKS_D3 + 1), de	
MKS_D4	ld de, SCR_A2 + #1f : dec de : ld (MKS_D4 + 1), de		
	
	pop bc : djnz I0

	ld ix, TO_VIW_ADDR + 32
	ld de, TO_VIW_PROC
	ld a, 16
BC_0	ld (ix + #00), e : ld (ix + #01), d : dec ix : dec ix
	ld hl, PRS
	ld bc, PRS_E - PRS
	ldir
	dec a : jr nz, BC_0

	ld a, #31 : ld (de), a : inc de	; ld SP, XXXX
	ld (ADR_WSP + 2), de
	inc de : inc de
	ld a, #c9 : ld (de), a		; ret
	ret

	; процедура печати столбика
PRS	pop hl : pop af : or (hl) : ld (hl), a
	pop hl : pop af : or (hl) : ld (hl), a
	pop hl : pop af : or (hl) : ld (hl), a
	pop hl : pop af : or (hl) : ld (hl), a
PRS_E

MK_STOLB	ld (ix + #00), l : ld (ix + #01), h : inc ix : inc ix
	
	ld  a, 15
1	push af

MKS_DE1	ld de, SCR_A1
	ld (hl), e : inc hl
	ld (hl), d : inc hl  : inc hl
	ld (hl), c : inc hl
	call lib.UpDE
	ld (MKS_DE1 + 1), de

MKS_DE2	ld de, SCR_A2
	ld (hl), e : inc hl
	ld (hl), d : inc hl : inc hl	
	ld (hl), c : inc hl
	call lib.DownDE
	ld (MKS_DE2 + 1), de

MKS_DE3	ld de, SCR_A1 + #1f
	ld (hl), e : inc hl
	ld (hl), d : inc hl : inc hl	
	ld (hl), b : inc hl
	call lib.UpDE
	ld (MKS_DE3 + 1), de

MKS_DE4	ld de, SCR_A2 + #1f
	ld (hl), e : inc hl
	ld (hl), d : inc hl : inc hl	
	ld (hl), b : inc hl
	call lib.DownDE
	ld (MKS_DE4 + 1), de

	pop af : dec a : jr nz, 1b

	ld de, (MKS_D1 + 1) : ld (MKS_DE1 + 1), de
	ld de, (MKS_D2 + 1) : ld (MKS_DE2 + 1), de
	ld de, (MKS_D3 + 1) : ld (MKS_DE3 + 1), de
	ld de, (MKS_D4 + 1) : ld (MKS_DE4 + 1), de
	ret
 
