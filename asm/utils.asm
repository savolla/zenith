;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	@file:			utils.asm
;;
;;	@author:		savolla
;;
;;  @date:			Edited at 12.04.2020
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	@function:		load_into_memory
;;
;;	@description:	this function reads data from HARD DISK or FLASH DRIVE and puts this
;;                  data into RAM. useful function for loading Kernel into RAM
;;
;;	@parameters:    cl ;; from which sector we want to start reading
;;					al ;; how many sectors we want to read		
;;
;;					(see D.01 for *sector* meaning)
;;                
;;
;;  @example_usage: 
;;                  mov cl, 0x02
;;                  mov al, 0x01
;;					call load_into_memory
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_into_memory:
	pusha								;; save all registers into stack
		mov ah, 0x02					;; preparation (mendatory)

			;; code to read from hard disk
			mov dh, 0x0                 ;; head number (see D.03)
			mov ch, 0x0                 ;; cylinder number (see D.03)
			mov dl, 0x80				;; read from Hard Disk (see D.02)

			;; code to write to RAM
			mov bx, 0x0					;; prepare a value for extra segment (es)
			mov es, bx					;; load extra segment (es) with zero
			mov bx, 0x7c00 + 0x200  	    ;; write data from hdd into address 0x7e00 (see D.04)
		int 0x13						;; execute (mendatory)
	popa								;; restore all registers from stack
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;DOCUMENTATION:
;;
;;D.01: sector is just a 512 byte data. this concept is mostly used in hard disk
;;      like devices. hard disks or flash drives are not like RAM. we cannot read them
;;      byte by byte. so we specify a *sector* instead of *byte*.
;;
;;      sector numbers are also start from 1. which seems awkward from a programmer's 
;;      perspective. our boot sector is always on sector 1.
;;
;;D.02: when reading from hard disk, dl register must be set 0x80. here is a table:
;;
;;      hard drive:  0x80
;;      ssd        : 0x80

;;      floppy disk: 0x00
;;      flash drive: 0x00
;;
;;      fun fact: flash drives actually emulate floppy disks. as you know floppy disks
;;      are obsolete and flash drives are huge floppy disks. this is why CPU thinks a
;;      flash drive is actually a floppy.. we can say the same thing for hdd and ssd where
;;      ssd emulates hdd :)
;;
;;D.03: here is a great article that teaches a lot of hard drive internals and how it
;;      actually works: https://en.wikipedia.org/wiki/Cylinder-head-sector
;;
;;D.04: 0x200 is actually 512 in decimal. so our boot sector was starting on 0x7c00 right?
;;      now we send bx to the bottom of our boot sector and say "hey bx! start loading
;;      that 512 byte long sector which I read from hard disk into memory where you stand!"
;;
;;      we could also put 0x7e00 into bx which is the result of 0x7c00 + 0x200
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
