	jp analyze.MainSlow    	; $+0  - analizators slow
	jp init     		; $+3  - part CC (sine squares + analyze) init
	jp sine_squares.Main   	; $+6  - part CC main	
init	call analyze.Init
	call sine_squares.Init
	ld hl, CC_BG_PCK
	ld de, #4000
	jp lib.Depack
CC_BG_PCK	incbin "res/flash-bg.scr.zx0"

	module analyze
	include "modules/analyze/analyze.asm"
	endmodule

	module sine_squares
	include "modules/sine_squares/sine_squares.asm"
	endmodule	
