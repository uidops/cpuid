.section .text
.globl _start

_start:
	movl $0x05, %eax
	cpuid

	movq %rax, %r9
	andq $0xffff, %r9

	subq $0x40, %rsp

	movq %rbx, %rdi
	andl $0xffff, %edi
	movq %rdi, (%rsp)

	movq %rcx, %rdi
	xorq %rsi, %rsi
	shrl $0x01, %edi
	adcq $0, %rsi
	andl $0x01, %edi
	movq %rdi, 0x08(%rsp)
	movq %rsi, 0x10(%rsp)

	movq %rdx, %rdi
	shrl $0x10, %edi
	andl $0x0f, %edi
	movq %rdi, 0x18(%rsp)

	movq %rdx, %rdi
	shrl $0x0c, %edi
	andl $0x0f, %edi
	movq %rdi, 0x20(%rsp)

	movq %rdx, %rdi
	shrl $0x08, %edi
	andl $0x0f, %edi
	movq %rdi, 0x28(%rsp)

	movq %rdx, %rdi
	shrl $0x04, %edi
	andl $0x0f, %edi
	movq %rdi, 0x30(%rsp)

	movq %rdx, %rdi
	andl $0x0f, %edi
	movq %rdi, 0x38(%rsp)

	leaq .fmt(%rip), %rdi
	movq %rax, %rsi
	movq %rdx, %r8
	movq %rbx, %rdx
	xorb %al, %al
	callq printf

	addq $0x40, %rsp

	movq $0x3c, %rax
	xorq %rdi, %rdi
	syscall

	ret


.section .rodata
.fmt: .ascii "%%rax = 0x%08x\n%%rbx = 0x%08x\n%%rcx = 0x%08x\n%%rdx = 0x%08x\n\n"
      .ascii "SmallestMonitorLineSize : 0x%04x\nLargestMonitorLineSize  : 0x%04x\nTreatingInterrupts      : 0x%04x\nMONITOR / MWAIT         : 0x%04x\n"
	  .ascii "C4* sub-states          : 0x%04x\nC3* sub-states          : 0x%04x\nC2* sub-states          : 0x%04x\nC1* sub-states          : 0x%04x\n"
	  .asciz "C0* sub-states          : 0x%04x\n"
