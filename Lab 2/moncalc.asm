; We need to load our values from 9000 and 9001 into r0 and r1. To do this, we need to use movx.

mov dptr, #9000h
movx a, @dptr
mov r0, a

mov dptr, #9001h
movx a, @dptr
mov r1, a

; ADD
mov   a, r0
add   a, r1  ; add the first value to r1 in acc
mov   b, #0h
mov   dptr, #9002h
acall saveab ; Notice that acall is used rather than lcall.

; SUB
mov   a, r0
subb  a, r1
mov   b, #0h
mov   dptr, #9004h
acall saveab

; MUL
mov   a, r0 ; reload a with r0
mov   b, r1 ; set up b with r1
mul   ab ; mutiply the two numbers
mov   dptr, #9006h
acall saveab

; DIV
mov   a, r0 ; again set up a with r0
mov   b, r1 ; set up b with r1
div   ab ; divide a by b
mov   dptr, #9008h
acall saveab

; RESET
ljmp 0h ; jump back to MinMon

saveab:
  movx @dptr, a
  inc dptr
  mov a, b
  movx @dptr, a
  ret
  