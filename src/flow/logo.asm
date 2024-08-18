A_PART_LOGO_INIT 	equ A_PART_LOGO
; A_PART_LOGO_MAIN 	equ A_PART_LOGO + 3

	xor a : call lib.SetScreenAttr
	call A_PART_LOGO_INIT
	ld b, 200 : halt : djnz $-1
