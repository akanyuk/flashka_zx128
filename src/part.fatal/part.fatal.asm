	jp init1	; $+0   
	jp init2	; $+3
	jp main1     	; $+6
	jp main2     	; $+9  
	jp printText1   ; $+12

init1	ld hl, BG_PCK
	ld de, #4000
	call lib.Depack

	xor a : call lib.SetScreenAttr
	ld b, 15 : push bc : call p1pa : pop bc : djnz $-5
	ld a, %01110000 : call lib.SetScreenAttr

	ld hl, p1ib 
	call initAnim
	ret

init2	ld hl, BG_PCK
	ld de, #4000
	call lib.Depack

	xor a : call lib.SetScreenAttr
	ld b, 15 : push bc : call p2pa : pop bc : djnz $-5
	ld a, %01110000 : call lib.SetScreenAttr

	ld hl, p2ib 
	call initAnim
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

main1	call bgSwitch
	ld bc, 19000 : call lib.Delay
	call p1pa
	halt
	call bgSwitch
	halt
	call bgSwitch
	halt
	call bgSwitch
	ret

main2	call bgSwitch
	ld bc, 15500 : call lib.Delay
	call p2pa
	halt
	call bgSwitch
	halt
	call bgSwitch
	halt
	call bgSwitch
	ret

bgSwitch	ld hl, BG_SWITCH : ld a, (hl) : cp %01010000 : jr nz, 1f
	ld hl, BG_SWITCH-1
1	inc hl : ld (bgSwitch+1), hl
	ld hl, #5800 : ld de, #5801 : ld bc, 32*16-1 : ld (hl), a : ldir
	ret
BG_SWITCH	db %01001000
	db %01001000	
	db %01001000
	db %01010000

printText1	ld hl, TEXT11
	ld de, #a000
	call text
	ld hl, TEXT12
	ld de, #b000
	jp text	
text	include "text.asm"
	include "text_ansi.asm"

p1pa	include "player-memsave-aa9a.asm"	
p2pa	include "player-memsave-af2f.asm"	

BG_PCK	incbin "res/bg.scr.zx0"
