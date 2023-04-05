.section .text
.globl _start

_start:
	movl $0x0a, %eax
	cpuid

	subq $0x60, %rsp

	movq %rax, %r9
	shrq $0x18, %r9

	movq %rax, %rdi
	shrl $0x10, %edi
	andl $0xff, %edi
	movq %rdi, (%rsp)

	movq %rax, %rdi
	shrl $0x08, %edi
	andl $0xff, %edi
	movq %rdi, 0x08(%rsp)

	movq %rax, %rdi
	andl $0xff, %edi
	movq %rdi, 0x10(%rsp)

	movq %rbx, %rdi
	shrl $0x06, %edi
	andl $0x01, %edi
	movq %rdi, 0x18(%rsp)

	movq %rbx, %rdi
	shrl $0x05, %edi
	andl $0x01, %edi
	movq %rdi, 0x20(%rsp)

	movq %rbx, %rdi
	shrl $0x04, %edi
	andl $0x01, %edi
	movq %rdi, 0x28(%rsp)

	movq %rbx, %rdi
	shrl $0x03, %edi
	andl $0x01, %edi
	movq %rdi, 0x30(%rsp)

	movq %rbx, %rdi
	shrl $0x02, %edi
	andl $0x01, %edi
	movq %rdi, 0x38(%rsp)

	movq %rbx, %rdi
	shrl $0x01, %edi
	andl $0x01, %edi
	movq %rdi, 0x40(%rsp)

	movq %rbx, %rdi
	andl $0x01, %edi
	movq %rdi, 0x48(%rsp)

	movq %rdx, %rdi
	shrl $0x05, %edi
	andl $0xff, %edi
	movq %rdi, 0x50(%rsp)

	movq %rdx, %rdi
	andl $0x1f,  %edi
	movq %rdi, 0x58(%rsp)

	leaq .fmt(%rip), %rdi
	movq %rax, %rsi
	movq %rdx, %r8
	movq %rbx, %rdx
	xorb %al, %al
	callq printf

	addq $0x60, %rsp

	movq $0x3c, %rax
	xorq %rdi, %rdi
	syscall

	ret


.section .rodata

.fmt: .ascii "%%rax = 0x%08x\n%%rbx = 0x%08x\n%%rcx = 0x%08x\n%%rdx = 0x%08x\n\n"
      .ascii "EBX bit vector length                 : 0x%02x\ngeneral-purpose PM counters bit width : 0x%02x\n"
      .ascii "general-purpose PM counters           : 0x%02x\nAPM Version ID                        : 0x%02x\n"
	  .ascii "Branch Mispredicts Retired            : 0x%02x\nBranch Instructions Retired           : 0x%02x\n"
	  .ascii "Last Level Cache Misses               : 0x%02x\nLast Level Cache References           : 0x%02x\n"
	  .ascii "Reference Cycles                      : 0x%02x\nInstructions Retired                  : 0x%02x\n"
	  .ascii "Core Cycles                           : 0x%02x\nNumber of Bits in the Fixed Counters  : 0x%02x\n"
	  .asciz "Number of Fixed Counters              : 0x%02x\n"
