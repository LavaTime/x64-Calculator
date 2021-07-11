strlen: ; string length calculation function declaration
        push    rbx ; push rbx to the stack to preserve it
        mov     rbx, rax ; point both pointers to the start of the string

nextchar:
        cmp     byte[eax], 0 ; check if string ended
        jz      finished_length ; if zero flag jump to finished_length
        inc     rax ; increment rax location by one
        jmp nextchar ; loop back

finished_length:
        sub     rax, rbx ; substract the locations of rax, and rbx
        pop     rbx ; put back preserved rbx
        ret     ; return control to call


sprint: ; string printing function declaration
	push	rdx
	push	rcx
	push	rbx
	push	rax ; preserve all of these registers
	call	strlen ; jump to string length calculation

	mov	rdx, rax ; move the result of strlen to the print length register (rdx)
	pop	rax ; put into rax the pointer to the word to print

	mov	rcx, rax ; move preserved pointer of string to rcx
	mov	rax, 4 ; sys_write
	mov	rbx, 1 ; std_out
	int	0x80 ; kernel interrupt

	pop	rbx
	pop	rcx
	pop	rdx
	ret ; pop preserved values and return control to call
