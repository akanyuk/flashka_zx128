A_PART_ANAL_MAIN   	equ A_PART_ANALYZE 
A_PART_ANAL_CC_INIT 	equ A_PART_ANALYZE + 3
A_PART_ANAL_CC   	equ A_PART_ANALYZE + 6

	ld a, P_PART_ANALYZE : call lib.SetPage
	ld hl, PART_ANALYZE_PACKED
	ld de, A_PART_ANALYZE
	call lib.Depack
	;  Включаем 0-ю страницу (уже чистая к этому времени), дабы ничего не затереть огромными буферами
	xor a : call lib.SetPage

	call A_PART_ANAL_CC_INIT
	ld hl, A_PART_ANAL_MAIN
	call interrStart


	ld b, 178 : halt : djnz $-1

	ld a, #07 : out #fe, a
	halt : halt
	xor a : out #fe, a	

	ld bc, 500
1	push bc
	halt
	call A_PART_ANAL_CC
	pop bc
	dec bc
	ld a, b : or c : jr nz, 1b

	call interrStop
