	dc.l	InitSP
	dc.l	init
	dc.l	BusError
	dc.l	AddressError
	dc.l	IllegalInstr
	dc.l	ZeroDivide
	dc.l	ChkInstr
	dc.l	TrapvInstr
	dc.l	PrivilegeViol
	dc.l	Trace
	dc.l	Line1010Emu
	dc.l	Line1111Emu
	dcb.l	12,0					; Reserved by Motorola
	dc.l	0,		0,		0,		0
	dc.l	HInt,	0,		VInt,	0
	dc.l	ErrorExcept,	ErrorExcept,	ErrorExcept,	ErrorExcept
	dc.l	ErrorExcept,	ErrorExcept,	ErrorExcept,	ErrorExcept
	dc.l	ErrorExcept,	ErrorExcept,	ErrorExcept,	ErrorExcept
	dc.l	ErrorExcept,	ErrorExcept,	ErrorExcept,	ErrorExcept
	dcb.l	16,0					; Reserved by Motorola
	dc.b	'SEGA MEGA DRIVE '		;	SYSTEM
	dc.b	'MDTRAVIS2025.FEB'		;	DATE
	dc.b	'BATTLE TESTING                                  '		;	DOMESTIC TITLE
	dc.b	'BATTLE TESTING                                  '		;	INTERNATIONAL TITLE
	dc.b	'GM 00000000-00',0,0	;	SERIAL
	dc.b	'J               '		;	I/O SUPPORT JOYPAD
	dc.l	$00000000				;	ROM START
	dc.l	$0007FFFF				;	ROM END
	dc.l	$00FF0000				;	RAM START
	dc.l	$00FFFFFF				;	RAM END
	dc.b	'                '
	dc.b	'                '
	dc.b	'                '
	dc.b	'                '
	dc.b	'JUE             '		;	REGION
