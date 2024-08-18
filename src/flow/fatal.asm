A_PART_FATAL_INIT0 	equ A_PART_FATAL
A_PART_FATAL_INIT1 	equ A_PART_FATAL + 3
A_PART_FATAL_INIT2 	equ A_PART_FATAL + 6
A_PART_FATAL_MAIN1 	equ A_PART_FATAL + 9
A_PART_FATAL_MAIN2 	equ A_PART_FATAL + 12

	; part.fatal: depack and initialization
	ld a, P_PART_FATAL : call lib.SetPage
	ld hl, PART_FATAL_PCK
	ld de, A_PART_FATAL
	call lib.Depack

	; part.fatal: main
	call A_PART_FATAL_INIT0
	ld b, 100 : halt : djnz $-1

	call A_PART_FATAL_INIT1
	ld b, 10*4
1	push bc
	call A_PART_FATAL_MAIN1
	halt
	pop bc : djnz 1b

	call A_PART_FATAL_INIT2
	ld b, 15*3
1	push bc
	call A_PART_FATAL_MAIN2
	halt
	pop bc : djnz 1b