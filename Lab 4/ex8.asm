.org 0000h
sjmp main

.org 0013h
sjmp IE1ISR

main:
	mov ie, #084h
	mov dptr, #0FE*0h ;ADC
	movx @dptr, a ; Do an (arbitrary) write.

IE1ISR:
	mov  dptr, #0FE20h
	movx a, @dptr
	mov  P1, a
	
	movx @dptr, a
	reti