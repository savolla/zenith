;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  @file:			login-screen.asm
;;
;;  @author:		savolla
;;
;;  @date:			Edited at 12.04.2020
;;
;;  @desciption:	creates a simple tty logic screen where user enters his username and
;;					password.
;;					
;;  @warning:		this is just a hello world code. things	will get more clear when I
;;					start to write a kernel. this code runs on boot sector. which is so
;;					ridiculous :D
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[org 0x7c00]						;; magic number. see: D.01

;; load_from_disk();
mov cl, 0x02						;; p0: from which sector we want to start reading
mov al, 0x05                        ;; p1: how many sectors to read
call load_into_memory				;; execute

call main

jmp $								;; think like system("pause"). see: D.02

%include "utils.asm"				;; includes useful utility functions from utils.asm

 
str_username: db "name: ", 0x0
str_password: db "key : ", 0x0
second_sector_message:
	db "hello from second sector", 0x0


times 510 - ( $ - $$ ) db 0x0		;; padding with zeros to make file 512 bytes
dw 0xaa55							;; end of boot sector. (see D.03)
;; END OF BOOT SECTOR !!

banner: 
	db "   __", 0x0a, 0x0d, "  / /  ___ ___ ___  _____ ____", 0x0a, 0x0d, " / _ \/ _ `/ // / |/ / _ `/ _ \", 0x0a, 0x0d, "/_//_/\_,_/\_, /|___/\_,_/_//_/", 0x0a, 0x0d, "          /___/", 0x0a, 0x0d, 0x0

main:
	;; print( banner );
	mov bx, banner						;; load bx with address of str_welcome variable
	call print_nl						;; print str_welcome to the tty

	;; print( "name:" );
	mov bx, str_username				;; load bx with string's address 
	call print							;; execute

	;; input()
	call get_one_line_input				;; execute

	;; print( "key:" );
	mov bx, str_password				;; p0: load bx with string's address
	call print							;; execute

	;; input()
	call get_one_line_input				;; let user to input his/her password

	jmp $

times 2560 db 0x0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;DOCUMENTATION
;;
;;D.01: 0x7c00 is a special address in x86 architecture. it represents a boot sector
;;      starting point. our code will be placed into memory after this address when you
;;      press power button of the PC
;;		
;;D.02: this is special for nasm (netwide assembler). '$' symbol represents the "current
;; 		address". it jumps to current address infinitelly. a dirty way to pausing 
;;		execution. you can also do:
;;
;;      loop:
;;      	jmp loop
;;
;;D.03: this two byte value represents "end of a boot sector". must be defined. otherwise
;;		BIOS will reject our code
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
