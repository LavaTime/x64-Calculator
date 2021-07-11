; Compile with nasm -f elf64 calc.asm
; link with ld -m elf_i386 calc.o -o calc

%include	'functions.asm' ; include external functions file

SECTION .data
	ERR_NUM_ARGS:	db	"Number of arguments should be 3, <operator> <number> <number>", 0xA, 0x0
	PROGRAM_FINISHED:    db    "Program finished executing. Good Bye!", 0xA, 0x0
	ERR_INVALID_OPERATOR:	db	"Invalid operator", 0xA, 0x0
	ERR_INVALID_OPERAND:	db	"Invalid operand", 0xA, 0x0
	BYTE_BUFFER:	times	10	db	0 ; size 10, holds value 0

SECTION .text
global _start

_start:
	pop	rdx ; put number of arguments into rdx registery
	cmp	rdx, 4 ; compare number of arguments to 4
	jne	err_num_args ; if zero flag false go to error block err_num_args

	add	rsp, 8 ; skip 8 bytes (4 characters) of the program name
	pop	rsi ; pop the first argument argv[1] into rsi
	cmp	byte[rsi], 0x2B ; compare the byte (character) in rsi to the hex value of "+"
	je	addition ; jump to 'addition' subroutine.

	cmp	byte[rsi], 0x78 ; compare the byte (character in rsi to the hex value of "x"
	je	multiplication ; jump to 'multiplication' subroutine.
	cmp	byte[rsi], 0x2A ; compare the byte (character) in rsi to the hex value of "*"
	je	multiplication ; jump to 'multiplication' subroutine.
	cmp	byte[rsi], 0x58 ; compare the byte (character) in rsi to the hex value of "X"
	je	multiplication ; jump to 'multiplication' subroutine.

	cmp	byte[rsi], 0x2D ; compare the byte (character) in rsi to the hex value of "-"
	je	substraction ; jump to 'substraction' subroutine.

	cmp	byte[rsi], 0x2F ; compare the byte (character) in rsi to the hex value of "/"
	je	division ; jump to 'division' subroutine.

	cmp	byte[rsi], 0x25 ; compare the byte (character) in rsi to the hex value of "%"
	je	modulo ; jump to 'modulo' subroutine.

	jmp	finally ; exit

addition:
	pop	rsi ; pop next argument
	

substraction:
	pop	rsi ; pop next argument
	

multiplication:
	pop	rsi ; pop next argument
	

division:
	pop	rsi ; pop next argument
	

modulo:
	pop	rsi ; pop next argument
	

finally:	
	mov	rax, PROGRAM_FINISHED
	call	sprint

	jmp	quit

ascii_to_int:
	xor	ax, ax ; xor - not equals, store zero in ax
	xor	cx, cx; xor - not equals, store zero in ax
	mov	bx, 10 ; 10 for base ten, Google convering decimal to binary

.loop_block:
	
	mov	cl, [rsi] ; move cl pointer to [index] rsi
	cmp	cl, byte 0 ; if charcater is (NULL) break loop
	je	.return_block ; jmp to .return_block

	cmp	cl, 0x30 ; check if current digit is less than 0
	jl	err_invalid_operand
	cmp	cl, 0x39 ; check if current digit is more than 9
	jg	err_invalid_operand

	sub	cl, 48 ; ASCII 48 is '0' substracting 48 gives us the value
	
	mul	bx ; multiple ax by bx (10) to shift the decimal point place

	add	ax, cx ; add the current digit to ax
	
	inc	rsi ; increment rsi index

	jmp	.loop_block

.return_block:
	ret

int_to_ascii:
	mov	rbx, 10 ; we have memory to store result
	mov	r9, BYTE_BUFFER+10 ; store the number in reverse
	mov	[r9], byte 0 ; null byte to terminate
	dec	r9
	mov	[r9], byte 0xA ; line break \n
	dec	r9
	mov	r11, 2 ; store the number of bytes we added to string for sys_write

.loop_block:
	mov	rdx, 0	
	div	rbx ; divide rbx by rax (10) to get LSB (least sagnificant digit), remainder in 'dl'
	cmp	rax, 0 ; check if hit MSB (most sagnificant digit)
	je	.return_block
	
	add	dl, 48 ; ASCII value of digit is 48 more than digit
	mov	[r9], dl ; mov ASCII value into r9 slot
	dec	r9 ; decrement pointer to next slot
	inc	r11 ; increment string size
	jmp	.loop_block

.return_block:
	add	dl, 48 ; do same procedure for MSB
	mov	[r9], dl ; mov ASCII value into r9 slot
	dec	r9 ; decrement pointer to next slot
	inc	r11 ; increment string size
	ret ; return control flow

err_num_args:
	mov	rax, ERR_NUM_ARGS
	call	sprint

	call	quit

err_invalid_operand:
	mov	rax, ERR_INVALID_OPERAND
	call	sprint

	call	quit

quit:
	mov	rax, 1 ; sys_exit
	mov	rbx, 0 ; zero errors
	int	0x80 ; kernel interrupt
