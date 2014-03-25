; TODO: replace FxE* with the proper address for the 8255

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

	; Choose speed here..
	lcall slow

	; Set up the software count
	mov a, r2
	mov r0, a

	; Start T0I's
	setb tr0
	mov ie, #082h
	loop:
		sjmp loop

#0.5 Hz
slow:
	mov tmod, #001h
	mov r2, #00Eh
	ret

#5000 Hz
fast:
	mov tmod, #002h
	mov th0, #0164h
	mov r2, #001h
	ret

T0ISR:
	djnz r0, exit ; Software count
	mov a, r2
	mov r0, a

	mov a, r1 ; Update Port A
	xrl a, #01h
	mov dptr, #0FE*0
	movx @dptr, a
	mov r1, a

	exit:
		reti
