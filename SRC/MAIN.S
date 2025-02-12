	include		"Debugger.asm"
	include		"src/system/macros.i"
	include		"src/system/equates.i"
	include		"src/system/vectors.s"
	include		"src/system/interrupt.s"
ascii:
	incbin		"src/ascii.art"
	ascii_end:
hexa:
	incbin		"src/hex.art"
	hex_end:
	
init:
	move.w	#$8000+%00000100,(VDPCTRL)		;	MODE REGISTER 1
	move.w	#$8100+%01110100,(VDPCTRL)      ;	MODE REGISTER 2
	move.w	#$8200+(PLANE_A>>10),(VDPCTRL)  ;	PLANE A LOCATION
	move.w	#$8300+(PLANE_W>>10),(VDPCTRL)  ;	PLANE W LOCATION
	move.w	#$8400+(PLANE_B>>13),(VDPCTRL)  ;	PLANE B LOCATION
	move.w	#$8500+%01111100,(VDPCTRL)      ;	SPRITE TABLE LOCATION
	move.w	#$8600+%00000000,(VDPCTRL)      ;	
	move.w	#$8700+%00000000,(VDPCTRL)      ;	BACKGROUND COLOR
	move.w	#$8800+%00000000,(VDPCTRL)      ;	MASTER SYSTEM H-SCROLL
	move.w	#$8900+%00000000,(VDPCTRL)      ;	MASTER SYSTEM V-SCROLL
	move.w	#$8A00+%00000000,(VDPCTRL)      ;	H-INT COUNTER
	move.w	#$8B00+%00000000,(VDPCTRL)      ;	MODE REGISTER 3
	move.w	#$8C00+%10000001,(VDPCTRL)      ;	MODE REGISTER 4
	move.w	#$8D00+%00111111,(VDPCTRL)      ;	H-SCROLL DATA LOCATION
	move.w	#$8E00+%00000000,(VDPCTRL)      ;	
	move.w	#$8F00+%00000010,(VDPCTRL)      ;	AUTO-INCREMENT VALUE
	move.w	#$9000+%00000001,(VDPCTRL)      ;	PLANE SIZE
	move.w	#$9100+%00000000,(VDPCTRL)      ;	WINDOW PLANE HORIZONTAL
	move.w	#$9200+%00000000,(VDPCTRL)      ;	WINDOW PLANE VERTICAL
	
;	move.l	#CRAMWRITE,(VDPCTRL)
	move.w	#$E0,palette
	
	lea		ascii,	a0
	lea		VDPDATA,a1
	move.l	#(ascii_end-ascii)/4-1,	d0
	move.l	#VRAMWRITE+$4000000,(VDPCTRL)
@loadASCII1
	move.l	(a0)+,(a1)
	dbf		d0,	@loadASCII1
	lea		hexa,	a0
	lea		VDPDATA,a1
	move.l	#(hex_end-hexa)/4-1,	d0
	move.l	#VRAMWRITE+1,(VDPCTRL)
@loadhex1
	move.l	(a0)+,(a1)
	dbf		d0,	@loadhex1
	
	InitTXT	ASCIITXT1,ASCIITXT1_END,1,1
	InitTXT	ASCIITXT3,ASCIITXT3_END,1,3
	InitTXT	ASCIITXT2,ASCIITXT2_END,1,26
	
	jsr		INITJOYPADS	;	init controller
	move	#$2300,sr
	
	move.l	#CRAMWRITE,(VDPCTRL)
	move.l	#$0EEE,VDPDATA
	move.w	#$0444,VDPDATA
	
@loop:
	MOVE.B	#1,	(VBLANKCMD).W
	jsr		VSync
	btst	#bitStart,	JOYPADPRESS
	bne.w	@action
	bra.w	@loop
	
@action
	jmp		LOGO
	bra.w	@loop
	
ASCIITXT1:	dc.b	'MD-FMV'
	ASCIITXT1_END:	even
ASCIITXT2:	dc.b	'CREATED BY MDTRAVIS '
	ASCIITXT2_END:	even
ASCIITXT3:	dc.b	'PRESS START'
	ASCIITXT3_END:	even

loadASCII2
@loop
	move.b	(a0)+,d1
	move.w	d1,	(a1)
	dbf		d0,	@loop
	rts
	
DispHex
;	btst	#7,	HEXADDR
;	beq.s	@cont
;	and.b	#$7F, HEXADDR
;.cont
	moveq	#0,	d0
	moveq	#0,	d1
	move.b	HEXADDR,	d1
	bsr.w	WordToBcd
	move.w	d1,	HEXADDR+2

	moveq	#0,	d0
	move.b	HEXADDR,	d0
	and.b	#$0F,	d0
	add.w	#$200,	d0
	move.l	#$459A0002,(VDPCTRL)
	move.w	d0,	VDPDATA
	
	moveq	#0,	d0
	move.b	HEXADDR,	d0
	and.b	#$F0,	d0
	ror.b	#4,		d0
	add.w	#$200,	d0
	move.l	#$45980002,(VDPCTRL)
	move.w	d0,	VDPDATA

	moveq	#0,	d0
	move.b	HEXADDR+2,	d0
	and.b	#$0F,	d0
	add.w	#$200,	d0
	move.l	#$46180002,(VDPCTRL)
	move.w	d0,	VDPDATA
	
	moveq	#0,	d0
	move.b	HEXADDR+3,	d0
	and.b	#$F0,	d0
	ror.b	#4,		d0
	add.w	#$200,	d0
	move.l	#$461A0002,(VDPCTRL)
	move.w	d0,	VDPDATA

	moveq	#0,	d0
	move.b	HEXADDR+3,	d0
	and.b	#$0F,	d0
	add.w	#$200,	d0
	move.l	#$461C0002,(VDPCTRL)
	move.w	d0,	VDPDATA
	rts
	
