.org 0000h
ljmp main
.org 000Bh
T0ISR:
	cpl P1.0
	reti
.org 0100h
main:
	mov  tmod, #002h
	mov  th0,  #000h
	mov  tl0,  #001h
	setb tr0
	mov  ie,   #082h
	loop: sjmp loop
