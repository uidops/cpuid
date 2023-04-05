.section .text
.globl _start

_start:
	movl $0x80000007, %eax
	cpuid

	movq %rdx, %r9
	shrq $0x08, %r9
	andq $0x01, %r9

	leaq .fmt(%rip), %rdi
	movq %rax, %rsi
	movq %rdx, %r8
	movq %rbx, %rdx
	xorb %al, %al
	callq printf

	movq $0x3c, %rax
	xorq %rdi, %rdi
	syscall

	ret


.section .rodata

.fmt: .ascii "%%rax = 0x%08x\n%%rbx = 0x%08x\n%%rcx = 0x%08x\n%%rdx = 0x%08x\n\n"
      .asciz "TSC Invariance : 0x%x\n"
