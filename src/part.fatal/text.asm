	ld (_iT1 + 1), de
	ld (_iT2 + 1), hl
_iT1	ld DE, 0
	ld a, 0 : inc a : and 1 : ld ($-4), a
	cp 1 : jr nz, $+3
	halt
_iT2	ld HL, 0 : ld A, (HL)
	cp #20 : jr NZ, 1f ; Пропускаем пробел
	call _iTnextChar : jr _iT1
1	or a : ret z ; Закончили
_iT3	ld A, #00 : inc A : ld (_iT3 + 1), A
	cp #0B : jr NZ, 1f
	xor A : ld (_iT3 + 1), A : jr _iT1
	
1	cp #01 : jr NZ, 1f
	call printChar16x16x16 : jr _iT1
1	cp #02 : jr NZ, 1f
	call printChar16x16x8 : jr _iT1
1	cp #03 : jr NZ, 1f
	ld A, (HL) : call printChar16x16x4 : jr _iT1
1	cp #05 : jr NZ, 1f
	ld A, (HL) : call printChar16x16x2 : jr _iT1
1	cp #07 : jr NZ, 1f
	ld A, (HL) : call printChar16x16x15 : jr _iT1
1	cp #09 : jr NZ, _iT1
	ld A, (HL) : call printChar16x16
	call _iTnextChar
		
	jp _iT1
		
_iTnextChar	ld hl, _iT1 + 1 : inc (HL) : inc (HL)
	ld HL, _iT2 + 1 : inc (HL)
	ret
		
; Печать через стек без запрета прерываний спрайта 2*2 знакоместа на основном экране БЕЗ МАСКИ
; D - Screen line (0-191) Обязательно кратно двум!
; E - Screen col (0-31)
; A - char number
printChar16x16 	ld (_pC16x16s),SP
	sub #20
	cp #60
	jr C, $+4
	sub #60
		
	ld H, #00 : ld L, A
	DUP 5
	add HL, HL    		; HL = HL*32
	EDUP
		
	ld BC, FONT16_ADDR 
        	add HL, BC			; Адрес спрайта

	; Calculate screen start address (top-left corner)
	ld IX, SCR_X_TABLE
	ld B, #00 : ld C, D
	add IX, BC : add IX, BC

	ld C, (HL)	; Делаем именно так, чтобы прерывание
	inc HL	; не испортило спрайт
        	ld B, (HL)	; поэтому в BC у нас
	inc HL	; уже есть первые 2 байта спрайта
        
        	ld SP, HL	; Теперь стек указывает на начало спрайта
		
	ld D, #00	; Теперь в DE смещение относительно левого края экрана
		
	; Непосредственно сам вывод спрайта
	ld L, (IX) : ld H, (IX + 1)
	add HL, DE
	ld (HL), C
	inc L
	ld (HL), B
	inc H
	pop BC 
	ld (HL), B
	dec L
	ld (HL), C
	ld L, (IX + 4) : ld H, (IX + 5) : add HL, DE
	DUP 6
	pop BC
	ld (HL), C
	inc L
	ld (HL), B
	inc H
	pop BC
	ld (HL), B
	dec L
	ld (HL), C
	ld L, (IX + 8) : ld H, (IX + 9) : inc IX : inc IX : inc IX : inc IX : add HL, DE
	EDUP 
	pop BC
	ld (HL), C
	inc L
	ld (HL), B
	inc H
	pop BC
	ld (HL), B
	dec L
	ld (HL), C
_pC16x16s 	EQU $+1 
	ld SP, #0000
        	ret 
	
; Печать через стек без запрета прерываний спрайта 2*2 знакоместа на основном экране с уменьшением x1.5
; D - Screen line (0-191) Обязательно кратно двум!
; E - Screen col (0-31)
; A - char number
        	MACRO ZOOM15R ; zoom x1.5 right
	xor A
	rr C : jr NC, $+4 : or #01
	rr C : jr NC, $+4 : or #02
	rr C : jr NC, $+4 : or #04
	rr C : jr NC, $+4 : or #08
	rr C : rr C : jr NC, $+4 : or #10
	rr C : rr C : jr NC, $+4 : or #20
	ld (HL), A
        	ENDM
		
	MACRO ZOOM15L ; zoom x1.5 left
	xor A
	rl B : jr NC, $+4 : or #80
	rl B : jr NC, $+4 : or #40
	rl B : jr NC, $+4 : or #20
	rl B : jr NC, $+4 : or #10
	rl B : rl B : jr NC, $+4 : or #08
	rl B : rl B : jr NC, $+4 : or #04
	ld (HL), A
	ENDM
		
printChar16x16x15
	ld (_pC16x16x15s),SP
	sub #20
	cp #60
	jr C, $+4
	sub #60
		
	ld H, #00 : ld L, A
	DUP 5
        	add HL, HL    		; HL = HL*32
	EDUP
		
	ld BC, FONT16_ADDR 			
        	add HL, BC					; Адрес спрайта

	; Calculate screen start address (top-left corner)
	ld IX, SCR_X_TABLE + 4 ; Сдвигаемся вниз на 2 линии
	ld B, #00 : ld C, D
	add IX, BC : add IX, BC

	ld SP, HL     		; Теперь стек указывает на начало спрайта
	ld D, #00			; Теперь в DE смещение относительно левого края экрана

	; Непосредственно сам вывод спрайта
        	DUP 5
	ld L, (IX) : ld H, (IX + 1) : add HL, DE : inc IX : inc IX
        	pop BC : pop BC 
	ZOOM15R
        	inc L
	ZOOM15L
	ld L, (IX) : ld H, (IX + 1) : add HL, DE : inc IX : inc IX
        	pop BC
	ZOOM15R
        	inc L
	ZOOM15L
        	EDUP 
