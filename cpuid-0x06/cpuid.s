.section .text
.globl _start

_start:
	movl $0x06, %eax
	cpuid

	movq %rax, %r9
	shrq $0x06, %r9
	andq $0x01, %r9

	subq $0x50, %rsp

	movq %rax, %rdi
	shrl $0x05, %edi
	andl $0x01, %edi
	movq %rdi, (%rsp)

	movq %rax, %rdi
	shrl $0x04, %edi
	andl $0x01, %edi
	movq %rdi, 0x08(%rsp)

	movq %rax, %rdi
	shrl $0x02, %edi
	andl $0x01, %edi
	movq %rdi, 0x10(%rsp)


	movq %rax, %rdi
	shrl $0x01, %edi
	andl $0x01, %edi
	movq %rdi, 0x18(%rsp)

	movq %rax, %rdi
	andl $0x01, %edi
	movq %rdi, 0x20(%rsp)

	movl %ebx, %edi
	andl $0x0f, %edi
	movq %rdi, 0x28(%rsp)

	movq %rcx, %rdi
	shrl $0x03, %edi
	andl $0x01, %edi
	movq %rdi, 0x30(%rsp)

	movq %rcx, %rdi
	shrl $0x01, %edi
	andl $0x01, %edi
	movq %rdi, 0x38(%rsp)

	movq %rcx, %rdi
	andl $0x01, %edi
	movq %rdi, 0x40(%rsp)

	leaq .fmt(%rip), %rdi
	movq %rax, %rsi
	movq %rdx, %r8
	movq %rbx, %rdx
	xorb %al, %al
	callq printf

	addq $0x50, %rsp

	movq $0x3c, %rax
	xorq %rdi, %rdi
	syscall

	ret


.section .rodata

.fmt: .ascii "%%rax = 0x%08x\n%%rbx = 0x%08x\n%%rcx = 0x%08x\n%%rdx = 0x%08x\n\n"
      .ascii "PTM capability       : 0x%x\nECMD capability      : 0x%x\nPLN capability       : 0x%x\nARAT capability      : 0x%x\nTBT capability       : 0x%x\n"
	  .asciz "DTS capability       : 0x%x\nInterrupt Thresholds : 0x%x\nEPB capability       : 0x%x\nACNT2 capability     : 0x%x\nHCF capability       : 0x%x\n"
