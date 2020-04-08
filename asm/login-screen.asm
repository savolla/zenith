;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  @file:          login-screen.asm
;;
;;  @author:        savolla
;;
;;  @date:          Edited at 07.04.2020
;;
;;  @desciption:    creates a simple tty logic screen where user enters his username and
;;					password.
;;					
;;  @warning:		this is just a hello world code. things	will get more clear when I
;;					start to write a kernel. this code runs on boot sector. which is so
;;					ridiculous :D
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;# RUNTIME #
[org 0x7c00]						;; magic number. see: D.01

mov bx, str_welcome					;; load bx with address of str_welcome variable
call print_nl						;; print str_welcome to the tty

mov bx, str_username				;; load bx with address of str_username variable
call print							;; print str_welcome to the tty
call get_one_line_input				;; let user to input his/her username

mov bx, str_password				;; load bx with address of str_password variable
call print							;; print str_welcome to the tty
call get_one_line_input				;; let user to input his/her password

jmp $								;; think like system("pause"). see: D.02





;# INCLUSION #
%include "utils.asm"				;; file that includes useful utility functions





;# VARIABLES #
str_welcome: db "zenith glances at you with its foggy eyes", 0x0
str_username: db "name: ", 0x0
str_password: db "key : ", 0x0

times 510 - ( $ - $$ ) db 0
dw 0xaa55							;; end of boot sector. see D.03





;# DOCUMENTATION #
; D.01: 0x7c00 is a special address in x86 architecture. it represents a boot sector.
;		where our code will be placed into memory after you press power button of your
;		 PC
;		
; D.02: this is special for nasm (netwide assembler). '$' symbol represents the "current
; 		address". it jumps to current address infinitelly. a dirty way to pausing 
;		execution
;
; D.03: this two byte value represents end of a boot sector. must be defined. otherwise
;		BIOS will reject our code

