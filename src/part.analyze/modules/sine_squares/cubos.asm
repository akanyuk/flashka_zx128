	; Hide cubo 31x31
	;
	; PARAMS:
	; A = y coord
	; C = attribute col (x)
hideCubo31	ld e, a
	ld d, 0
	ld hl, SCR_TABLE
	add hl, de : add hl, de

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	xor a
	ld (de), a : inc de : ld (de), a : inc de : ld (de), a : inc de : ld (de), a

	ld de, 58 : add hl, de
	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	xor a
	ld (de), a : inc de : ld (de), a : inc de : ld (de), a : inc de : ld (de), a

	ret

	; Draw cubo 31x31
	;
	; PARAMS:
	; A = y coord
	; C = attribute col (x)
drawCubo31	ld e, a
	ld d, 0
	ld hl, SCR_TABLE
	add hl, de : add hl, de

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %01111111 : ld (de), a : inc de 
	ld a, %11111111 : ld (de), a : inc de : ld (de), a : inc de
	ld a, %11111100  : ld (de), a

	ld b, 29
1	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %11111111 : ld (de), a : inc de : ld (de), a : inc de : ld (de), a : inc de 
	ld a, %11111110  : ld (de), a
	djnz 1b

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %01111111 : ld (de), a : inc de 
	ld a, %11111111 : ld (de), a : inc de : ld (de), a : inc de 
	ld a, %11111100  : ld (de), a
	ret

	; Draw cubo 31x31 (left side)
	;
	; PARAMS:
	; A = y coord
	; C = attribute col (x)
drawCubo31Left	ld e, a
	ld d, 0
	ld hl, SCR_TABLE
	add hl, de : add hl, de

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %00111111 : ld (de), a : inc de 
	ld a, %11111111 : ld (de), a : inc de : ld (de), a : inc de
	ld a, %11111110  : ld (de), a

	ld b, 29
1	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %01111111 : ld (de), a : inc de
	ld a, %11111111  : ld (de), a : inc de : ld (de), a : inc de : ld (de), a

	djnz 1b

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %00111111 : ld (de), a : inc de 
	ld a, %11111111 : ld (de), a : inc de : ld (de), a : inc de 
	ld a, %11111110  : ld (de), a
	ret

	; Hide cubo 23x23
	;
	; PARAMS:
	; A = y coord
	; C = attribute col (x)
hideCubo23	ld e, a
	ld d, 0
	ld hl, SCR_TABLE
	add hl, de : add hl, de

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	xor a
	ld (de), a : inc de : ld (de), a : inc de : ld (de), a

	ld de, 42 : add hl, de
	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	xor a
	ld (de), a : inc de : ld (de), a : inc de : ld (de), a

	ret

	; Draw cubo 23x23
	;
	; PARAMS:
	; A = y coord
	; C = attribute col (x)
drawCubo23	ld e, a
	ld d, 0
	ld hl, SCR_TABLE
	add hl, de : add hl, de

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %01111111 : ld (de), a : inc de 
	ld a, %11111111 : ld (de), a : inc de 	
	ld a, %11111100  : ld (de), a

	ld b, 21
1	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %11111111 : ld (de), a : inc de 
	ld a, %11111111 : ld (de), a : inc de 
	ld a, %11111110  : ld (de), a

	djnz 1b

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %01111111 : ld (de), a : inc de 
	ld a, %11111111 : ld (de), a : inc de 
	ld a, %11111100  : ld (de), a
	ret

	; Draw cubo 23x23 (left side)
	;
	; PARAMS:
	; A = y coord
	; C = attribute col (x)
drawCubo23Left	ld e, a
	ld d, 0
	ld hl, SCR_TABLE
	add hl, de : add hl, de

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %00111111 : ld (de), a : inc de 
	ld a, %11111111 : ld (de), a : inc de 	
	ld a, %11111110  : ld (de), a

	ld b, 21
