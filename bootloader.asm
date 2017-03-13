BITS 16

start:
	; Set up 4K stack after this bootloader
	; remember: effective address = Segment*16 + Offset
	mov ax, 070h 	; Set ax equal to location of this bootloader (0x7C00) / 16
	add ax, 20h 	; Skip over bootloader (0x200) / 16
	mov ss, ax 	; set stack segment to beginning of stack region (beyond bootloader)
	mov sp, 4096	; Set 'ss:sp' to the top of our 4k stack

	; Set data segment to where we're loaded so we can implicitly access all 64K
	; from here
	mov ax, 070h 	; to bootloader
	mov ds, ax	; set data segment to this location

	; Print our message and stop execution
	mov si, message	; Put address of the null-terminated string to output into source register
	call print	; Call our print routine
	cli		; Clear the Interrupt Flag (disable external interrupts)
	hlt		; Halt the CPU (until the next external interrupt)

data:
	message db 'This was outputted by a basic bootloader!', 0

;Routing for outputting string in 'si' register to screen
print:
	mov ah, 0Eh	; Specify 'int 10h' teletype output function

.printchar:
	lodsb		; Load byte at address SI into AL, and increment SI
	cmp al, 0
	je .done	; If the character is NUL, stop wiritng the string
	int 10h		; Otherwise, print the character via 'int 10h'
	jmp .printchar	; repeat for next char
.done:
	ret

; Pad to 510 bytes and finish with standard boot signature
times 510-($-$$) db 0
dw 0xAA55 ; 0x55 0xAA (little endian byte order)
