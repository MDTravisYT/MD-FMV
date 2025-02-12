InitTXT	macro	src,end,x,y
	lea		src,	a0
	lea		VDPDATA,a1
	move.l	#(end-src)-1,	d0
	move.l	#$40000002+(x*$20000)+(y*$800000),(VDPCTRL)
	moveq	#0,	d1
	jsr		loadASCII2
	endm
	
LVLDMA macro src, dest, len, type
	lea	VDPCTRL,a5
	move.l	#$94009300|((((\len)/2)&$FF00)<<8)|(((\len)/2)&$FF),(a5)
	move.l	#$96009500|((((\src)/2)&$FF00)<<8)|(((\src)/2)&$FF),(a5)
	move.w	#$9700|(((\src)>>17)&$7F),(a5)
	VDPCMD	move.w,\dest,\type,DMA,>>16,(a5)
	VDPCMD	move.w,\dest,\type,DMA,&$FFFF,dmaCmdLow.w
	move.w	dmaCmdLow.w,(a5)
	endm
	
VDPCMD macro ins, addr, type, rwd, end, end2
	local	cmd
cmd	= (\type\\rwd\)|(((\addr)&$3FFF)<<16)|((\addr)/$4000)
	if narg=5
		\ins	#\#cmd,\end
	elseif narg>=6
		\ins	#(\#cmd)\end,\end2
	else
		\ins	cmd
	endif
	endm