.section .text
.globl _start

_start:
	movl $0x80000006, %eax
	cpuid

	movq %rcx, %r9
	shrq $0x10, %r9

	subq $0x10, %rsp

	movq %rcx, %rdi
	shrl $0x0c, %edi
	andl $0x0f, %edi
	movq %rdi, (%rsp)

	movq %rcx, %rdi
	andl $0xff, %edi
	movq %rdi, 0x08(%rsp)

	leaq .fmt(%rip), %rdi
	movq %rax, %rsi
	movq %rdx, %r8
	movq %rbx, %rdx
	xorb %al, %al
	callq printf

	addq $0x10, %rsp

	movq $0x3c, %rax
	xorq %rdi, %rdi
	syscall

	ret


.section .rodata

.fmt: .ascii "%%rax = 0x%08x\n%%rbx = 0x%08x\n%%rcx = 0x%08x\n%%rdx = 0x%08x\n\n"
      .asciz "L2CacheSize          : 0x%x\nL2CacheAssociativity : 0x%x\nL2CacheLineSize      : 0x%x\n"
