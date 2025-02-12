InitTXT	macro	src,end,x,y
	lea		src,	a0
	lea		VDPDATA,a1
	move.l	#(end-src)-1,	d0
	move.l	#$40000002+(x*$20000)+(y*$800000),(VDPCTRL)
	moveq	#0,	d1
	jsr		loadASCII2
	endm