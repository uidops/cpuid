.section .text
.globl _start, process

.type process, @function

_start:
	xorl %esi, %esi
	.Lloop:
		movl $0x04, %eax
		movl %esi, %ecx
		cpuid

		pushq %rax
		andl $0x1f, %eax
		jz .Lexit
		popq %rax

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
	subq $0x70, %rsp

	pushq %rax

	shrl $0x1a, %eax
	incl %eax
	movq %rax, 0x08(%rsp)

	movq (%rsp), %rax
	shrl $0x00e, %eax
	andl $0xfff, %eax
	incl %eax
	movq %rax, 0x10(%rsp)

	movq (%rsp), %rax
	btl $0x09, %eax
	setcb  %al
	movzx %al, %rax
	movq %rax, 0x18(%rsp)

	movq (%rsp), %rax
	btl $0x08, %eax
	setcb  %al
	movzx %al, %rax
	movq %rax, 0x20(%rsp)

	movq (%rsp), %rax
	shrl $0x05, %eax
	andl $0x07, %eax
	movq %rax, 0x28(%rsp)

	movq (%rsp), %rax
	andl $0x1f, %eax
	movq %rax, 0x30(%rsp)

	popq %rax

	pushq %rbx

	shrl $0x16, %ebx
	incl %ebx
	movq %rbx, 0x38(%rsp)

	movq (%rsp), %rbx
	shrl $0x00c, %ebx
	andl $0x3ff, %ebx
	incl %ebx
	movq %rbx, 0x40(%rsp)

	movq (%rsp), %rbx
	andl $0xfff, %ebx
	incl %ebx
	movq %rbx, 0x48(%rsp)

	popq %rbx

	movq %rcx, 0x48(%rsp)
	incq 0x48(%rsp)

	pushq %rdx
	
	btl $0x02, %edx
	setcb  %dl
	movzx %dl, %rdx
	movq %rdx, 0x58(%rsp)

	movq (%rsp), %rdx
	btl $0x01, %edx
	setcb  %dl
	movzx %dl, %rdx
	movq %rdx, 0x60(%rsp)

	movq (%rsp), %rdx
	btl $0x00, %edx
	setcb  %dl
	movzx %dl, %rdx
	movq %rdx, 0x68(%rsp)

	popq %rdx

	movq 0x30(%rsp), %r8
	imulq 0x38(%rsp), %r8
	imulq 0x40(%rsp), %r8
	imulq 0x48(%rsp), %r8
	movq %r8, 0x68(%rsp)

	leaq .fmt(%rip), %rdi
	movq %rdx, %r9
	movq %rax, %rdx
	movq %rcx, %r8
	movq %rbx, %rcx
	xorb %al, %al
	callq printf

	addq $0x70, %rsp
	popq %rsi
	ret


.section .rodata

.fmt: .ascii "INDEX: %u\n-----------------\n%%rax = 0x%08x\n%%rbx = 0x%08x\n%%rcx = 0x%08x\n%%rdx = 0x%08x\n\n"
      .ascii "MaxProcessorCores           : 0x%04x\nMaxThreadsCache             : 0x%04x\nFullyAssociativeCache       : 0x%04x\nSelfInitializingCacheLevel  : 0x%04x\n"
	  .ascii "CacheLeveL                  : 0x%04x\nCacheType                   : 0x%04x\n"
      .ascii "Ways                        : 0x%04x\nPartitions                  : 0x%04x\nLineSize                    : 0x%04x\nNumberofSets                : 0x%04x\n"
	  .asciz "ComplexCacheIndexing        : 0x%04x\nInclusiveofLowerCacheLevels : 0x%04x\nWBINVD/INVD                 : 0x%04x\nCacheSize                   : 0x%04x\n\n"
