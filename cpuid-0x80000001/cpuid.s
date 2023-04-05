.section .text
.globl _start

_start:
	movl $0x80000001, %eax
	cpuid

	movq %rcx, %r9
	andq $0x01, %r9

	subq $0x30, %rsp

	movq %rdx, %rdi
	shrl $0x1d, %edi
	andl $0x01, %edi
	movq %rdi, (%rsp)

	movq %rdx, %rdi
	shrl $0x1b, %edi
	andl $0x01, %edi
	movq %rdi, 0x08(%rsp)

	movq %rdx, %rdi
	shrl $0x1a, %edi
	andl $0x01, %edi
	movq %rdi, 0x10(%rsp)

	movq %rdx, %rdi
	shrl $0x14, %edi
	andl $0x01, %edi
	movq %rdi, 0x18(%rsp)

	movq %rdx, %rdi
	shrl $0x0b, %edi
	andl $0x01, %edi
	movq %rdi, 0x20(%rsp)

	leaq .fmt(%rip), %rdi
	movq %rax, %rsi
	movq %rdx, %r8
	movq %rbx, %rdx
	xorb %al, %al
	callq printf

	addq $0x30, %rsp

	movq $0x3c, %rax
	xorq %rdi, %rdi
	syscall

	ret


.section .rodata

.fmt: .ascii "%%rax = 0x%08x\n%%rbx = 0x%08x\n%%rcx = 0x%08x\n%%rdx = 0x%08x\n\n"
      .ascii "LAHF / SAHF           : 0x%x\nIA-64                 : 0x%x\nRDTSCP / IA32_TSC_AUX : 0x%x\n"
	  .asciz "1GB Pages             : 0x%x\nXD Bit                : 0x%x\nSYSCALL / SYSRET      : 0x%x\n"
