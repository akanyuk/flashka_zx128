	device zxspectrum128

	page 0

	; define _DEBUG_ 1
	define _MUSIC_ 1

	; адресa частей
A_PART_ANALYZE  equ #7000	
A_PART_FATAL	equ #7000

	; страницы хранения запакованных частей
	define P_TRACK        3 ; трек и плеер лежат здесь
	define P_PART_FATAL   1
	define P_PART_ANALYZE 1

	org #6000

page0s	module lib
	include "lib/shared.asm"	
	endmodule

	di : ld sp, page0s

	ld a, 7 : out (#fe), a 	
	ld a, %00111000 : call lib.SetScreenAttr
	call lib.ClearScreen

	ifdef _MUSIC_
	ld a, P_TRACK : call lib.SetPage
	call PT3PLAY
	ld a, #01 : ld (MUSIC_STATE), a
	endif

	ld a,#5c : ld i,a : ld hl,interr : ld (#5cff),hl : im 2 : ei

	ld b, 20 : halt : djnz $-1

	call A_PART_LOGO

	ld hl, (INTS_COUNTER) : ld de, 380 : sbc hl, de : jr c, $-8

	xor a : out (#fe), a 	
	call lib.SetScreenAttr

	include "flow/fatal.asm"
	ld hl, (INTS_COUNTER) : ld de, 1152 - 10 : sbc hl, de : jr c, $-8
	include "flow/analyze.asm" ; stop here

	; запуск нужной процедуры на прерываниях
	; HL - адрес процедура
interrStart	ld de, interrCurrent
	ex de, hl
	ld (hl), #c3 ; jp
	inc hl : ld (hl), e
	inc hl : ld (hl), d
	ret

	; остановка процедуры на прерываниях
interrStop	ld hl, interrCurrent
	ld (hl), #c9 ; ret
	ret

interrCurrent	ret
	nop
	nop

interr	di
	push af,bc,de,hl,ix,iy
	exx : ex af, af'
	push af,bc,de,hl,ix,iy
	ifdef _BORDER_ : ld a, #01 : out (#fe), a : endif ; debug

	ifdef _MUSIC_
MUSIC_STATE	equ $+1	
	ld a, #00 : or a : jr z, 1f
	ld a, (lib.CUR_SCREEN) : ld b, a
	ld a, P_TRACK : or b : or %00010000
	ld bc, #7ffd : out (c), a
	call PT3PLAY + 5	
	// Restore page
	ld a, (lib.CUR_SCREEN) : ld b, a 
	ld a, (lib.CUR_PAGE) : or b : or %00010000
	ld bc, #7ffd : out (c), a
1	
	endif

	call interrCurrent
	
	; счетчик интов
INTS_COUNTER	equ $+1
	ld hl, #0000 : inc hl : ld ($-3), hl

	ifdef _BORDER_ : xor a : out (#fe), a : endif ; debug
	pop iy,ix,hl,de,bc,af
	exx : ex af, af'
	pop iy,ix,hl,de,bc,af
	ei
	ret
	display /d, '[page 0] bytes before overlap at #7000: ', #7000 - $

A_PART_LOGO	module part_logo
	include "part.logo/part.logo.asm"
	endmodule
page0e	

	define _page1 : page 1 : org #c000
page1s	
PART_ANALYZ_PCK	incbin "build/part.analyze.bin.zx0"
PART_FATAL_PCK	incbin "build/part.fatal.bin.zx0"
page1e	display /d, '[page 1] free: ', 65536 - $, ' (', $, ')'

	define _page3 : page 3 : org #c000
page3s	
PT3PLAY	include "lib/PTxPlay.asm"
	incbin "res/fatalsnipe - MISTOS.pt3"
page3e	display /d, '[page 3] free: ', 65536 - $, ' (', $, ')'

	include "src/builder.asm"
