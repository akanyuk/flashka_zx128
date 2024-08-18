	jp init     ; $+0   
	; jp main     ; $+3
	; main
	; ret	
init	ld hl, BG_PCK
	ld de, #4000
	jp lib.Depack
BG_PCK	incbin "res/bg.scr.zx0"
