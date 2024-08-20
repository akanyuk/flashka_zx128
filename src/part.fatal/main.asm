	device zxspectrum128

	; define _DEBUG_ 1

PART_START	equ #7000
FATAL_INIT1 	equ PART_START
FATAL_INIT2 	equ PART_START + 3
FATAL_INTERR 	equ PART_START + 6
FATAL_BGSW 	equ PART_START + 9
FATAL_TEXT1 	equ PART_START + 12
FATAL_TEXT2 	equ PART_START + 15
FATAL_TEXT3 	equ PART_START + 18
FATAL_TEXT4 	equ PART_START + 21

	org #6000
start	
	module lib
	include "../lib/shared.asm"	
	endmodule

	di : ld sp, start

	xor a : out #fe, a
	ld a, #5c : ld i, a : ld hl, interr : ld (#5cff), hl : im 2 : ei

	; 1
	ld a, %01000110
	call FATAL_INIT1

	ld hl, FATAL_INTERR
	call interrStart

	ld b, 25 : halt : djnz $-1
	call FATAL_TEXT2
	ld b, 100 : halt : djnz $-1
	call interrStop : halt
	
	; 2
	ld a, %01000011
	call FATAL_INIT2

	ld hl, FATAL_INTERR
	call interrStart

	ld b, 25 : halt : djnz $-1
	call FATAL_TEXT4
	ld b, 100 : halt : djnz $-1
	call interrStop : halt

	; 3
	; ld a, %01000101
	; call FATAL_INIT1

	; ld hl, FATAL_INTERR
	; call interrStart

	; ld b, 25 : halt : djnz $-1
	; call FATAL_TEXT3
	; ld b, 100 : halt : djnz $-1
	; call interrStop : halt

	; 4
	ld a, %01000111
	call FATAL_INIT2
	call FATAL_BGSW

	ld hl, FATAL_INTERR
	call interrStart

	ld b, 25 : halt : djnz $-1
	call FATAL_TEXT1
	ld b, 150 : halt : djnz $-1
	call interrStop : halt

	jr $

	; запуск нужной процедуры на прерываниях
	; HL - адрес процедура
interrStart	ld de, interrCurrent
	ex de, hl
	ld (hl), #c3 ; jp
	inc hl : ld (hl), e
	inc hl : ld (hl), d
	ret

	; остановка процедуры на прерываниях
interrStop	ld hl, interrCurrent
	ld (hl), #c9 ; ret
	ret

interrCurrent	ret
	nop
	nop

interr	di
	push af,bc,de,hl,ix,iy
	exx : ex af, af'
	push af,bc,de,hl,ix,iy
	ifdef _DEBUG_ : ld a, #01 : out (#fe), a : endif

	call interrCurrent
	
INTS_COUNTER	equ $+1
	ld hl, #0000 : inc hl : ld ($-3), hl

	ifdef _DEBUG_ : xor a : out (#fe), a : endif
	pop iy,ix,hl,de,bc,af
	exx : ex af, af'
	pop iy,ix,hl,de,bc,af
	ei
	ret
	
	org PART_START
	include "part.fatal.asm"
	display /d, 'Part length: ', $ - PART_START
	display 'Part ended at: ', $

	; build
	if (_ERRORS == 0 && _WARNINGS == 0)
	;  LABELSLIST "user.l"
	  savesna SNA_FILENAME, start	     ; SNA_FILENAME defined in Makefile
	  savebin BIN_FILENAME, PART_START, $-PART_START ; BIN_FILENAME defined in Makefile
	endif
