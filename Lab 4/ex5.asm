; TODO: replace FxE* with the proper addresses for the 8255 / 8254

.org 0000h
sjmp main

.org 000bh
sjmp T0ISR

.org 0100h
main:
	; Start the timer.
	lcall int_T ; Change to ext_T to use the external timer, int_T to use T0.
	loop:
		sjmp loop

int_T:
	; Load the PWM Duty Cycle (rh) from 2000h
	mov dptr, #2000h
	movx a, @dptr
	mov r0, a

	; Timer counts up...
	mov a, #0FFh
	subb a, r0

	; Save rh
	mov r1, a

	; Now we grab rl
	mov a, #080h ; TODO: recheck if this is 80h or 80d
	subb a, r0
	mov r0, a

	; Timer counts up...
	mov a, #0FFh
	subb a, r0

	; Save rl
	mov r2, a

	; Program the 8225
	mov dptr, #0FE*3h
	mov a, #080h
	movx @dptr, a

	; Start high
	mov dptr, #0FE*0h
	mov a, #001h
	movx @dptr, a

	; Start T0
	mov tmod, #002h
	mov th0, r1
	setb tr0
	mov ie, #082h

	clr c ; Make sure we start low.
	ret

ext_T:
	; TODO write this.
	clr c ; Make sure we start low.
	ret

T0ISR:
	mov dptr, #0FE*0 ; We're going to write into the 8255's Port A either way.
	jnc low
	high:
		mov th0, r1
		mov a, #001h
		movx @dptr, a

		clr c
		reti
	low:
		mov th0, r2
		mov a, #000h
		movx @dptr, a

		setb c
		reti
