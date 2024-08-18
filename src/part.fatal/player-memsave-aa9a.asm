	module aaa9a	
anm_hl	ld hl, anima_proc
	ld a, (hl) : or a : jr nz, 1f
	ld hl, anima_proc
1	ld e, (hl) : inc hl
	ld d, (hl) : inc hl
	ld (anm_hl + 1), hl
	ex de, hl

	; determine data flow start
	push hl
1	ld a, (hl) : inc hl : cp %11111111
	jr nz, 1b
	pop ix

	; set start address
	ld a, (hl) : ld e, a : inc hl
	ld a, (hl) : ld d, a : inc hl
_an_cycle	ld a, (ix + 0) : inc ix
	bit 7, a : jr z, 1f
	ld c, a
	and #e0
	cp #a0 : jr z, _anc_jmp100
	ret 
	; end of frame		
1	bit 6, a : jr z, _anc_set
_anc_jmp	; jump screen address
	and #3f
	inc a : ld c, a : ld b, 0
	ex de, hl : add hl, bc : ex de, hl
	jr _an_cycle
_anc_jmp100	ld a, c
	and #0f
	or a : jr z, 1f
	inc d : dec a : jr nz, $-2
1	ld a, c : and %00010000 : jr z, _an_cycle
	ld bc, #0080	; additional jump +128 bytes
	ex de, hl : add hl, bc : ex de, hl
	jr _an_cycle
_anc_set	; copy N bytes from flow to screen
	inc a
	ldi : dec a : jr nz, $-3
	jr _an_cycle
anima_proc
	dw aaa9a_0000
	dw aaa9a_0001
	dw aaa9a_0002
	dw aaa9a_0003
	dw aaa9a_0004
	dw aaa9a_0005
	dw aaa9a_0006
	dw aaa9a_0007
	dw aaa9a_0008
	dw aaa9a_0009
	dw aaa9a_000a 
	db #00
aaa9a_0000	include "res/aa9a/0000.asm"
aaa9a_0001	include "res/aa9a/0001.asm"
aaa9a_0002	include "res/aa9a/0002.asm"
aaa9a_0003	include "res/aa9a/0003.asm"
aaa9a_0004	include "res/aa9a/0004.asm"
aaa9a_0005	include "res/aa9a/0005.asm"
aaa9a_0006	include "res/aa9a/0006.asm"
aaa9a_0007	include "res/aa9a/0007.asm"
aaa9a_0008	include "res/aa9a/0008.asm"
aaa9a_0009	include "res/aa9a/0009.asm"
aaa9a_000a	include "res/aa9a/000a.asm"
	endmodule
