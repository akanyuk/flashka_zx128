	device zxspectrum128

	; define DEBUG 1

A_PART_FATAL	equ #7000
FATAL_INIT1 	equ A_PART_FATAL
FATAL_INIT2 	equ A_PART_FATAL + 3
FATAL_MAIN1 	equ A_PART_FATAL + 6
FATAL_MAIN2 	equ A_PART_FATAL + 9
FATAL_TEXT1 	equ A_PART_FATAL + 12

	org #6000
start	
	module lib
	include "../lib/shared.asm"	
	endmodule

	di : ld sp, start

	xor a : out #fe, a
	ld a,#5c, i,a, hl,interr, (#5cff),hl : im 2 : ei

	; call FATAL_TEXT1

mainLoop	call FATAL_INIT1
	ld b, 30
1	push bc
	call m1
	halt
	pop bc : djnz 1b

	call FATAL_INIT2
	ld b, 45
1	push bc
	call m2
	halt
	pop bc : djnz 1b

	jr mainLoop

m1	ifdef DEBUG
	ld a, #01 : out (#fe), a
	endif

	call FATAL_MAIN1

	ifdef DEBUG
	ld a, #02 : out (#fe), a
	endif
	ret

m2	ifdef DEBUG
	ld a, #01 : out (#fe), a
	endif

	call FATAL_MAIN2

	ifdef DEBUG
	ld a, #02 : out (#fe), a
	endif
	ret


interr	ei : ret

	org A_PART_FATAL
	include "part.fatal.asm"
	display /d, 'Part length: ', $ - A_PART_FATAL
	display 'Part ended at: ', $

	; build
	if (_ERRORS == 0 && _WARNINGS == 0)
	;  LABELSLIST "user.l"
	  savesna SNA_FILENAME, start	     ; SNA_FILENAME defined in Makefile
	  savebin BIN_FILENAME, A_PART_FATAL, $-A_PART_FATAL ; BIN_FILENAME defined in Makefile
	endif
