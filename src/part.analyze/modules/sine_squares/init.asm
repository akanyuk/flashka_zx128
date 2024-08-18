	ld hl, SCR_TABLE
	ld de, #4000
1	ld (hl), e : inc hl
	ld (hl), d : inc hl
	call lib.DownDE
	ld a, d : cp #d8 : jr nz, 1b

	ld de, SIN_TABLE1
	ld bc, #2409
	call sinMake

	ld de, SIN_TABLE2
	ld bc, #240e
	call sinMake

	ld de, SIN_TABLE3
	ld bc, #2412
	call sinMake

	ld de, SIN_TABLE4
	ld bc, #2413
	call sinMake

	ld de, SIN_TABLE5
	ld bc, #2414
	call sinMake

	ret

sinMake	include "sinmake.asm"

