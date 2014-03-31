; SPINDUDE

.org 0000h
ljmp main

.org 0100h

main:
	mov tmod, #020h
	mov tcon, #040h
	mov th1, #0253h ; 9600
	mov scon, #050h

	movx #0FE*3h ; 8225 Control
	mov a, #080h
	movx @dptr, a

	mov r6, #0B4h
	mov r7, #000h

	loop:
		lcall getchr ; Press any key to continue. Needs to be the right key though. ;P
		lcall sndchr

		lcall get_parameters
		lcall run_rotation

		sjmp loop

get_parameters:
	push acc ; Save a copy, we'll need it later.
	rl a
	rl a
	rlc a ; The 6th bit should be in c
	mov 0000h, c
	pop acc
	anl a, #01Fh ; The low bits now...
	mov r2, a
	mov r3, a
	TODO
	ret

positions:
	.db #00Eh, #00Bh, #00Dh, #007h

run_rotation:
	mov r0, #024h
	mov r1, #000h
	rot_loop:
		mov dptr, #positions
		mov a, r1
		mov b, #004
		div ab
		mov a, b # Work r1 mod 4
		movc a, @a+dptr

		mov dptr, #0FE*0h ; 8225 Port A
		movx @dptr, a
		jb 0000h rot_ccw
		rot_cw:
			dec r1
			sjmp rot_stall
		rot_ccw:
			inc r1
		rot_stall:
			djnz r7, rot_stall
			djnz r6, rot_stall
			mov r6, #0B4h
			djnz r2, rot_stall
			mov a, r3
			mov r2, a
			djnz r0, rot_loop
			ret

;Copied from MODMON

;===============================================================
; subroutine sndchr
; this routine takes the chr in the acc and sends it out the
; serial port.
;===============================================================
sndchr:
   clr  scon.1            ; clear the tx  buffer full flag.
   mov  sbuf,a            ; put chr in sbuf
txloop:
   jnb  scon.1, txloop    ; wait till chr is sent
   ret
;===============================================================
; subroutine getchr
; this routine reads in a chr from the serial port and saves it
; in the accumulator.
;===============================================================
getchr:
   jnb  ri, getchr        ; wait till character received
   mov  a,  sbuf          ; get character
   anl  a,  #7fh          ; mask off 8th bit
   clr  ri                ; clear serial status bit
   ret