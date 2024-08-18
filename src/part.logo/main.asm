	device zxspectrum128

	; define DEBUG 1

A_PART_LOGO  	equ #7000
A_PART_LOGO_INIT 	equ A_PART_LOGO
A_PART_LOGO_MAIN   	equ A_PART_LOGO + 3 

	org #6000
start	
	module lib
	include "../lib/shared.asm"	
	endmodule

	di : ld sp, start

	xor a : out #fe, a
	ld a,#5c, i,a, hl,interr, (#5cff),hl : im 2 : ei

	call A_PART_LOGO_INIT
	call A_PART_LOGO_MAIN
	jr $

interr	ei : ret

	org A_PART_LOGO
	include "part.logo.asm"
	display /d, 'Part length: ', $ - A_PART_LOGO
	display 'Part ended at: ', $

	; build
	if (_ERRORS == 0 && _WARNINGS == 0)
	;  LABELSLIST "user.l"
	  savesna SNA_FILENAME, start	   ; SNA_FILENAME defined in Makefile
	  savebin BIN_FILENAME, A_PART_LOGO, $-A_PART_LOGO ; BIN_FILENAME defined in Makefile
	endif
