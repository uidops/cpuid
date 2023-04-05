.section .text
.globl _start

_start:
	xorl %esi, %esi	
	movl $0x0d, %eax
	movl %esi, %ecx
	cpuid

	subq $0x08, %rsp
	pushq %rsi
	leaq .fmt_0(%rip), %rdi
	movq %rdx, %r9
	movq %rcx, %r8
	movq %rax, %rdx
	movq %rbx, %rcx
	xorb %al, %al
	callq printf
	popq %rsi
	addq $0x08, %rsp

	incl %esi
	movl $0x0d, %eax
	movl %esi, %ecx
	cpuid

	movq %rax, %rdi
	andl $0x01, %edi
	movq %rdi, (%rsp)

	subq $0x08, %rsp
	pushq %rsi
	leaq .fmt_1(%rip), %rdi
	movq %rdx, %r9
	movq %rcx, %r8
	movq %rax, %rdx
	movq %rbx, %rcx
	xorb %al, %al
	callq printf
	popq %rsi
	addq $0x08, %rsp

	incl %esi
	.Lloop:
		movl $0x0d, %eax
		movl %esi, %ecx
		cpuid

		movl %ebx, %edi
		orl %eax, %edi
		jz .Lexit

		subq $0x08, %rsp
		pushq %rsi
		leaq .fmt_0(%rip), %rdi
		movq %rdx, %r9
		movq %rcx, %r8
		movq %rax, %rdx
		movq %rbx, %rcx
		xorb %al, %al
		callq printf
		popq %rsi
		addq $0x08, %rsp

		incl %esi
		jmp .Lloop	


	.Lexit:
		movq $0x3c, %rax
		xorq %rdi, %rdi
		syscall


	ret


.section .rodata

.fmt_0: .asciz "ECX = %u\n------\n%%rax = 0x%08x\n%%rbx = 0x%08x\n%%rcx = 0x%08x\n%%rdx = 0x%08x\n\n"
.fmt_1: .ascii "ECX = %u\n------\n%%rax = 0x%08x\n%%rbx = 0x%08x\n%%rcx = 0x%08x\n%%rdx = 0x%08x\n\n"
        .asciz "XSAVEOPT : 0x%x\n\n"
