; Robot arm code. Must read the keypad and control the arm through the 18293 chips.

.org 0000h
sjmp main

.org 0003h
sjmp EXTISR

.org 000bh
sjmp T0ISR

.org 001bh
sjmp T1ISR

.org 0100h
main:
	mov dptr, #0FE*3 ; Set 8225 control bit
	mova a, #083h
	movx @dptr, a

	mov r0, #000h
	mov r1, #000h

	; Intitialize the timers.
	; T0 controls the PWM
	; T1 queries the controller.
	; Both are in mode 2
	mov tmod, #022h
	mov th1, #048h
	mov th0, #09Ch

	mov a, #000h ; Start slow.
	lcall set_PWM_speed

	; Start timers and interrupts. Wheeeeee!!!!!
	setb tr11
	setb tr0
	setb it0
	mov ie, #08Bh

	; Hang forever while everything else happens in interupts.
	loop:
		sjmp loop

; Re-alias for code clarity and reusability.
EXTISR:
	lcall read_keypad
	reti
T0ISR:
	lcall PWM
	reti
T1ISR:
	lcall read_controller
	reti

read_keypad:
	mov dptr, #0FE*2h ; Port C, 8225
	movx a, @dptr
	anl a, #003h ; We only care about the last two bytes.
set_PWM_speed:
	jz set_speed_slow
	cjne a, #002h, set_speed_medium

	set_speed_fast:
		setb 0000h
		ret
	set_speed_medium:
		clr 0000h
		mov r6, #09Ch
		mov r7, #09Ch
		ret
	set_speed_slow:
		clr 0000h
		mov r6, #0CEh
		mov r7, #06Ah
		ret

; Called each time the PWM timer triggers.
; Note that r2 and r3 hold state information on the motor
; See read_controller for details.
PWM:
	jb 0000h, always_on
	jnb 0001h, high

	low:
		mov th0, r5
		clr 0001h
		mov r0, #000h
		mov r1, #000h
		ret
	high:
		mov th0, r7
		setb 0001h
	always_on:
		mov a, r2
		mov r0, a
		mov a, r3
		mov r1, a
		lcall write_arm

write_arm:
	mov dptr, #0FE*0h ; 8225 Port A
	mov a, r0
	movx @dptr, a

	mov dptr, #0FE*2h ; 8225 Port C
	mov a, r1
	movx @dptr, a

	ret

read_controller:
	mov dptr, #0FE*1h ; 8225 Port B

	;CW
	clr p3.4
	setb p3.5
	movx a, @dptr
	mov r2, a

	;CCW
	setb p3.4
	clr  p3.5
	movx a, @dptr

	;Now we make bit salad. See spec sheets.
	rr a
	rr a
	rr a
	mov r3, a

	; Set r2 finally
	anl a, #0E0h
	add a, r2
	mov r2, a

	; Set r3 finally
	mov a, r3
	anl a, #03h
	rr a
	rr a
	rr a
	rr a
	mov r3, a

	ret