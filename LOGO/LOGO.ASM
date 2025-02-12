oddF	=	$42000003
evenF	=	$52000003
LOGO_VRAMDec	=	$FF0000
LOGO_VRAMArt	=	$FF08C0
LOGO_FrameNum	=	$FFE000
LOGO_Parity		=	$FFE006
;-------------------------------------------------------
LOGO:
;	move.b	#$80,v_snddriver_ram+f_pausemusic
;	move.w  #$E4,d0
;	jsr     PlayFMSound

	jsr		InitVDP
;	move.w	#$8C70,VDPCTRL
	move.w	#$9011,VDPCTRL
	
	move.l	#0,	d0
	move.l	d0,	hscroll
	move.l	d0,	LOGO_VRAMDec
	move.l	d0,	LOGO_VRAMArt
	move.l	d0,	LOGO_FrameNum
	move.l	d0,	LOGO_Parity
	
	move.w	#$E0,	d1
	lea		hscroll,	a0
@clrRAM:
	move.l	d0,	(a0)+
	dbf		d1,	@clrRAM
	
;	move.l	#$10,d1
;	lea		palette,a0
;@clrPal:
;	move.l	d0,(a0)+
;	dbf		d1,@clrPal
	
;	move.l	#$A0,d1
;	lea		sprites,a0
;@clrSpr:
;	move.l	d0,(a0)+
;	dbf		d1,@clrSpr
	
;	moveq	#0,d0				; Load palette into both palette buffers
;	jsr		LoadPalette

	move.l	#(LOGOPAL_END-LOGOPAL)/4,d1
	lea		palette,a0
	lea		LOGOPAL,a1
@loadPal:
	move.l	(a1)+,(a0)+
	dbf		d1,@loadPal
	
	move.b  #4,VBLANKCMD.w		; VSync
	jsr		VSync
	move.l	#LOGOTable,LOGO_FrameNum

;-------------------------------------------------------

LOOPLOGO:
;ODDSET
	move.b  #4,VBLANKCMD.w
	jsr		VSync
;	btst  	#bitStart,	p1CtrlData
;	bne.w	@skip
	lea		LOGO_FrameNum,a2	;	grab the art & map
	move.l	(a2),a2
	move.l	(a2),a0
	cmpi.w	#-1,a0		;	skip at end
	beq.w	@scream		;	^
	lea		LOGO_VRAMDec,a1
	jsr		KosPlusDec
	addi.w	#4,	LOGO_FrameNum+2
	tst.b	LOGO_Parity
	bne.s	@even
	LVLDMA	LOGO_VRAMArt,$0000,$1B20,VRAM	;	copy it to VRAM
	lea     LOGO_VRAMDec,a1 ; Load mappings
	move.l  #oddF,d0
	move.w  #40-1,d1
	move.w  #28-1,d2
	jsr   DrawTileMap
	move.w	#$0000,vscrollScreen
	move.b	#1,LOGO_Parity
	bra.w	LOOPLOGO
@even:
	LVLDMA	LOGO_VRAMArt,$8000,$1B20,VRAM	;	copy it to VRAM
	lea     LOGO_VRAMDec,a1 ; Load mappings
	move.l  #evenF,d0
	move.w  #40-1,d1
	move.w  #28-1,d2
	jsr   DrawTileMap
	move.w	#$0100,vscrollScreen
	move.b	#0,LOGO_Parity
	bra.w	LOOPLOGO
@scream:
	bra.s	@scream
;	move.w	#120,vintTimer
;	move.w  #$E1,d0
;	jsr     PlayFMSound
;@loop
;;	move.b  #4,VBLANKCMD.w
;	jsr		VSync
;;	btst  	#bitStart,	p1CtrlData
;	bne.w	@skip
;	tst.w	vintTimer
;	bne.s	@loop
;@skip:
;	move.w  #$E0,d0
;	jsr     PlayFMSound
;	moveq	#0,	d1
;	move.w	#$800,	d0
;	lea		$FF0000,	a0
;@clrRAM:
;	move.l	d1,	(a0)+
;	dbf		d0,	@clrRAM
;;	jsr		FadeToBlack
;;	jsr		SHC
;;	move.b	#GM_TITLE,gameMode.w	;	set game mode to title screen
	rts
	
LOGOTable:
	DC.L	S1_FRM01,	S1_FRM02,	S1_FRM03,	S1_FRM04,	S1_FRM05
	DC.L	S1_FRM06,	S1_FRM07,	S1_FRM08,	S1_FRM09,	S1_FRM10
	DC.L	S1_FRM11,	S1_FRM12,	S1_FRM13,	S1_FRM14,	S1_FRM15
	DC.L	S1_FRM16,	S1_FRM17,	S1_FRM18,	S1_FRM19,	S1_FRM20
	DC.L	S1_FRM21,	S1_FRM22,	S1_FRM23
	DC.L	-1
LOGOPAL:	INCBIN	"LOGO/LOGOPAL.PAL"
	LOGOPAL_END:
S1_FRM01:	INCBIN	"LOGO/S1_FRM01.KOSP"
S1_FRM02:	INCBIN	"LOGO/S1_FRM02.KOSP"
S1_FRM03:	INCBIN	"LOGO/S1_FRM03.KOSP"
S1_FRM04:	INCBIN	"LOGO/S1_FRM04.KOSP"
S1_FRM05:	INCBIN	"LOGO/S1_FRM05.KOSP"
S1_FRM06:	INCBIN	"LOGO/S1_FRM06.KOSP"
S1_FRM07:	INCBIN	"LOGO/S1_FRM07.KOSP"
S1_FRM08:	INCBIN	"LOGO/S1_FRM08.KOSP"
S1_FRM09:	INCBIN	"LOGO/S1_FRM09.KOSP"
S1_FRM10:	INCBIN	"LOGO/S1_FRM10.KOSP"
S1_FRM11:	INCBIN	"LOGO/S1_FRM11.KOSP"
S1_FRM12:	INCBIN	"LOGO/S1_FRM12.KOSP"
S1_FRM13:	INCBIN	"LOGO/S1_FRM13.KOSP"
S1_FRM14:	INCBIN	"LOGO/S1_FRM14.KOSP"
S1_FRM15:	INCBIN	"LOGO/S1_FRM15.KOSP"
S1_FRM16:	INCBIN	"LOGO/S1_FRM16.KOSP"
S1_FRM17:	INCBIN	"LOGO/S1_FRM17.KOSP"
S1_FRM18:	INCBIN	"LOGO/S1_FRM18.KOSP"
S1_FRM19:	INCBIN	"LOGO/S1_FRM19.KOSP"
S1_FRM20:	INCBIN	"LOGO/S1_FRM20.KOSP"
S1_FRM21:	INCBIN	"LOGO/S1_FRM21.KOSP"
S1_FRM22:	INCBIN	"LOGO/S1_FRM22.KOSP"
S1_FRM23:	INCBIN	"LOGO/S1_FRM23.KOSP"