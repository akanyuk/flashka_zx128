	module af2f
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
	dw aaf2f_0000
	dw aaf2f_0001
	dw aaf2f_0002
	dw aaf2f_0003
	dw aaf2f_0004
	dw aaf2f_0005
	dw aaf2f_0006
	dw aaf2f_0007
	dw aaf2f_0008
	dw aaf2f_0009
	dw aaf2f_000a
	dw aaf2f_000b
	dw aaf2f_000c
	dw aaf2f_000d
	dw aaf2f_000e
	dw aaf2f_000f 
	db #00
aaf2f_0000	include "res/af2f/0000.asm"
aaf2f_0001	include "res/af2f/0001.asm"
aaf2f_0002	include "res/af2f/0002.asm"
aaf2f_0003	include "res/af2f/0003.asm"
aaf2f_0004	include "res/af2f/0004.asm"
aaf2f_0005	include "res/af2f/0005.asm"
aaf2f_0006	include "res/af2f/0006.asm"
aaf2f_0007	include "res/af2f/0007.asm"
aaf2f_0008	include "res/af2f/0008.asm"
aaf2f_0009	include "res/af2f/0009.asm"
aaf2f_000a	include "res/af2f/000a.asm"
aaf2f_000b	include "res/af2f/000b.asm"
aaf2f_000c	include "res/af2f/000c.asm"
aaf2f_000d	include "res/af2f/000d.asm"
aaf2f_000e	include "res/af2f/000e.asm"
aaf2f_000f	include "res/af2f/000f.asm"
	endmodule
