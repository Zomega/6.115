mov dptr, #9000h
movx a, @dptr
mov r0, a
mov dptr, #9001h
movx a, @dptr
mov r1, a
; Store the reset value in  dptr
mov dpl, r0
mov dph, r1
start:
	cpl P1.0
	mov r0, dpl
	mov r1, dph
	sjmp wait_l
	wait_h:
		mov r0, #0ffh
		wait_l:
			djnz r0, wait_l
		djnz r1, wait_h
	sjmp start
