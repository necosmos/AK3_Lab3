
.syntax unified
.cpu cortex-m4
//.fpu softvfp
.thumb

.global bootload
.section .rodata
	image: .incbin "kernel.bin"
	end_of_image:
	str_boot_start: .asciz "bootloader started"
	str_boot_end: .asciz "bootloader end"
	str_boot_indicate: .asciz "#"

.section .text
bootload:
	ldr r0, =str_boot_start
	bl dbgput_line
	ldr r0, =end_of_image
	ldr r1, =image
	ldr r2, =_ram_start
	
sub r6, r0, r1
add r4, r6, r2

loop:
	ldmdb r0!, {r5,r6,r7}
	stmdb r4!, {r5, r6, r7}
	cmp r1, r0
	blt loop

bl newline
ldr r0, =str_boot_end
bl dbgput_line

ldr lr, =bootload_end
add lr, #1
ldr r2, =_ram_start

add r2, #4 // go to __reset_kernel__
ldr r0, [r2]
bx r0

bootload_end:
    b bootload_end
    