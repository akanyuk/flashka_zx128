	jp init1	; $+0   
	jp init2	; $+3
	jp fatalInterr  ; $+6
	jp startSwitch	; $+9
	jp printText1   ; $+12
	jp printText2   ; $+15
	jp printText3   ; $+18
	jp printText4   ; $+21

startSwitch	ld hl, bgSwitch
	ld (interrBGSwitch), hl
	ret

init1	ex af, af'
	ld hl, BG_PCK
	ld de, #4000
	call lib.Depack

	xor a : call lib.SetScreenAttr
	ld b, 15 : push bc : call p1pa : pop bc : djnz $-5
	ld a, %01111000 : call lib.SetScreenAttr
	ex af, af' 
	ld hl, #5a00
	ld de, #5a01
	ld bc, #ff
	ld (hl), a
	ldir

	ld hl, p1ib 
	call initAnim

	ld hl, p1pa
	ld (_interr + 1), hl
	ret

init2	ex af, af'
	ld hl, BG_PCK
	ld de, #4000
	call lib.Depack

	xor a : call lib.SetScreenAttr
	ld b, 15 : push bc : call p2pa : pop bc : djnz $-5
	ld a, %01111000 : call lib.SetScreenAttr
	ex af, af' 
	ld hl, #5a00
	ld de, #5a01
	ld bc, #ff
	ld (hl), a
	ldir

	ld hl, p2ib 
	call initAnim

	ld hl, p2pa
	ld (_interr + 1), hl
	ret

initAnim	ld d, #48
	ld a, (hl) : or a : ret z : inc hl
	ld e, a
	ld a, #ff
	dup 7
	ld (de), a : inc d
	edup
	ld (de), a
	jr initAnim
p1ib	db #71, #72, #91, #92, #93, #b0, #b1, #b2, #b3, #d0, #d1, #d2, #d3
	db #00
p2ib	db #70, #72, #73, #90, #91, #92, #b0, #b1, #b2, #d0, #d1, #d2
	db #00

fatalInterr	ld a, 0 : inc a : and 3 : ld ($-4), a
interrBGSwitch	equ $+2
	or a : jp nz, bgNoSwitch
_interr	jp p1pa

bgNoSwitch	ret

bgSwitch	
_bgSwitch	ld hl, BG_SWITCH1 : ld a, l : cp low(BG_SWITCH1) + 8  : jr nz, 1f
	ld hl, BG_SWITCH1
1	ld a, (hl) : inc hl : ld (_bgSwitch+1), hl
	ld hl, #5800 : ld de, #5801 : ld bc, 32*16-1 : ld (hl), a : ldir
	ret

BG_SWITCH1	db %01011000
	db %01011000
	db %01011000
	db %01011000
	db %01001000
	db %01001000
	db %01001000
	db %01001000

printText1	ld hl, TEXT11
	ld de, #a000
	call text
	ld hl, TEXT12
	ld de, #b000
	jp text	
printText2	ld hl, TEXT21
	ld de, #8000
	call text
	ld hl, TEXT22
	ld de, #9000
	call text
	ld hl, TEXT23
	ld de, #a000
	call text
	ld hl, TEXT24
	ld de, #b000
	jp text	
printText3	ld hl, TEXT31
	ld de, #8000
	call text
	ld hl, TEXT32
	ld de, #9000
	call text
	ld hl, TEXT33
	ld de, #a000
	call text
	ld hl, TEXT34
	ld de, #b000
	jp text	

printText4	ld hl, TEXT41
	ld de, #8000
	call text
	ld hl, TEXT44
	ld de, #9000
	call text
	ld hl, TEXT43
	ld de, #a000
	call text
	ld hl, TEXT44
	ld de, #b000
	jp text	


text	include "text.asm"
	include "text_ansi.asm"

BG_PCK	incbin "res/bg.scr.zx0"

p1pa	include "player-memsave-aa9a.asm"	
p2pa	include "player-memsave-af2f.asm"	