1	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %01111111 : ld (de), a : inc de 
	ld a, %11111111 : ld (de), a : inc de 
	ld a, %11111111  : ld (de), a

	djnz 1b

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %00111111 : ld (de), a : inc de 
	ld a, %11111111 : ld (de), a : inc de 
	ld a, %11111110  : ld (de), a
	ret

	; Hide cubo 15x15
	;
	; PARAMS:
	; A = y coord
	; C = attribute col (x)
hideCubo15	ld e, a
	ld d, 0
	ld hl, SCR_TABLE
	add hl, de : add hl, de

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	xor a
	ld (de), a : inc de : ld (de), a

	ld de, 26 : add hl, de
	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	xor a
	ld (de), a : inc de : ld (de), a

	ret

	; Draw cubo 15x15
	;
	; PARAMS:
	; A = y coord
	; C = attribute col (x)
drawCubo15	ld e, a
	ld d, 0
	ld hl, SCR_TABLE
	add hl, de : add hl, de

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %01111111 : ld (de), a : inc de 
	ld a, %11111100  : ld (de), a

	ld b, 13
1	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %11111111 : ld (de), a : inc de 
	ld a, %11111110  : ld (de), a

	djnz 1b

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %01111111 : ld (de), a : inc de 
	ld a, %11111100  : ld (de), a
	ret

	; Draw cubo 15x15 (left side)
	;
	; PARAMS:
	; A = y coord
	; C = attribute col (x)
drawCubo15Left	ld e, a
	ld d, 0
	ld hl, SCR_TABLE
	add hl, de : add hl, de

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %00111111 : ld (de), a : inc de 
	ld a, %11111110  : ld (de), a

	ld b, 13
1	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %01111111 : ld (de), a : inc de 
	ld a, %11111111  : ld (de), a

	djnz 1b

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %00111111 : ld (de), a : inc de 
	ld a, %11111110  : ld (de), a
	ret

	; Hide cubo 8x8
	;
	; PARAMS:
	; A = y coord
	; C = attribute col (x)
hideCubo8	ld e, a
	ld d, 0
	ld hl, SCR_TABLE
	add hl, de : add hl, de

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	xor a : ld (de), a

	ld de, 12 : add hl, de
	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	xor a : ld (de), a

	ret

	; Draw cubo 8x8
	;
	; PARAMS:
	; A = y coord
	; C = attribute col (x)
drawCubo8	ld e, a
	ld d, 0
	ld hl, SCR_TABLE
	add hl, de : add hl, de

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %01111110 : ld (de), a

	ld b, 6
1	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %11111111 : ld (de), a

	djnz 1b

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %01111110 : ld (de), a
	ret	

	; Hide cubo 6x6
	;
	; PARAMS:
	; A = y coord
	; C = attribute col (x)
hideCubo6	ld e, a
	ld d, 0
	ld hl, SCR_TABLE
	add hl, de : add hl, de

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	xor a : ld (de), a

	ld de, 8 : add hl, de
	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	xor a : ld (de), a

	ret

	; Draw cubo 6x6
	;
	; PARAMS:
	; A = y coord
	; C = attribute col (x)
drawCubo6	ld e, a
	ld d, 0
	ld hl, SCR_TABLE
	add hl, de : add hl, de

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %00111100 : ld (de), a

	ld b, 4
1	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %01111110 : ld (de), a

	djnz 1b

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %00111100 : ld (de), a
	ret
	
	; Draw cubo 6x6 (left side)
	;
	; PARAMS:
	; A = y coord
	; C = attribute col (x)
drawCubo6Left	ld e, a
	ld d, 0
	ld hl, SCR_TABLE
	add hl, de : add hl, de

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %00111100 : ld (de), a

	ld b, 4
1	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %01111110 : ld (de), a

	djnz 1b

	ld a, (hl) : add c : ld e, a : inc hl
	ld d, (hl) : inc hl
	ld a, %00111100 : ld (de), a
	ret	