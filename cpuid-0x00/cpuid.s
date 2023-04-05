.section .text
.globl _start

_start:
	subq $0x10, %rsp

	xorq %rax, %rax
	cpuid

	movl %ebx, (%rsp)
	movl %edx, 0x04(%rsp)
	movl %ecx, 0x08(%rsp)
	movl $0x0, 0x0c(%rsp)

	leaq .fmt(%rip), %rdi
	movq %rax, %rsi
	leaq (%rsp), %rdx
	callq printf

	addq $0x10, %rsp

	movq $0x3c, %rax
	xorq %rdi, %rdi
	syscall

	ret


.section .rodata

.fmt: .asciz "LFuncSTD: 0x%lx\nVendor  : %s\n"
