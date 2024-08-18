	device zxspectrum128
	page 0

	define DEBUG 1
	define MUSIC 1

	define PART_CC    ; Preview part CC
	; define PART_MF    ; Preview part MF

A_PART_ANALYZE  	equ #7000
A_PART_ANAL_MAIN   	equ A_PART_ANALYZE 
A_PART_ANAL_CC_INIT 	equ A_PART_ANALYZE + 3
A_PART_ANAL_CC   	equ A_PART_ANALYZE + 6

	module consts
AnalyzeBuffers1	equ #9000 
SinSquaresBuffers	equ #e500
	endmodule

	org #6000
start
	module lib
	include "../lib/shared.asm"	
	endmodule

	di : ld sp, start
	xor a : out #fe, a
	call lib.SetScreenAttr

	ld a, #1 : call lib.SetPage
	call PT3PLAY
	xor a : call lib.SetPage

	ld a,#5c : ld i,a : ld hl,interr : ld (#5cff),hl : im 2 : ei
	; ld a,#be : ld i,a : ld hl,interr : ld (#beff),hl : im 2 : ei

	// Preview part CC
	ifdef PART_CC
	call A_PART_ANAL_CC_INIT
	
	ld hl, A_PART_ANAL_MAIN
	call interrStart

	ld b, 178 : halt : djnz $-1

	ld a, #07 : out #fe, a
	halt : halt
	xor a : out #fe, a	

	call A_PART_ANAL_CC
	jr $-3
	endif

	// Preview part MF
	ifdef PART_MF
	call A_PART_ANAL_MF_INIT
	
	ld hl, A_PART_ANAL_MAIN
	call interrStart

1	;call A_PART_ANAL_CUBES
	halt
	jr 1b	

	endif

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

	ifdef DEBUG : ld a, #01 : out (#fe), a : endif ; debug
	ld a, #1 : call lib.SetPage
	ifdef MUSIC :  call PT3PLAY + 5 : endif ; debug
	xor a : call lib.SetPage
	call interrCurrent
	ifdef DEBUG : xor a : out (#fe), a : endif ; debug

	pop iy,ix,hl,de,bc,af
	exx : ex af, af'
	pop iy,ix,hl,de,bc,af
	ei
	ret

	org A_PART_ANALYZE
	include "part.analyze.asm"
	display /d, 'Part length: ', $ - A_PART_ANALYZE
	display 'Part ended at: ', $
PART_ANALYZE_END	equ $

	page 1
	org #c000
PT3PLAY	include "../lib/PTxPlay.asm"
	incbin "res/NODEMO-09-02.pt3"


	; build
	if (_ERRORS == 0 && _WARNINGS == 0)
	;  LABELSLIST "user.l"
	  savesna SNA_FILENAME, start	         	; SNA_FILENAME defined in Makefile
	  savebin BIN_FILENAME, A_PART_ANALYZE, PART_ANALYZE_END-A_PART_ANALYZE ; BIN_FILENAME defined in Makefile
	endif
