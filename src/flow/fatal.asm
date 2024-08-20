FATAL_INIT1 	equ A_PART_FATAL
FATAL_INIT2 	equ A_PART_FATAL + 3
FATAL_INTERR 	equ A_PART_FATAL + 6
FATAL_BGSW 	equ A_PART_FATAL + 9
FATAL_TEXT1 	equ A_PART_FATAL + 12
FATAL_TEXT2 	equ A_PART_FATAL + 15
FATAL_TEXT3 	equ A_PART_FATAL + 18
FATAL_TEXT4 	equ A_PART_FATAL + 21

	; part.fatal: depack and initialization
	ld a, P_PART_FATAL : call lib.SetPage
	ld hl, PART_FATAL_PCK
	ld de, A_PART_FATAL
	call lib.Depack

	; 1
	ld a, %01000110
	call FATAL_INIT1

	ld hl, FATAL_INTERR
	call interrStart

	ld b, 15 : halt : djnz $-1
	call FATAL_TEXT2
	ld b, 75 : halt : djnz $-1
	call interrStop : halt
	
	; 2
	ld a, %01000011
	call FATAL_INIT2

	ld hl, FATAL_INTERR
	call interrStart

	ld b, 15 : halt : djnz $-1
	call FATAL_TEXT4
	ld b, 75 : halt : djnz $-1
	call interrStop : halt

	; 3
	; ld a, %01000010
	; call FATAL_INIT1

	; ld hl, FATAL_INTERR
	; call interrStart

	; ld b, 15 : halt : djnz $-1
	; call FATAL_TEXT3
	; ld b, 75 : halt : djnz $-1
	; call interrStop : halt

	; 4
	ld a, %01000111
	call FATAL_INIT1
	call FATAL_BGSW

	ld hl, FATAL_INTERR
	call interrStart

	call FATAL_TEXT1
	ld b, 70 : halt : djnz $-1
	call interrStop : halt
