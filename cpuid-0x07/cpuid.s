.section .text
.globl _start

_start:
	movl $0x07, %eax
	xorl %ecx, %ecx
	cpuid

	subq $0x20, %rsp

	movq %rbx, %r9
	shrq $0x0a, %r9
	andq $0x01, %r9

	movq %rbx, %rdi
	shrl $0x09, %edi
	andl $0x01, %edi
	movq %rdi, (%rsp)

	movq %rbx, %rdi
	shrl $0x07, %edi
	andl $0x01, %edi
	movq %rdi, 0x08(%rsp)

	movq %rbx, %rdi
	andl $0x01, %edi
	movq %rdi, 0x10(%rsp)

	leaq .fmt(%rip), %rdi
	movq %rax, %rsi
	movq %rdx, %r8
	movq %rbx, %rdx
	xorb %al, %al
	callq printf

	addq $0x20, %rsp

	movq $0x3c, %rax
	xorq %rdi, %rdi
	syscall

	ret


.section .rodata

.fmt: .ascii "%%rax = 0x%08x\n%%rbx = 0x%08x\n%%rcx = 0x%08x\n%%rdx = 0x%08x\n\n"
      .ascii "INVPCID                  : 0x%x\nEnhanced REP MOVSB/STOSB : 0x%x\n"
      .asciz "SMEP                     : 0x%x\nFSGSBASE                 : 0x%x\n"
