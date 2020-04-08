;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	@file:			utils.asm
;;
;;	@author: 		Oleksiy Nehlyadyuk
;;
;;  @date:			Edited at 07.04.2020
;;
;;	@desciption:	this file contains various utility functions
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	@function:		print
;;
;;	@description:	prints character or set of characters on the tty. it is a BIOS level
;;					function that interrupts x86 CPU directly without kernel
;;
;;	@parameters:	'print' assumes that an address of string or character is already
;;					loaded inside bx register
;;
;;  @example_usage:
;;   				message:
;;   					db "hello, world", 0x0
;;   				
;;   				mov bx, message
;;   				call print
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print:
	pusha							;; save all previous registers
	mov ah, 0x0e					;; init tty mode and prepare to print

	BEGIN_print:
	
		mov al, [bx]				;; read @parameters to dig
		cmp al, 0x0					;; is al a null byte?
		je END_print				;; if so goto END_FUNCTION
	
		int 0x10					;; else print al
		inc bx						;; make bx to point next character
		jmp BEGIN_print

	END_print:
		popa						;; restor all registers
		ret							;; return 0;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	@function:		print_nl
;;
;;	@description:	same as "print" but puts a new line at the end
;;
;;	@parameters:	see "print"'s @parameters (above)
;;
;;  @example_usage: see "print"'s @example_usage (above)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_nl:
	pusha							;; save all previous registers
	mov ah, 0x0e					;; init tty mode and prepare to print

	BEGIN_print_nl:
	
		mov al, [bx]				;; read @parameters to dig
		cmp al, 0x0					;; does al contain null byte?
		je END_print_nl				;; if so goto END_FUNCTION
	
		int 0x10					;; else print al
		inc bx						;; make bx to point next character
		jmp BEGIN_print_nl

	END_print_nl:
		mov al, 0x0a				;; print("\n");
		int 0x10

		mov al, 0x0d				;; print("\r");
		int 0x10

		popa						;; restor all registers
		ret							;; return 0;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	@function:		get_one_line_input
;;
;;	@description:	gets one line input like username or password. finishes when ENTER 
;;					key is pressed
;;
;;	@parameters:	
;;
;;  @example_usage: 
;;					call get_one_line_input
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_one_line_input:
	
	pusha

	BEGIN_get_one_line_input:
		mov ah, 0x0						;; prepare to read
		int 0x16						;; read keystroke	
										;; input char is stored in al
		
		cmp al, 0x0d					;; did user press ENTER key?
		je END_get_input				;; if so, one line input has ended

		mov ah, 0x0e					;; init tty mode and prepare to print
		int 0x10						;; print what's inside the al
		jmp BEGIN_get_one_line_input	;; continue to get input and print

	END_get_input:
		mov ah, 0x0e					;; prepare to print

		mov al, 0x0a					;; al = '\n'
		int 0x10						;; print( al );
		mov al, 0x0d					;; al = '\r'
		int 0x10						;; print( al );

		popa							;; restore all registers
		ret								;; return 0;