_pC16x16x15s 	EQU $+1 
	ld SP, #0000
        	ret 
		
; Печать через стек без запрета прерываний спрайта 2*2 знакоместа на основном экране с уменьшением x2
; D - Screen line (0-191) Обязательно кратно двум!
; E - Screen col (0-31)
; A - char number
        	MACRO ZOOM2R ; zoom x2 right
	xor A
	rr C : rr C : jr NC, $+4 : or #01
	rr C : rr C : jr NC, $+4 : or #02
	rr C : rr C : jr NC, $+4 : or #04
	rr C : rr C : jr NC, $+4 : or #08
	ld (HL), A
        	ENDM
		
	MACRO ZOOM2L ; zoom x2 left
	xor A
	rl B : rl B : jr NC, $+4 : or #80
	rl B : rl B : jr NC, $+4 : or #40
	rl B : rl B : jr NC, $+4 : or #20
	rl B : rl B : jr NC, $+4 : or #10
	ld (HL), A
	ENDM
		
printChar16x16x2 
	ld (_pC16x16x2s),SP
	sub #20
	cp #60
	jr C, $+4
	sub #60
		
	ld H, #00 : ld L, A
	DUP 5
        	add HL, HL    		; HL = HL*32
	EDUP
		
	ld BC, FONT16_ADDR 			
        	add HL, BC					; Адрес спрайта

	; Calculate screen start address (top-left corner)
	ld IX, SCR_X_TABLE + 8 ; Сдвигаемся вниз на 4 линии
	ld B, #00 : ld C, D
	add IX, BC : add IX, BC

        	ld SP, HL     		; Теперь стек указывает на начало спрайта
	ld D, #00			; Теперь в DE смещение относительно левого края экрана

	; Непосредственно сам вывод спрайта
        	DUP 8
	ld L, (IX) : ld H, (IX + 1) : add HL, DE : inc IX : inc IX
        	pop BC : pop BC ; Нечетные пропускаем
	ZOOM2R
        	inc L
	ZOOM2L		
        	EDUP 
_pC16x16x2s 	EQU $+1 
	ld SP, #0000
        	ret 
		
; Печать через стек без запрета прерываний спрайта 2*2 знакоместа на основном экране с уменьшением x4
; D - Screen line (0-191) Обязательно кратно двум!
; E - Screen col (0-31)
; A - char number
	MACRO ZOOM4R ; zoom x4 right
	xor A
	rr C : rr C : rr C : rr C : jr NC, $+4 : or #01
	rr C : rr C : rr C : rr C : jr NC, $+4 : or #02
	ld (HL), A
	ENDM
		
	MACRO ZOOM4L ; zoom x4 left
	xor A
	rl B : rl B : rl B : rl B : jr NC, $+4 : or #80
	rl B : rl B : rl B : rl B : jr NC, $+4 : or #40
	ld (HL), A
	ENDM
		
printChar16x16x4 
	ld (_pC16x16x4s),SP
	sub #20
	cp #60
	jr C, $+4
	sub #60
	
	ld H, #00 : ld L, A
	DUP 5
        	add HL, HL    		; HL = HL*32
	EDUP
		
	ld BC, FONT16_ADDR 			
        	add HL, BC					; Адрес спрайта

	; Calculate screen start address (top-left corner)
	ld IX, SCR_X_TABLE + 16 ; Сдвигаемся вниз на 8 линий
	ld B, #00 : ld C, D
	add IX, BC : add IX, BC

        	ld SP, HL     		; Теперь стек указывает на начало спрайта
	ld D, #00			; Теперь в DE смещение относительно левого края экрана

	; Непосредственно сам вывод спрайта
        	DUP 4
	ld L, (IX) : ld H, (IX + 1) : add HL, DE : inc IX : inc IX
        	pop BC : pop BC : pop BC : pop BC ; Каждые три пропускаем
	ZOOM4R
        	inc L
	ZOOM4L		
        	EDUP 
_pC16x16x4s EQU $+1 
	ld SP, #0000
        	ret 
		
; Печать через стек без запрета прерываний спрайта 2*2 знакоместа на основном экране с уменьшением x8
; Fake! Просто рисуем 4 точки
; D - Screen line (0-191) Обязательно кратно двум!
; E - Screen col (0-31)
printChar16x16x8 
	; Calculate screen start address (top-left corner)
	ld IX, SCR_X_TABLE + 16 ; Сдвигаемся вниз на 8 линий
	ld B, #00 : ld C, D
	add IX, BC : add IX, BC
	
	ld D, #00
	ld BC, #8001
	
	ld L, (IX) : ld H, (IX + 1) : add HL, DE
	ld (HL), C : inc HL : ld (HL), B
	ld L, (IX+2) : ld H, (IX + 3) : add HL, DE
	ld (HL), C : inc HL : ld (HL), B
	ret 
		
; Печать через стек без запрета прерываний спрайта 2*2 знакоместа на основном экране с уменьшением x16
; Fake! Просто рисуем 1 точку
; D - Screen line (0-191) Обязательно кратно двум!
; E - Screen col (0-31)
printChar16x16x16
	; Calculate screen start address (top-left corner)
	ld IX, SCR_X_TABLE + 16 ; Сдвигаемся вниз на 8 линий
	ld B, #00 : ld C, D
	add IX, BC : add IX, BC
	ld L, (IX + 0) : ld H, (IX + 1) : ld D, #00 : add HL, DE : ld (HL), #01
	ret		
		
FONT16_ADDR 	incbin "res/16x16font"
	align #0100
SCR_X_TABLE 	incbin "res/scrx-table"
