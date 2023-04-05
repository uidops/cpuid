/* https://www.felixcloutier.com/x86/cpuid#tbl-3-12 */

.section .text
.globl _start, process

.type process, @function

_start:
	movq $0x02, %rax
	cpuid

	pushq %rax
	pushq %rbx
	pushq %rcx
	pushq %rdx

	leaq .Lfmt(%rip), %rdi
	mov %rax, %rsi
	movq %rdx, %r8
	movq %rbx, %rdx
	xorb %al, %al
	callq printf

	popq %rdx
	popq %rcx
	popq %rbx
	popq %rax

	movq %rax, %rdi
	callq process

	movq %rbx, %rdi
	callq process

	movq %rcx, %rdi
	callq process

	movq %rdx, %rdi
	callq process

	movq $0x3c, %rax
	xorq %rdi, %rdi
	syscall

	ret


process:
	pushq %rbx
	pushq %rcx
	pushq %rdx

	btl $0x1f, %edi
	jc .Lprocess.end

	movq %rdi, %r12
	movq $0x18, %r13
	movl $0xff000000, %ebx
	leaq .Ldata(%rip), %r14
	.Lprocess.loop:
		movq %r12, %rax
		andl %ebx, %eax
		shrxq %r13, %rax, %rsi
		movslq (%r14, %rsi, 0x04), %rdi
		test %rdi, %rdi
		jz .Lprocess.wn
		addq %r14, %rdi
		movq %rdi, %rdx
		leaq .Lfmt_data(%rip), %rdi
		callq printf
		.Lprocess.wn:
			subq $0x08, %r13
			shrl $0x08, %ebx
			jnz .Lprocess.loop

	.Lprocess.end:
		popq %rdx
		popq %rcx
		popq %rbx

		xorq %rax, %rax
		ret

.section    .rodata

.Lfmt_data: .asciz "0x%02x : %s\n"
.Lfmt: .asciz "EAX: 0x%08x\nEBX: 0x%08x\nECX: 0x%08x\nEDX: 0x%08x\n\n"

