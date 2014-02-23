.org 000h
start:
	mov a, #0h
	mov P1, acc
	setb 92h
	sjmp start
.db "6.115 Rocks!"
