

@ Definições das constantes
HW_REGS_BASE:       .word  0xfc000000       @ Base address
HW_REGS_SPAN:       .word  0x04000000       @ Span size
HW_REGS_MASK:       .word  0x03FFFFFF       @ Mask (SPAN - 1)
ALT_LWFPGASLVS_OFST: .word  0xff200000      @ Offset for FPGA slave address

DATA_A_BASE:        .word  0x80
DATA_B_BASE:        .word  0x70
WRREG_BASE:         .word  0xc0
WRFULL_BASE:        .word  0xb0
SCREEN_BASE:        .word  0xa0
RESET_PULSECOUNTER_BASE: .word  0x90



.global dataA_builder
.type dataA_builder, %function
.arch armv7-a

dataA_builder:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #28
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	mov	r3, #0
	str	r3, [r7, #20]
	ldr	r3, [r7, #12]
	cmp	r3, #0
	beq	.L12
	cmp	r3, #0
	blt	.L11
	cmp	r3, #3
	bgt	.L11
	b	.L14
.L12:
	ldr	r3, [r7, #8]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #4
	str	r3, [r7, #20]
	ldr	r3, [r7, #12]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	b	.L11
.L14:
	ldr	r3, [r7, #4]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #4
	str	r3, [r7, #20]
	ldr	r3, [r7, #12]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	nop
.L11:
	ldr	r3, [r7, #20]
	mov	r0, r3
	add	r7, r7, #28
	mov	sp, r7
	pop	{r7}
	bx	lr
	.size	dataA_builder, .-dataA_builder

.global sendInstruction
.type sendInstruction, %function

.global	sendInstruction
	.thumb
	.thumb_func
	.type	sendInstruction, %function
sendInstruction:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	str	r1, [r7, #0]
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L8
	movw	r3, #:lower16:h2p_lw_wrReg_addr
	movt	r3, #:upper16:h2p_lw_wrReg_addr
	ldr	r3, [r3, #0]
	mov	r2, #0
	str	r2, [r3, #0]
	movw	r3, #:lower16:h2p_lw_dataA_addr
	movt	r3, #:upper16:h2p_lw_dataA_addr
	ldr	r3, [r3, #0]
	ldr	r2, [r7, #4]
	str	r2, [r3, #0]
	movw	r3, #:lower16:h2p_lw_dataB_addr
	movt	r3, #:upper16:h2p_lw_dataB_addr
	ldr	r3, [r3, #0]
	ldr	r2, [r7, #0]
	str	r2, [r3, #0]
	movw	r3, #:lower16:h2p_lw_wrReg_addr
	movt	r3, #:upper16:h2p_lw_wrReg_addr
	ldr	r3, [r3, #0]
	mov	r2, #1
	str	r2, [r3, #0]
	movw	r3, #:lower16:h2p_lw_wrReg_addr
	movt	r3, #:upper16:h2p_lw_wrReg_addr
	ldr	r3, [r3, #0]
	mov	r2, #0
	str	r2, [r3, #0]
.L8:
	add	r7, r7, #8
	mov	sp, r7
	pop	{r7, pc}
	.size	sendInstruction, .-sendInstruction
	.align	2
	.thumb
	.thumb_func

 

