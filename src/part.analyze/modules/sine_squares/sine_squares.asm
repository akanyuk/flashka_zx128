SIN_TABLE1	equ consts.SinSquaresBuffers        ; 256 bytes
SIN_TABLE2	equ consts.SinSquaresBuffers + 256  ; 256 bytes
SIN_TABLE3	equ consts.SinSquaresBuffers + 512  ; 256 bytes
SIN_TABLE4	equ consts.SinSquaresBuffers + 768  ; 256 bytes
SIN_TABLE5	equ consts.SinSquaresBuffers + 1024 ; 256 bytes
SCR_TABLE	equ consts.SinSquaresBuffers + 1280 ; 384 bytes

	include "cubos.asm"
Init	include "init.asm"
Main
	
m1	ld a, 0 
	ld h, SIN_TABLE1 /256
	ld l, a
	ld a, (hl)
	push af
	ld c, 20 : call hideCubo31

	pop af
	add #58
	ld c, 8 : call hideCubo31

	ld a, (m1 + 1)
	add #80
	ld h, SIN_TABLE1 /256
	ld l, a
	ld a, (hl)
	push af
	ld c, 8 : call hideCubo31

	pop af
	add #58
	ld c, 20 : call hideCubo31

	ld a, (m1 + 1)
	inc a : inc a : ld (m1 + 1), a
	ld h, SIN_TABLE1 /256
	ld l, a
	ld a, (hl)
	push af
	ld c, 20 : call drawCubo31

	pop af
	add #58
	ld c, 8 : call drawCubo31Left

	ld a, (m1 + 1)
	add #80
	ld h, SIN_TABLE1 /256
	ld l, a
	ld a, (hl)
	push af
	ld c, 8 : call drawCubo31Left

	pop af
	add #58
	ld c, 20 : call drawCubo31

m2	ld a, 16
	ld h, SIN_TABLE2 /256
	ld l, a
	ld a, (hl) : add 4
	push af
	ld c, 24 : call hideCubo23

	pop af
	add #58
	ld c, 5 : call hideCubo23

	ld a, (m2 + 1)
	add #80
	ld h, SIN_TABLE2 /256
	ld l, a
	ld a, (hl) : add 4 
	push af
	ld c, 5 : call hideCubo23

	pop af
	add #58
	ld c, 24 : call hideCubo23

	ld a, (m2 + 1)
	inc a : inc a : ld (m2 + 1), a
	ld h, SIN_TABLE2 /256
	ld l, a
	ld a, (hl) : add 4
	push af
	ld c, 24 : call drawCubo23

	pop af
	add #58
	ld c, 5 : call drawCubo23Left

	ld a, (m2 + 1)
	add #80
	ld h, SIN_TABLE2 /256
	ld l, a
	ld a, (hl) : add 4
	push af
	ld c, 5 : call drawCubo23Left

	pop af
	add #58
	ld c, 24 : call drawCubo23

m3	ld a, 32
	ld h, SIN_TABLE3 /256
	ld l, a
	ld a, (hl) : add 8
	push af
	ld c, 27 : call hideCubo15

	pop af
	add #58
	ld c, 3 : call hideCubo15

	ld a, (m3 + 1)
	add #80
	ld h, SIN_TABLE3 /256
	ld l, a
	ld a, (hl) : add 8
	push af
	ld c, 3 : call hideCubo15

	pop af
	add #58
	ld c, 27 : call hideCubo15

	ld a, (m3 + 1)
	inc a : inc a : ld (m3 + 1), a
	ld h, SIN_TABLE3 /256
	ld l, a
	ld a, (hl) : add 8
	push af
	ld c, 27 : call drawCubo15

	pop af
	add #58
	ld c, 3 : call drawCubo15Left

	ld a, (m3 + 1)
	add #80
	ld h, SIN_TABLE3 /256
	ld l, a
	ld a, (hl) : add 8
	push af
	ld c, 3 : call drawCubo15Left

	pop af
	add #58
	ld c, 27 : call drawCubo15

m4	ld a, 48
	ld h, SIN_TABLE4 /256
	ld l, a
	ld a, (hl) : add 12
	push af
	ld c, 29 : call hideCubo8

	pop af
	add #58
	ld c, 2 : call hideCubo8

	ld a, (m4 + 1)
	add #80
	ld h, SIN_TABLE4 /256
	ld l, a
	ld a, (hl) : add 12
	push af
	ld c, 2 : call hideCubo8

	pop af
	add #58
	ld c, 29 : call hideCubo8

	ld a, (m4 + 1)
	inc a : inc a : ld (m4 + 1), a
	ld h, SIN_TABLE4 /256
	ld l, a
	ld a, (hl) : add 12
	push af
	ld c, 29 : call drawCubo8

	pop af
	add #58
	ld c, 2 : call drawCubo8

	; bottom cubos show
	ld a, (m4 + 1)
	add #80
	ld h, SIN_TABLE4 /256
	ld l, a
	ld a, (hl) : add 12
	push af
	ld c, 2 : call drawCubo8

	pop af
	add #58
	ld c, 29 : call drawCubo8

m5	ld a, 64
	ld h, SIN_TABLE5 /256
	ld l, a
	ld a, (hl) : add 14
	push af
	ld c, 30 : call hideCubo6

	pop af
	add #58
	ld c, 1 : call hideCubo6

	ld a, (m5 + 1)
	add #80
	ld h, SIN_TABLE5 /256
	ld l, a
	ld a, (hl) : add 14
	push af
	ld c, 1 : call hideCubo6

	pop af
	add #58
	ld c, 30 : call hideCubo6

	ld a, (m5 + 1)
	inc a : inc a : ld (m5 + 1), a
	ld h, SIN_TABLE5 /256
	ld l, a
	ld a, (hl) : add 14
	push af
	ld c, 30 : call drawCubo6

	pop af
	add #58
	ld c, 1 : call drawCubo6Left

	ld a, (m5 + 1)
	add #80
	ld h, SIN_TABLE5 /256
	ld l, a
	ld a, (hl) : add 14
	push af
	ld c, 1 : call drawCubo6Left

	pop af
	add #58
	ld c, 30 : jp drawCubo6

	; ret
