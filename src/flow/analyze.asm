A_PART_ANAL_MAIN   	equ A_PART_ANALYZE 
A_PART_ANAL_CC_INIT 	equ A_PART_ANALYZE + 3
A_PART_ANAL_CC   	equ A_PART_ANALYZE + 6

	ld a, P_PART_ANALYZE : call lib.SetPage
	ld hl, PART_ANALYZ_PCK
	ld de, A_PART_ANALYZE
	call lib.Depack

	;  Включаем 0-ю страницу (уже чистая к этому времени), дабы ничего не затереть огромными буферами
	xor a : call lib.SetPage

	call A_PART_ANAL_CC_INIT
	ld hl, A_PART_ANAL_MAIN
	call interrStart

	; ld hl, (INTS_COUNTER) : ld de, 1534 : sbc hl, de : jr c, $-8
	ld hl, (INTS_COUNTER) : ld de, 1920-2 : sbc hl, de : jr c, $-8

	ld a, #07 : out #fe, a
	halt : halt
	xor a : out #fe, a	

	; infinity loop
1 	halt
 	call A_PART_ANAL_CC
	jr 1b


