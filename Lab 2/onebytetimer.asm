mov dptr, #9000h
movx a, @dptr
mov r0, a
start:
	cpl P1.0
	mov a, r0
	mov r1, a
	wait:
		djnz r1, wait
	sjmp start
