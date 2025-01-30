	.file	""
	.text
	.globl	msg
	.data
	.align 32
	.type	msg, @object
	.size	msg, 364
msg:
	.ascii	"Switch statements are often implemented using a switch table"
	.ascii	" that consists\nof pointers to code that are ind"
	.string	"exed by the value of the integer being\ntested.  In this assignment, you you will need to decode the switch table to\nfind out the value that will unlock the level.  The assembly output of the\nprogram is in Ch3_06_SwitchTable.s for your viewing convenience\n\n"
	.section	.rodata
.LC0:
	.string	"%s"
	.text
	.globl	print_msg
	.type	print_msg, @function
print_msg:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$msg, %edi
	call	strlen
	movl	%eax, -4(%rbp)
	movl	$0, -16(%rbp)
	jmp	.L2
.L3:
	movl	-16(%rbp), %eax
	movl	$0, %edx
	divl	-4(%rbp)
	movl	%edx, %eax
	movl	%eax, %eax
	movzbl	msg(%rax), %eax
	movsbl	%al, %ecx
	movl	-16(%rbp), %eax
	addl	$1, %eax
	movl	$0, %edx
	divl	-4(%rbp)
	movl	%edx, %eax
	movl	%eax, %eax
	movzbl	msg(%rax), %eax
	movsbl	%al, %eax
	addl	%ecx, %eax
	addl	%eax, -12(%rbp)
	movl	-16(%rbp), %eax
	addl	$1, %eax
	movl	$0, %edx
	divl	-4(%rbp)
	movl	%edx, %eax
	movl	%eax, %eax
	movzbl	msg(%rax), %eax
	movsbl	%al, %ecx
	movl	-16(%rbp), %eax
	addl	$2, %eax
	movl	$0, %edx
	divl	-4(%rbp)
	movl	%edx, %eax
	movl	%eax, %eax
	movzbl	msg(%rax), %eax
	movsbl	%al, %eax
	addl	%ecx, %eax
	addl	%eax, -8(%rbp)
	addl	$1, -16(%rbp)
.L2:
	movl	-4(%rbp), %eax
	imull	$100, %eax, %eax
	cmpl	%eax, -16(%rbp)
	jb	.L3
	movl	-12(%rbp), %eax
	cmpl	-8(%rbp), %eax
	jne	.L4
	movl	$msg, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	jmp	.L6
.L4:
	movl	$msg, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
.L6:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	print_msg, .-print_msg
	.section	.rodata
.LC1:
	.string	"Enter the password: "
.LC2:
	.string	"%d"
.LC3:
	.string	"Try again."
.LC4:
	.string	"Good Job."
	.text
	.globl	main
	.type	main, @function
main:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, %eax
	call	print_msg
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	leaq	-12(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	movl	-12(%rbp), %eax
	subl	$38319, %eax
	cmpl	$4, %eax
	ja	.L8
	movl	%eax, %eax
	movq	.L10(,%rax,8), %rax
	jmp	*%rax
	.section	.rodata
	.align 8
	.align 4
.L10:
	.quad	.L9
	.quad	.L11
	.quad	.L12
	.quad	.L11
	.quad	.L9
	.text
.L9:
	movl	$.LC3, %edi
	call	puts
	jmp	.L13
.L11:
	movl	$.LC3, %edi
	call	puts
	jmp	.L13
.L12:
	movl	$.LC4, %edi
	call	puts
	jmp	.L13
.L8:
	movl	$.LC3, %edi
	call	puts
.L13:
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	xorq	%fs:40, %rdx
	je	.L15
	call	__stack_chk_fail
.L15:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
