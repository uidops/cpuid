.section .text
.globl _start, process

.type process, @function

_start:
	xorl %esi, %esi

	.Lloop:
		movl $0x0b, %eax
		movl %esi, %ecx
		cpuid

		movl %ebx, %edi
		orl %eax, %edi
		je .Lexit

		callq process

		incl %esi
		jmp .Lloop

	.Lexit:
		movq $0x3c, %rax
		xorq %rdi, %rdi
		syscall

	ret


process:
	pushq %rsi

	subq $0x30, %rsp

	movq %rax, %rdi
	andl $0x1f, %edi
	movq %rdi, (%rsp)

	movq %rbx, %rdi
	andl $0xffff, %edi
	movq %rdi, 0x08(%rsp)

	movq %rcx, %rdi
	shrl $0x08, %edi
	andl $0xff, %edi
	movq %rdi, 0x10(%rsp)

	movq %rcx, %rdi
	andl $0xff, %edi
	movq %rdi, 0x18(%rsp)

	movq %rdx, 0x20(%rsp)

	leaq .fmt(%rip), %rdi
	movq %rdx, %r9
	movq %rcx, %r8
	movq %rax, %rdx
	movq %rbx, %rcx
	xorb %al, %al
	callq printf

	addq $0x30, %rsp

	popq %rsi
	retq


.section .rodata

.fmt: .ascii "LEVEL %u\n-------\n%%rax = 0x%08x\n%%rbx = 0x%08x\n%%rcx = 0x%08x\n%%rdx = 0x%08x\n\n"
      .asciz "NextLevelApicIdShift : 0x%08x\nfactory-configured   : 0x%08x\nLevelType            : 0x%08x\nLevelNumber          : 0x%08x\nExtendedApicId       : 0x%08x\n\n"
