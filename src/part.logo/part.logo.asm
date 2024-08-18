	ld hl, BG_PCK
	ld de, #4000
	jp lib.Depack
BG_PCK	incbin "res/logo.scr.zx0"
