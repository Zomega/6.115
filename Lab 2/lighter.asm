.org 0000h
start:
	mov r0, #0010h ; Should be well above the strike range.
	mov r1, #00h
	
	mov dptr,   #0FE03h
	mov a, #03Eh
	movx @dptr, a
	
	mov b, #0010h
	coarse_loop:
		lcall add_b
		lcall set_clk_f
		lcall delay
		lcall get_state
		jnz coarse_loop
	mov b, #0001h
	fine_loop:
		lcall add_b
		lcall set_clk_f
		lcall delay
		lcall get_state
		jz fine_loop
	lit_loop:
		sjmp lit_loop ; Hopefully the lamp is lit!

delay:
	mov r3, #0FFh
	mov r4, #040h
	delay_loop:
		djnz r3, delay_loop
		djnz r4, delay_loop
	ret

set_clk_f:
	mov dptr,   #0FE00h
	mov a, r0
	movx @dptr,  a
	mov a, r1
	movx @dptr,  a
	ret
	
add_b:
	mov a, r0
	add a, b
	mov r0, a
	mov a, r1
	addc a, #0h
	mov r1, a
	ret
	
get_state:
		;mov P1, #001h
		mov a, P1
		anl a, #01h
		ret
		