.L0x01: .asciz "Instruction TLB: 4-KB Pages, 4-way set associative, 32 entries"
.L0x02: .asciz "Instruction TLB: 4-MB Pages, fully associative, 2 entries"
.L0x03: .asciz "Data TLB: 4-KB Pages, 4-way set associative, 64 entries"
.L0x04: .asciz "Data TLB: 4-MB Pages, 4-way set associative, 8 entries"
.L0x05: .asciz "Data TLB: 4-MB Pages, 4-way set associative, 32 entries"
.L0x06: .asciz "1st-level instruction cache: 8-KB, 4-way set associative, 32-byte line size"
.L0x08: .asciz "1st-level instruction cache: 16-KB, 4-way set associative, 32-byte line size"
.L0x09: .asciz "1st-level Instruction Cache: 32-KB, 4-way set associative, 64-byte line size"
.L0x0a: .asciz "1st-level data cache: 8-KB, 2-way set associative, 32-byte line size"
.L0x0b: .asciz "Instruction TLB: 4-MB pages, 4-way set associative, 4 entries"
.L0x0c: .asciz "1st-level data cache: 16-KB, 4-way set associative, 32-byte line size"
.L0x0d: .asciz "1st-level Data Cache: 16-KB, 4-way set associative, 64-byte line size"
.L0x0e: .asciz "1st-level Data Cache: 24-KB, 6-way set associative, 64-byte line size"
.L0x21: .asciz "2nd-level cache: 256-KB, 8-way set associative, 64-byte line size"
.L0x22: .asciz "3rd-level cache: 512-KB, 4-way set associative, sectored cache, 64-byte line size"
.L0x23: .asciz "3rd-level cache: 1-MB, 8-way set associative, sectored cache, 64-byte line size"
.L0x25: .asciz "3rd-level cache: 2-MB, 8-way set associative, sectored cache, 64-byte line size"
.L0x29: .asciz "1st-level data cache: 32-KB, 8-way set associative, 64-byte line size"
.L0x2c: .asciz "1st-level data cache: 32-KB, 8-way set associative, 64-byte line size"
.L0x30: .asciz "1st-level instruction cache: 32-KB, 8-way set associative, 64-byte line size"
.L0x40: .asciz "No 2nd-level cache or, if processor contains a valid 2nd-level cache, no 3rd-level cache"
.L0x41: .asciz "2nd-level cache: 128-KB, 4-way set associative, 32-byte line size"
.L0x42: .asciz "2nd-level cache: 256-KB, 4-way set associative, 32-byte line size"
.L0x43: .asciz "2nd-level cache: 512-KB, 4-way set associative, 32-byte line size"
.L0x44: .asciz "2nd-level cache: 1-MB, 4-way set associative, 32-byte line size"
.L0x45: .asciz "2nd-level cache: 2-MB, 4-way set associative, 32-byte line size"
.L0x46: .asciz "3rd-level cache: 4-MB, 4-way set associative, 64-byte line size"
.L0x47: .asciz "3rd-level cache: 8-MB, 8-way set associative, 64-byte line size"
.L0x48: .asciz "2nd-level cache: 3-MB, 12-way set associative, 64-byte line size, unified on-die"
.L0x49: .asciz "3rd-level cache: 4-MB, 16-way set associative, 64-byte line size (Intel Xeon processor MP, Family 0Fh, Model 06h) / 2nd-level cache: 4-MB, 16-way set associative, 64-byte line size"
.L0x4a: .asciz "3rd-level cache: 6-MB, 12-way set associative, 64-byte line size"
.L0x4b: .asciz "3rd-level cache: 8-MB, 16-way set associative, 64-byte line size"
.L0x4c: .asciz "3rd-level cache: 12-MB, 12-way set associative, 64-byte line size"
.L0x4d: .asciz "3rd-level cache: 16-MB, 16-way set associative, 64-byte line size"
.L0x4e: .asciz "2nd-level cache: 6-MB, 24-way set associative, 64-byte line size"
.L0x4f: .asciz "Instruction TLB: 4-KB pages, 32 entries"
.L0x50: .asciz "Instruction TLB: 4-KB, 2-MB or 4-MB pages, fully associative, 64 entries"
.L0x51: .asciz "Instruction TLB: 4-KB, 2-MB or 4-MB pages, fully associative, 128 entries"
.L0x52: .asciz "Instruction TLB: 4-KB, 2-MB or 4-MB pages, fully associative, 256 entries"
.L0x55: .asciz "Instruction TLB: 2-MB or 4-MB pages, fully associative, 7 entries"
.L0x56: .asciz "L1 Data TLB: 4-MB pages, 4-way set associative, 16 entries"
.L0x57: .asciz "L1 Data TLB: 4-KB pages, 4-way set associative, 16 entries"
.L0x59: .asciz "Data TLB0: 4-KB pages, fully associative, 16 entries"
.L0x5a: .asciz "Data TLB0: 2-MB or 4-MB pages, 4-way associative, 32 entries"
.L0x5b: .asciz "Data TLB: 4-KB or 4-MB pages, fully associative, 64 entries"
.L0x5c: .asciz "Data TLB: 4-KB or 4-MB pages, fully associative, 128 entries"
.L0x5d: .asciz "Data TLB: 4-KB or 4-MB pages, fully associative, 256 entries"
.L0x60: .asciz "1st-level data cache: 16-KB, 8-way set associative, sectored cache, 64-byte line size"
.L0x63: .asciz "Data TLB: 2 MByte or 4 MByte pages, 4-way set associative, 32 entries and a separate array with 1 GByte pages, 4-way set associative, 4 entries"
.L0x64: .asciz "Data TLB: 4 KByte pages, 4-way set associative, 512 entries"
.L0x66: .asciz "1st-level data cache: 8-KB, 4-way set associative, sectored cache, 64-byte line size"
.L0x67: .asciz "1st-level data cache: 16-KB, 4-way set associative, sectored cache, 64-byte line size"
.L0x68: .asciz "1st-level data cache: 32-KB, 4 way set associative, sectored cache, 64-byte line size"
.L0x70: .asciz "Trace cache: 12K-uops, 8-way set associative"
.L0x71: .asciz "Trace cache: 16K-uops, 8-way set associative"
.L0x72: .asciz "Trace cache: 32K-uops, 8-way set associative"
.L0x76: .asciz "Instruction TLB: 2M/4M pages, fully associative, 8 entries"
.L0x78: .asciz "2nd-level cache: 1-MB, 4-way set associative, 64-byte line size"
.L0x79: .asciz "2nd-level cache: 128-KB, 8-way set associative, sectored cache, 64-byte line size"
.L0x7a: .asciz "2nd-level cache: 256-KB, 8-way set associative, sectored cache, 64-byte line size"
.L0x7b: .asciz "2nd-level cache: 256-KB, 8-way set associative, sectored cache, 64-byte line size"
.L0x7c: .asciz "2nd-level cache: 1-MB, 8-way set associative, sectored cache, 64-byte line size"
.L0x7d: .asciz "2nd-level cache: 2-MB, 8-way set associative, 64-byte line size"
.L0x7f: .asciz "2nd-level cache: 512-KB, 2-way set associative, 64-byte line size"
.L0x80: .asciz "2nd-level cache: 512-KB, 8-way set associative, 64-byte line size"
.L0x82: .asciz "2nd-level cache: 256-KB, 8-way set associative, 32-byte line size"
.L0x83: .asciz "2nd-level cache: 512-KB, 8-way set associative, 32-byte line size"
.L0x84: .asciz "2nd-level cache: 1-MB, 8-way set associative, 32-byte line size"
.L0x85: .asciz "2nd-level cache: 2-MB, 8-way set associative, 32-byte line size"
.L0x86: .asciz "2nd-level cache: 512-KB, 4-way set associative, 64-byte line size"
.L0x87: .asciz "2nd-level cache: 1-MB, 8-way set associative, 64-byte line size"
.L0xb0: .asciz "Instruction TLB: 4-KB Pages, 4-way set associative, 128 entries"
.L0xb1: .asciz "Instruction TLB: 2-MB pages, 4-way, 8 entries or 4M pages, 4-way, 4 entries"
.L0xb2: .asciz "Instruction TLB: 4-KB pages, 4-way set associative, 64 entries"
.L0xb3: .asciz "Data TLB: 4-KB Pages, 4-way set associative, 128 entries"
.L0xb4: .asciz "Data TLB: 4-KB Pages, 4-way set associative, 256 entries"
.L0xba: .asciz "Data TLB: 4-KB Pages, 4-way set associative, 64 entries"
.L0xc0: .asciz "Data TLB: 4-KB or 4-MB Pages, 4-way set associative, 8 entries"
.L0xca: .asciz "Shared 2nd-level TLB: 4 KB pages, 4-way set associative, 512 entries"
.L0xd0: .asciz "3rd-level cache: 512-kB, 4-way set associative, 64-byte line size"
.L0xd1: .asciz "3rd-level cache: 1-MB, 4-way set associative, 64-byte line size"
.L0xd2: .asciz "3rd-level cache: 2-MB, 4-way set associative, 64-byte line size"
.L0xd6: .asciz "3rd-level cache: 1-MB, 8-way set associative, 64-byte line size"
.L0xd7: .asciz "3rd-level cache: 2-MB, 8-way set associative, 64-byte line size"
.L0xd8: .asciz "3rd-level cache: 4-MB, 8-way set associative, 64-byte line size"
.L0xdc: .asciz "3rd-level cache: 1.5-MB, 12-way set associative, 64-byte line size"
.L0xdd: .asciz "3rd-level cache: 3-MB, 12-way set associative, 64-byte line size"
.L0xde: .asciz "3rd-level cache: 6-MB, 12-way set associative, 64-byte line size"
.L0xe2: .asciz "3rd-level cache: 2-MB, 16-way set associative, 64-byte line size"
.L0xe3: .asciz "3rd-level cache: 4-MB, 16-way set associative, 64-byte line size"
.L0xe4: .asciz "3rd-level cache: 8-MB, 16-way set associative, 64-byte line size"
.L0xea: .asciz "3rd-level cache: 12-MB, 24-way set associative, 64-byte line size"
.L0xeb: .asciz "3rd-level cache: 18-MB, 24-way set associative, 64-byte line size"
.L0xec: .asciz "3rd-level cache: 24-MB, 24-way set associative, 64-byte line size"
.L0xf0: .asciz "64-byte Prefetching"
.L0xf1: .asciz "128-byte Prefetching"
.L0xfe: .asciz "CPUID leaf 2 does not report TLB descriptor information; use CPUID leaf 18H to query TLB and other address translation parameters."
.L0xff: .asciz "CPUID Leaf 2 does not report cache descriptor information; use CPUID Leaf 4 to query cache parameters"


