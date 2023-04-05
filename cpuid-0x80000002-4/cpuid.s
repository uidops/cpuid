.section .text
.globl _start, save_string

.type save_string, @function

_start:
	movq 0x30(%rsp), %rbp

	movl $0x80000002, %eax
	cpuid
	callq save_string

	movl $0x80000003, %eax
	cpuid
	callq save_string

	movl $0x80000004, %eax
	cpuid
	callq save_string

	movl $0x00, (%rbp)
	leaq -0x30(%rbp), %rdi
	callq puts

	movq $0x3c, %rax
	xorq %rdi, %rdi
	syscall

	ret


save_string:
	movl %eax, 0x00(%rbp)
	movl %ebx, 0x04(%rbp)
	movl %ecx, 0x08(%rbp)
	movl %edx, 0x0c(%rbp)

	addq $0x10, %rbp
	xorq %rax, %rax
	ret
