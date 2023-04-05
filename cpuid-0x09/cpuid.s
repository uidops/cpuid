.section .text
.globl _start

_start:
	movl $0x09, %eax
	cpuid

	leaq .fmt(%rip), %rdi
	movq %rax, %rsi
	movq %rax, %r9
	movq %rdx, %r8
	movq %rbx, %rdx
	xorb %al, %al
	callq printf

	movq $0x3c, %rax
	xorq %rdi, %rdi
	syscall

	ret


.section .rodata

.fmt: .asciz "%%rax = 0x%08x\n%%rbx = 0x%08x\n%%rcx = 0x%08x\n%%rdx = 0x%08x\n\nPLATFORM_DCA_CAP MSR Bits : 0x%08x\n"
