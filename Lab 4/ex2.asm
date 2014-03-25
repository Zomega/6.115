; TODO: replace FE* with the proper address for the 8255

.org 0000h
sjmp main

.org 000bh
sjmp T0ISR

.org 0100h
main:
	; Program the 8225
	mov dptr, #0FE*3h
	mov a, #080h
	movx @dptr, a

	; Clear Port A
	mov dptr, #0FE*0h
	mov a, #000h
	movx @dptr, a

	; Initialize the Port A counter...
	mov r1, #000h

	; Set up Timer 0
	mov tmod, #01h
	mov r0, #046h # Software timing count.
	setb tr0
	mov ie, #082h
	loop:
		sjmp loop

T0ISR:
	djnz r0, exit ; Software count
	mov r0, #046h

	mov a, r1 ; Update Port A
	xrl a, #01h
	mov dptr, #0FE*0
	movx @dptr, a
	mov r1, a

	exit:
		reti
