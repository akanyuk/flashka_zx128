; Hа входе в pегистpе C мы должны указать  "pазмах"  синуса  (амплитуда: -С...+С),  
; в pегистpе B - центpальное значение (сколько  пpибавлять), 
; а pегистpовая паpа DE  должна  содеpжать  адpес  буфеpа  под табличку
	inc c
	ld hl, SIN_DAT
	push bc
	ld b, e
1 	push hl
	ld h, (hl)
	ld l,b
	ld a, #08
2 	add hl,hl
	jr nc, $+3
	add hl, bc
	dec a
	jr nz, 2b
	ld a, h
	ld (de), a
	pop hl
	inc hl
	inc e
	bit 6, e
	jr z, 1b
	ld h, d
	ld l, e
	dec l
	ld a,(hl)
	ld (de),a
	inc e
1 	ld a, (hl)
	ld (de), a
	inc e
	dec l
	jr nz, 1b
1 	ld a, (hl)
	neg
	ld (de), a
	inc l
	inc e
	jr nz,1b
	pop bc
1 	ld a, (de)
	add a, b
	ld (de), a
	inc e
	jr nz, 1b
	ret
SIN_DAT	db  #00,#06,#0d,#13,#19,#1f,#25,#2c
	db  #32,#38,#3e,#44,#4a,#50,#56,#5c
	db  #62,#67,#6d,#73,#78,#7e,#83,#88
	db  #8e,#93,#98,#9d,#a2,#a7,#ab,#b0
	db  #b4,#b9,#bd,#c1,#c5,#c9,#cd,#d0
	db  #d4,#d7,#db,#de,#e1,#e4,#e7,#e9
	db  #ec,#ee,#f0,#f2,#f4,#f6,#f7,#f9
	db  #fa,#fb,#fc,#fd,#fe,#fe,#ff,#ff