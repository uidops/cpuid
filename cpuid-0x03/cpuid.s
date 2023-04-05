.section .text
.globl _start

_start:
	movl $0x03, %eax
	cpuid

	leal .fmt(%eip), %edi
	movl %eax, %esi
	xorb %al, %al
	call printf

	movl $0x3c, %eax
	xorl %edi, %edi
	syscall

	ret


.section .rodata

.fmt: .ascii "PSN: 0x%08x\n\n* NOTE: Processor serial number (PSN) is available in Pentium III processor only. The value in this\n"
      .ascii "        register is reserved in the Pentium 4 processor or later.  On all models, use the PSN flag\n"
      .asciz "        (returned using CPUID) to check for PSN support before accessing the feature\n"
