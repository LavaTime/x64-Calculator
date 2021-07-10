; Compile with nasm -f elf64 calc.asm
; link with ld -m elf_i386 calc.o -o calc

%include	'functions.asm' ; include external functions file

SECTION .data
	ERR_NUM_ARGS:	db	"Number of arguments should be 3, <operator> <number> <number>", 0xA
	PROGRAM_FINISHED:    db    "Program finished executing. Good Bye!", 0xA

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
;	mov	rax, 4 ; sys_write
;	mov	rbx, 1 ; std_out
;	mov	rcx, PROGRAM_FINISHED ; move pointer to output message
;	mov	rdx, 38 ; string length. : TO-DO calculate length
;	int	0x80 ; kernel interrupt	
	
	mov	rax, ERR_NUM_ARGS
	call	sprint

;	mov	rax, 1 ; sys_exit
;	mov	rbx, 0 ; zero errors
;	int	0x80 ; kernel interrupt
	call	quit

ascii_to_int:
	xor	ax, ax ; xor - not equals, store zero in ax
	xor	cx, cx; xor - not equals, store zero in ax
	mov	bx, 10 ; 10 for base ten, Google convering decimal to binary

err_num_args:
;	mov	rax, 4 ; sys_write
;	mov	rbx, 1 ; std_out
;	mov	rcx, ERR_NUM_ARGS ; move pointer to output message
;	mov	rdx, 62; string length. TO-DO: calculate length
;	int	0x80 ; kernel interrupt

	mov	rax, ERR_NUM_ARGS
	call	sprint

;	mov	rax, 1 ; sys_exit
;	mov	rbx, 1 ; error registery
;	int	0x80 ; kernel interrupt

	call	quit
	