.Ldata:
	.long 0x00000000
	.long .L0x01-.Ldata
	.long .L0x02-.Ldata
	.long .L0x03-.Ldata
	.long .L0x04-.Ldata
	.long .L0x05-.Ldata
	.long .L0x06-.Ldata
	.long 0x00000000
	.long .L0x08-.Ldata
	.long .L0x09-.Ldata
	.long .L0x0a-.Ldata
	.long .L0x0b-.Ldata
	.long .L0x0c-.Ldata
	.long .L0x0d-.Ldata
	.long .L0x0e-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0x21-.Ldata
	.long .L0x22-.Ldata
	.long .L0x23-.Ldata
	.long 0x00000000
	.long .L0x25-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0x29-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long .L0x2c-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0x30-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0x40-.Ldata
	.long .L0x41-.Ldata
	.long .L0x42-.Ldata
	.long .L0x43-.Ldata
	.long .L0x44-.Ldata
	.long .L0x45-.Ldata
	.long .L0x46-.Ldata
	.long .L0x47-.Ldata
	.long .L0x48-.Ldata
	.long .L0x49-.Ldata
	.long .L0x4a-.Ldata
	.long .L0x4b-.Ldata
	.long .L0x4c-.Ldata
	.long .L0x4d-.Ldata
	.long .L0x4e-.Ldata
	.long .L0x4f-.Ldata
	.long .L0x50-.Ldata
	.long .L0x51-.Ldata
	.long .L0x52-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long .L0x55-.Ldata
	.long .L0x56-.Ldata
	.long .L0x57-.Ldata
	.long 0x00000000
	.long .L0x59-.Ldata
	.long .L0x5a-.Ldata
	.long .L0x5b-.Ldata
	.long .L0x5c-.Ldata
	.long .L0x5d-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long .L0x60-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long .L0x63-.Ldata
	.long .L0x64-.Ldata
	.long 0x00000000
	.long .L0x66-.Ldata
	.long .L0x67-.Ldata
	.long .L0x68-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0x70-.Ldata
	.long .L0x71-.Ldata
	.long .L0x72-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0x76-.Ldata
	.long 0x00000000
	.long .L0x78-.Ldata
	.long .L0x79-.Ldata
	.long .L0x7a-.Ldata
	.long .L0x7b-.Ldata
	.long .L0x7c-.Ldata
	.long .L0x7d-.Ldata
	.long 0x00000000
	.long .L0x7f-.Ldata
	.long .L0x80-.Ldata
	.long 0x00000000
	.long .L0x82-.Ldata
	.long .L0x83-.Ldata
	.long .L0x84-.Ldata
	.long .L0x85-.Ldata
	.long .L0x86-.Ldata
	.long .L0x87-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0xb0-.Ldata
	.long .L0xb1-.Ldata
	.long .L0xb2-.Ldata
	.long .L0xb3-.Ldata
	.long .L0xb4-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0xba-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0xc0-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0xca-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0xd0-.Ldata
	.long .L0xd1-.Ldata
	.long .L0xd2-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0xd6-.Ldata
	.long .L0xd7-.Ldata
	.long .L0xd8-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0xdc-.Ldata
	.long .L0xdd-.Ldata
	.long .L0xde-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0xe2-.Ldata
	.long .L0xe3-.Ldata
	.long .L0xe4-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0xea-.Ldata
	.long .L0xeb-.Ldata
	.long .L0xec-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0xf0-.Ldata
	.long .L0xf1-.Ldata
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long .L0xfe-.Ldata
	.long .L0xff-.Ldata
