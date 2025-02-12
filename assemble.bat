echo %date% %time% > time.txt

IF NOT EXIST OUT MKDIR OUT
asm68k /k /m /o ws+ /o op+ /o os+ /o ow+ /o oz+ /o oaq+ /o osq+ /o omq+ /o ae- /o v+ /o c+ /p /e __DEBUG__=1 SRC/MAIN.S, OUT/MD-FMV.BIN >OUT/MD-FMV.LOG, OUT/MD-FMV.SYM, OUT/MD-FMV.LST
convsym OUT/MD-FMV.SYM OUT/MD-FMV.BIN -a

del time.txt