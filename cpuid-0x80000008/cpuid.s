.section .text
.globl _start

_start:
	movl $0x80000008, %eax
	cpuid

	movq %rax, %r9
	shrq $0x08, %r9
	andq $0xff, %r9

	subq $0x10, %rsp

	movq %rax, %rdi
	andl $0xff, %edi
	movq %rdi, (%rsp)

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
      .asciz "VirtualAddressSize : 0x%x\nPhysicalAddressSize : 0x%x\n"
