.section .text
.globl _start, error, npow2

.type npow2, @function

_start:
	xorq %rbp, %rbp

	leaq 0x08(%rsp), %rdx
	cmpq $0x02, (%rsp)
	jb error


	movq 0x08(%rdx), %rax
	subq $0x16, %rsp
	movq %rax, %rdi
	leaq .xfmt(%rip), %rsi
	leaq 0x08(%rsp), %rdx
	pushq %rax
	xorq %rax, %rax
	call sscanf
	popq %rax
	movq 0x08(%rsp), %rax
	addq $0x16, %rsp

	push %rax
	movq %rax, %rdi
	callq msb

	movq %rax, %rdi
	callq npow2

	popq %rdi
	movq %rax, %rsi
	callq show



	movq $0x3c, %rax
	xorq %rdi, %rdi
	syscall

	retq

error:
	leaq .ustr(%rip), %rdi
	movq (%rdx), %rsi
	callq printf

	movq $0x3c, %rax
	movq $1, %rdi
	syscall

	retq


msb:
	pushq %rax
	bsrq %rdi, %rax
	incq %rax
	popq %rcx
	retq


npow2:
	pushq %rax
	movq $1, %rax
	cmpq $1, %rdi
	je .LRET
	decq %rdi
	lzcntq %rdi, %rax
	negb %al
	movq $1, %rcx
	shlxq %rax, %rcx, %rax
	cltq
	.LRET:
	popq %rcx
	retq


show:
	pushq %rax
	subq $0x18, %rsp
	movq %rdi, %rax
	movq %rsi, %rbx
	leaq .titl(%rip), %rdi
	pushq %rax
	callq puts
	popq %rax
	xorq %r8, %r8
	.Lloop:
		pushq %rax
		pushq %rbx
		pushq %r8

		andq $1, %rax

		leaq .ifmt(%rip), %rdi
		movq %r8, %rsi
		movq %rax, %rdx
		xorq %rax, %rax
		callq printf

		popq %r8
		popq %rbx
		popq %rax
		shrq $1, %rax
		incq %r8
		cmpq %rbx, %r8
		jb .Lloop

	addq $0x18, %rsp
	popq %rcx
	retq


.section .rodata

.ustr: .asciz "usage: %s [HEX]\n"
.xfmt: .asciz "0x%lx"
.ifmt: .asciz "%02u      :      %u\n"
.titl: .asciz "IDX     :     BIT\n"
