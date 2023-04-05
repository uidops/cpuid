.section .text
.globl _start

_start:
	movq $0x01, %rax
	cpuid

	push %rax
	push %rbx
	push %rcx
	push %rdx

	leaq .fmt(%rip), %rdi
	movq %rax, %rsi
	movq %rdx, %r8
	movq %rbx, %rdx
	xorb %al, %al
	callq printf

	popq %r14
	popq %r13
	popq %r12
	popq %rax

	/*  *********************** EAX *********************   */

	movl %eax, %esi
	shrl $0x14, %esi
	andl $0xff, %esi

	movl %eax, %edx
	shrl $0x10, %edx
	andl $0x0f, %edx

	movl %eax, %ecx
	shrl $0x0c, %ecx
	movl $0x03, %ecx

	movq %rax, %r8
	shrq $0x08, %r8
	andq $0x0f, %r8

	movq %rax, %r9
	shrq $0x04, %r9
	andq $0x0f, %r9

	andl $0x0f, %eax
	movq %rax, (%rsp)

	leaq .fmt_eax(%rip), %rdi
	callq printf

	/*  *********************** EBX *********************   */

	movq %r12, %rsi
	shrl $0x18, %esi
	andl $0xff, %esi

	movq %r12, %rdx
	shrl $0x10, %edx
	andl $0xff, %edx

	movq %r12, %rcx
	shrl $0x08, %ecx
	andl $0xff, %ecx

	movq %r12, %r8
	andq $0xff, %r8

	leaq .fmt_ebx(%rip), %rdi
	callq printf

	/*  *********************** ECX *********************   */

	movq %r13, %rsi
	shrl $0x1f, %esi
	andl $0x01, %esi

	movq %r13, %rdx
	shrl $0x1e, %edx
	andl $0x01, %edx

	movq %r13, %rcx
	shrl $0x1d, %ecx
	andl $0x01, %ecx

	movq %r13, %r8
	shrq $0x1c, %r8
	andq $0x01, %r8

	movq %r13, %r9
	shrq $0x1b, %r9
	andq $0x01, %r9

	movq $0x1a, %r10
	xorq %rbx, %rbx

	.Lloop_ecx:
		movq %r13, %rax
		shrxq %r10, %rax, %rax
		andl $0x01, %eax
		movq %rax, (%rsp, %rbx, 0x08)
		incq %rbx
		decq %r10
		jns .Lloop_ecx

	leaq .fmt_ecx(%rip), %rdi
	callq printf

	/*  *********************** EDX *********************   */

	movq %r14, %rsi
	shrl $0x1f, %esi
	andl $0x01, %esi

	movq %r14, %rdx
	shrl $0x1e, %edx
	andl $0x01, %edx

	movq %r14, %rcx
	shrl $0x1d, %ecx
	andl $0x01, %ecx

	movq %r14, %r8
	shrq $0x1c, %r8
	andq $0x01, %r8

	movq %r14, %r9
	shrq $0x1b, %r9
	andq $0x01, %r9

	movq $0x1a, %r10
	xorq %rbx, %rbx

	.Lloop_edx:
		movq %r14, %rax
		shrxq %r10, %rax, %rax
		andl $0x01, %eax
		movq %rax, (%rsp, %rbx, 0x08)
		incq %rbx
		decq %r10
		jns .Lloop_edx

	leaq .fmt_edx(%rip), %rdi
	callq printf

	xorq %rdi, %rdi
	callq exit

	ret


.section .rodata

.fmt_eax: .asciz "EAX\n---\nExtFamily  : 0x%08x\nExtModel   : 0x%08x\nPType      : 0x%08x\nBaseFamily : 0x%08x\nBaseModel  : 0x%08x\nStepping   : 0x%08x\n\n"
.fmt_ebx: .asciz "EBX\n---\nLocalApicID             : 0x%08x\nLogical Processor Count : 0x%08x\nCLFlush                 : 0x%08x\n8BitBrandID             : 0x%08x\n\n"

.fmt_ecx: .ascii "ECX\n---\nhypervisor   : %u\nrdrnd        : %u\nf16c         : %u\navx          : %u\nosxsave      : %u\nxsave        : %u\naes          : %u\n"
          .ascii "tsc-deadline : %u\npopcnt       : %u\nmovbe        : %u\nx2apic       : %u\nsse42        : %u\nsse41        : %u\ndca          : %u\n"
		  .ascii "pcid         : %u\nreserved     : %u\npdcm         : %u\nxtpr         : %u\ncx16         : %u\nfma          : %u\nsdbg         : %u\n"
		  .ascii "cnxt-id      : %u\nssse3        : %u\ntm2          : %u\nest          : %u\nsmx          : %u\nvmx          : %u\nds-cpl       : %u\n"
		  .asciz "monitor      : %u\ndtes64       : %u\npclmulqdq    : %u\nsse3         : %u\n\n"

.fmt_edx: .ascii "EDX\n---\npbe      : %u\nia64     : %u\ntm       : %u\nhtt      : %u\nss       : %u\nsse2     : %u\nsse      : %u\nfxsr     : %u\nmmx      : %u\n"
          .ascii "acpi     : %u\nds       : %u\nreserved : %u\nclfsh    : %u\npsn      : %u\npse-36   : %u\npat      : %u\ncmov     : %u\nmca      : %u\n"
		  .ascii "pge      : %u\nmtrr     : %u\nsep      : %u\nreserved : %u\napic     : %u\ncx8      : %u\nmce      : %u\npae      : %u\nmsr      : %u\n"
		  .asciz "tsc      : %u\npse      : %u\nde       : %u\nvme      : %u\nfpu      : %u\n"

.fmt: .asciz "%%eax = 0x%08x\n%%ebx = 0x%08x\n%%ecx = 0x%08x\n%%edx = 0x%08x\n\n"