; vvv Code from MD-SONIC, disassembled by KatKuriN vvv
VSync:
	move	#$2300,sr			; Enable interrupts

.Wait:
	tst.b	VBLANKCMD.w			; Has the V-INT routine run?
	bne.s	.Wait				; If not, wait for it to
	
	rts                          ; End of subroutine
	
	include		"SRC/SYSTEM/JOYPAD.S"
	
; vvv Code by Devon vvv
; ----------------------------------------------------------------------
; Convert word to BCD format
; ----------------------------------------------------------------------
; PARAMETERS:
;    d1.w - Number to convert
; RETURNS:
;    d1.w - Converted number
; ----------------------------------------------------------------------

WordToBcd:
    move.w    d0,-(sp)                ; Save d0
    
    andi.l    #$FFFF,d1                ; Get 1st digit
    divu.w    #10,d1
    swap    d1
    move.w    d1,d0
    clr.w    d1
    swap    d1
    
    divu.w    #10,d1                    ; Get 2nd digit
    swap    d1
    lsl.w    #4,d1
    add.w    d1,d0
    clr.w    d1
    swap    d1
    
    divu.w    #10,d1                    ; Get 3rd digit
    swap    d1
    move.b    d1,-(sp)
    clr.b    1(sp)
    add.w    (sp)+,d0
    clr.w    d1
    swap    d1
    
    divu.w    #10,d1                    ; Get 4th digit
    swap    d1
    move.b    d1,-(sp)
    move.w    (sp)+,d1
    clr.b    d1
    lsl.w    #4,d1
    add.w    d1,d0
    
    move.w    d0,d1                    ; Get result
    move.w    (sp)+,d0                ; Restore d0
    rts
	
; vvv Code from MD-SONIC, disassembled by KatKuriN vvv
DrawTileMap:
	lea	VDPDATA,a6			; Prepare VDP data
	move.l	#$800000,d4			; VDP command line delta

.RowLoop:
	move.l	d0,4(a6)			; Set VDP command
	move.w	d1,d3				; Prepare row width

.TileLoop:
	move.w	(a1)+,(a6)			; Copy tile data
	dbf	d3,.TileLoop			; Loop until row is drawn

	add.l	d4,d0				; Next row
	dbf	d2,.RowLoop			; Loop until tilemap is drawn
	rts
	
			INCLUDE	"SRC/Kosinski Plus Decompression.asm"
			INCLUDE	"SRC/DMA Queue.asm"
; vvv Code from MD-SONIC, disassembled by KatKuriN vvv	
InitVDP:
	lea	VDPCTRL,a0			; Get VDP ports
	lea	VDPDATA,a1

	lea	VDPInitRegs,a2			; Prepare VDP registers
	moveq	#$13-1,d7

.InitRegs:
	move.w	(a2)+,(a0)			; Set VDP register
	dbf	d7,.InitRegs			; Loop until finished

	move.w	VDPInitReg1,d0			; Set VDP register 1
	move.w	d0,vdpReg01.w
	move.w	#$8ADF,vdpReg0A.w		; Set H-INT counter

	moveq	#0,d0				; Clear CRAM
	move.l	#$C0000000,VDPCTRL
	move.w	#$3F,d7

.ClearCRAM:
	move.w	d0,(a1)
	dbf	d7,.ClearCRAM			; Loop until finished

	clr.l	vscrollScreen.w			; Clear scroll values
	clr.l	hscrollScreen.w

	move.l	d1,-(sp)			; Clear VRAM via DMA fill
	lea	VDPCTRL,a5
	move.w	#$8F01,(a5)
	move.l	#$94FF93FF,(a5)
	move.w	#$9780,(a5)
	move.l	#$40000080,(a5)
	move.w	#0,VDPDATA

.WaitVRAMClear:
	move.w	(a5),d1
	btst	#1,d1
	bne.s	.WaitVRAMClear
	move.w	#$8F02,(a5)
	move.l	(sp)+,d1

	rts

; -------------------------------------------------------------------------

VDPInitRegs:
	dc.w	$8004				; H-INT disabled
VDPInitReg1:
	dc.w	$8174				; DMA and V-INT enabled, display disabled
	dc.w	$8230				; Plane A at $C000
	dc.w	$8328				; Window plane at $A000
	dc.w	$8407				; Plane B at $E000
	dc.w	$857C				; Sprite table at $F800
	dc.w	$8600				; Unused
	dc.w	$8720				; Background color at line 0 color 0
	dc.w	$8800				; Unused
	dc.w	$8900				; Unused
	dc.w	$8ADF				; H-INT counter 0
	dc.w	$8B03				; HScroll by screen, VScroll by screen
	dc.w	$8C81				; H40 mode
	dc.w	$8D3F				; HScroll at $FC00
	dc.w	$8E00				; Unused
	dc.w	$8F02				; Auto-increment by 2
	dc.w	$9001				; Plane size 64x32
	dc.w	$9100				; Window X at 0
	dc.w	$9200				; Window Y at 0
			
	include		"LOGO/LOGO.ASM"
	
	include		"ErrorHandler.asm"