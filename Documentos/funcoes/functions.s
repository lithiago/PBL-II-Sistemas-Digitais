	.syntax unified
	.arch armv7-a
	.eabi_attribute 27, 3
	.eabi_attribute 28, 1
	.fpu vfpv3-d16
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.thumb
	.file	"main.c"
	.comm	virtual_base,4,4
	.comm	h2p_lw_dataA_addr,4,4
	.comm	h2p_lw_dataB_addr,4,4
	.comm	h2p_lw_wrReg_addr,4,4
	.comm	h2p_lw_wrFull_addr,4,4
	.comm	h2p_lw_screen_addr,4,4
	.comm	h2p_lw_result_pulseCounter_addr,4,4
	.comm	fd,4,4
	.section	.rodata
	.align	2
.LC0:
	.ascii	"/dev/mem\000"
	.align	2
.LC1:
	.ascii	"[ERROR]: could not open \"/dev/mem\"...\000"
	.align	2
.LC2:
	.ascii	"[ERROR]: mmap() failed...\000"
	.text
	.align	2
	.global	createMappingMemory
	.thumb
	.thumb_func
	.type	createMappingMemory, %function
createMappingMemory:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #8
	movw	r0, #:lower16:.LC0
	movt	r0, #:upper16:.LC0
	movw	r1, #4098
	movt	r1, 16
	bl	open
	mov	r2, r0
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	str	r2, [r3, #0]
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	cmp	r3, #-1
	bne	.L2
	movw	r0, #:lower16:.LC1
	movt	r0, #:upper16:.LC1
	bl	puts
	mov	r3, #-1
	b	.L3
.L2:
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	str	r3, [sp, #0]
	mov	r3, #-67108864
	str	r3, [sp, #4]
	mov	r0, #0
	mov	r1, #67108864
	mov	r2, #3
	mov	r3, #1
	bl	mmap
	mov	r2, r0
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	str	r2, [r3, #0]
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	cmp	r3, #-1
	bne	.L4
	movw	r0, #:lower16:.LC2
	movt	r0, #:upper16:.LC2
	bl	puts
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	mov	r0, r3
	bl	close
	mov	r3, #-1
	b	.L3
.L4:
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #128
	movw	r3, #:lower16:h2p_lw_dataA_addr
	movt	r3, #:upper16:h2p_lw_dataA_addr
	str	r2, [r3, #0]
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #112
	movw	r3, #:lower16:h2p_lw_dataB_addr
	movt	r3, #:upper16:h2p_lw_dataB_addr
	str	r2, [r3, #0]
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #192
	movw	r3, #:lower16:h2p_lw_wrReg_addr
	movt	r3, #:upper16:h2p_lw_wrReg_addr
	str	r2, [r3, #0]
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #176
	movw	r3, #:lower16:h2p_lw_wrFull_addr
	movt	r3, #:upper16:h2p_lw_wrFull_addr
	str	r2, [r3, #0]
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #160
	movw	r3, #:lower16:h2p_lw_screen_addr
	movt	r3, #:upper16:h2p_lw_screen_addr
	str	r2, [r3, #0]
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #144
	movw	r3, #:lower16:h2p_lw_result_pulseCounter_addr
	movt	r3, #:upper16:h2p_lw_result_pulseCounter_addr
	str	r2, [r3, #0]
	mov	r3, #1
.L3:
	mov	r0, r3
	mov	sp, r7
	pop	{r7, pc}
	.size	createMappingMemory, .-createMappingMemory
	.section	.rodata
	.align	2
.LC3:
	.ascii	"[ERROR]: munmap() failed...\000"
	.text
	.align	2
	.global	closeMappingMemory
	.thumb
	.thumb_func
	.type	closeMappingMemory, %function
closeMappingMemory:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	mov	r0, r3
	mov	r1, #67108864
	bl	munmap
	mov	r3, r0
	cmp	r3, #0
	beq	.L5
	movw	r0, #:lower16:.LC3
	movt	r0, #:upper16:.LC3
	bl	puts
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	mov	r0, r3
	bl	close
.L5:
	pop	{r7, pc}
	.size	closeMappingMemory, .-closeMappingMemory
	.align	2
	.global	isFull
	.thumb
	.thumb_func
	.type	isFull, %function
isFull:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
	movw	r3, #:lower16:h2p_lw_wrFull_addr
	movt	r3, #:upper16:h2p_lw_wrFull_addr
	ldr	r3, [r3, #0]
	ldr	r3, [r3, #0]
	mov	r0, r3
	mov	sp, r7
	pop	{r7}
	bx	lr
	.size	isFull, .-isFull
	.align	2
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
	.type	dataA_builder, %function
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
	.align	2
	.global	setPolygon
	.thumb
	.thumb_func
	.type	setPolygon, %function

setPolygon:
   push {r4,r5,r6,r7,r8,r9,r10,lr} @recebe 7 parametors | 4 em r0,,r1,r2,r3 | o resto na pilha

    @ r0 = address
    @ r1 = opcode
    @ r2 = color
    @ r3 = form
    @ r4 = mult
    @ r5 = ref_point_x
    @ r6 = ref_point_y

    @	unsigned long dataA = dataA_builder(opcode, 0, address);
    mov r7, r1 @botando o opcode (r1) em r7
    mov r8, r0 @botando o address(r0) em r8
    mov r9, r2 @botando o color(r2) em r9

    mov r0, r7 @botando o opcode (r7) em r0
    mov r1, #0 @botando o 0 en r1
    mov r2, r8 @botando o adress(r8) em r2  

    bl dataA_builder               @ Chama a função dataA_builder
    mov r10, r0                     @ dataA = resultado de dataA_bui
    @r10 é o meu dataA

    mov r0, #0 @unsigned long dataB = 0;
    mov r0, r3 @dataB = form;
    lsl r0, r0, #9 @dataB = dataB << 9;
    orr r0, r0, r9 @dataB = dataB | color;
    lsl r0, r0, #4 @dataB = dataB << 4;
    orr r0, r0, r4 @dataB = dataB | mult;
    lsl r0, r0, #9 @dataB = dataB << 9;
    orr r0, r0, r6 @dataB = dataB | ref_point_y;
    lsl r0, r0, #9 @dataB = dataB << 9;
    orr r0, r0, r5 @dataB = dataB | ref_point_x;

    mov r1, r0 @botando o datab(r0) em r1
    mov r0, r10 @botando o dataa(r10) em r0

    bl sendInstruction @chama a funçao sendInstruction
    pop {r4, r5, r6, r7, r8, r9, r10, pc} @ Restaura os registradores e retorna

	.size	setPolygon, .-setPolygon
	.align	2
	.global	set_sprite
	.thumb
	.thumb_func
	.type	set_sprite, %function
set_sprite:
	@ args = 4, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #24
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	str	r3, [r7, #0]
	mov	r0, #0
	ldr	r1, [r7, #12]
	mov	r2, #0
	bl	dataA_builder
	str	r0, [r7, #16]
	mov	r3, #0
	str	r3, [r7, #20]
	ldr	r3, [r7, #32]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #10
	str	r3, [r7, #20]
	ldr	r3, [r7, #8]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #10
	str	r3, [r7, #20]
	ldr	r3, [r7, #4]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #9
	str	r3, [r7, #20]
	ldr	r3, [r7, #0]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r0, [r7, #16]
	ldr	r1, [r7, #20]
	bl	sendInstruction
	add	r7, r7, #24
	mov	sp, r7
	pop	{r7, pc}
	.size	set_sprite, .-set_sprite
	.align	2
	.global	set_background_color
	.thumb
	.thumb_func
	.type	set_background_color, %function

set_background_color:
    push {lr}                  @ Salvar o registrador de retorno
    @ Construir dataA usando dataA_builder(0, 0, 0)
   @ mov r0, #0                 @ opcode = 0
    
    @ Construir a cor a partir de R, G, B
    mov r5, r2                 @ R em r5
    lsl r5, r5, #3             @ R << 3
    mov r6, r1                 @ G em r6
    orr r5, r5, r6             @ R << 3 | G
    lsl r5, r5, #3             @ (R << 3 | G) << 3
    mov r6, r0                 @ B em r6
    orr r5, r5, r6             @ (R << 6 | G << 3) | B -> cor

    mov r0, #0                 @ opcode = 0

    @ Chamar sendInstruction(dataA, color)
   
    mov r1, r5                 @ color em r1
    bl sendInstruction          @ Enviar os dados

    pop {lr}                   @ Restaurar o registrador de retorno
    bx lr                      @ Retornar da função esse codigo de ARMv7
	.size	set_background_color, .-set_background_color
	.align	2
	.global	set_background_block
	.thumb
	.thumb_func
	.type	set_background_block, %function
set_background_block:
	@ args = 4, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #32
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	str	r3, [r7, #0]
	ldr	r2, [r7, #8]
	mov	r3, r2
	lsl	r3, r3, #2
	adds	r3, r3, r2
	lsl	r3, r3, #4
	mov	r2, r3
	ldr	r3, [r7, #12]
	adds	r3, r2, r3
	str	r3, [r7, #20]
	mov	r0, #2
	mov	r1, #0
	ldr	r2, [r7, #20]
	bl	dataA_builder
	str	r0, [r7, #24]
	ldr	r3, [r7, #40]
	str	r3, [r7, #28]
	ldr	r3, [r7, #28]
	lsl	r3, r3, #3
	str	r3, [r7, #28]
	ldr	r3, [r7, #0]
	ldr	r2, [r7, #28]
	orrs	r3, r3, r2
	str	r3, [r7, #28]
	ldr	r3, [r7, #28]
	lsl	r3, r3, #3
	str	r3, [r7, #28]
	ldr	r3, [r7, #4]
	ldr	r2, [r7, #28]
	orrs	r3, r3, r2
	str	r3, [r7, #28]
	ldr	r0, [r7, #24]
	ldr	r1, [r7, #28]
	bl	sendInstruction
	add	r7, r7, #32
	mov	sp, r7
	pop	{r7, pc}
	.size	set_background_block, .-set_background_block
	.align	2
	.global	waitScreen
	.thumb
	.thumb_func
	.type	waitScreen, %function
waitScreen:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #20
	add	r7, sp, #0
	str	r0, [r7, #4]
	mov	r3, #0
	str	r3, [r7, #12]
	b	.L20
.L21:
	movw	r3, #:lower16:h2p_lw_screen_addr
	movt	r3, #:upper16:h2p_lw_screen_addr
	ldr	r3, [r3, #0]
	ldr	r3, [r3, #0]
	cmp	r3, #1
	bne	.L20
	ldr	r3, [r7, #12]
	add	r3, r3, #1
	str	r3, [r7, #12]
	movw	r3, #:lower16:h2p_lw_result_pulseCounter_addr
	movt	r3, #:upper16:h2p_lw_result_pulseCounter_addr
	ldr	r3, [r3, #0]
	mov	r2, #1
	str	r2, [r3, #0]
	movw	r3, #:lower16:h2p_lw_result_pulseCounter_addr
	movt	r3, #:upper16:h2p_lw_result_pulseCounter_addr
	ldr	r3, [r3, #0]
	mov	r2, #0
	str	r2, [r3, #0]
.L20:
	ldr	r2, [r7, #12]
	ldr	r3, [r7, #4]
	cmp	r2, r3
	ble	.L21
	add	r7, r7, #20
	mov	sp, r7
	pop	{r7}
	bx	lr
	.size	waitScreen, .-waitScreen
	.align	2
	.global	increase_coordinate
	.thumb
	.thumb_func
	.type	increase_coordinate, %function
increase_coordinate:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	str	r0, [r7, #4]
	str	r1, [r7, #0]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #8]
	cmp	r3, #7
	bhi	.L22
	adr	r2, .L32
	ldr	pc, [r2, r3, lsl #2]
	.align	2
.L32:
	.word	.L24+1
	.word	.L25+1
	.word	.L26+1
	.word	.L27+1
	.word	.L28+1
	.word	.L29+1
	.word	.L30+1
	.word	.L31+1
.L24:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #20]
	subs	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #0]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L33
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bgt	.L57
	ldr	r3, [r7, #4]
	mov	r2, #640
	str	r2, [r3, #0]
	b	.L57
.L33:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bgt	.L57
	ldr	r3, [r7, #4]
	mov	r2, #1
	str	r2, [r3, #0]
	b	.L57
.L25:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #20]
	adds	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #24]
	subs	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #4]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L35
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L36
	ldr	r3, [r7, #4]
	mov	r2, #480
	str	r2, [r3, #4]
	b	.L58
.L36:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #640
	ble	.L58
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #0]
	b	.L58
.L35:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L38
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #4]
	b	.L58
.L38:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #640
	ble	.L58
	ldr	r3, [r7, #4]
	mov	r2, #640
	str	r2, [r3, #0]
	b	.L58
.L26:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #24]
	subs	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #4]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L39
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L59
	ldr	r3, [r7, #4]
	mov	r2, #480
	str	r2, [r3, #4]
	b	.L59
.L39:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L59
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #4]
	b	.L59
.L27:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #20]
	subs	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #24]
	subs	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #4]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L41
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L42
	ldr	r3, [r7, #4]
	mov	r2, #480
	str	r2, [r3, #4]
	b	.L60
.L42:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bgt	.L60
	ldr	r3, [r7, #4]
	mov	r2, #640
	str	r2, [r3, #0]
	b	.L60
.L41:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L44
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #4]
	b	.L60
.L44:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bgt	.L60
	ldr	r3, [r7, #4]
	mov	r2, #1
	str	r2, [r3, #0]
	b	.L60
.L28:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #20]
	adds	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #0]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L45
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #640
	ble	.L61
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #0]
	b	.L61
.L45:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #620
	ble	.L61
	ldr	r3, [r7, #4]
	mov	r2, #620
	str	r2, [r3, #0]
	b	.L61
.L29:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #20]
	subs	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #24]
	adds	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #4]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L47
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #480
	ble	.L48
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #4]
	b	.L62
.L48:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bgt	.L62
	ldr	r3, [r7, #4]
	mov	r2, #640
	str	r2, [r3, #0]
	b	.L62
.L47:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #480
	ble	.L50
	ldr	r3, [r7, #4]
	mov	r2, #480
	str	r2, [r3, #4]
	b	.L62
.L50:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bgt	.L62
	ldr	r3, [r7, #4]
	mov	r2, #1
	str	r2, [r3, #0]
	b	.L62
.L30:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #24]
	adds	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #4]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L51
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #480
	ble	.L63
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #4]
	b	.L63
.L51:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #480
	ble	.L63
	ldr	r3, [r7, #4]
	mov	r2, #480
	str	r2, [r3, #4]
	b	.L63
.L31:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #20]
	adds	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #24]
	adds	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #4]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L53
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #480
	ble	.L54
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #4]
	b	.L64
.L54:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #640
	ble	.L64
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #0]
	b	.L64
.L53:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #480
	ble	.L56
	ldr	r3, [r7, #4]
	mov	r2, #480
	str	r2, [r3, #4]
	b	.L64
.L56:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #640
	ble	.L64
	ldr	r3, [r7, #4]
	mov	r2, #640
	str	r2, [r3, #0]
	b	.L64
.L57:
	nop
	b	.L22
.L58:
	nop
	b	.L22
.L59:
	nop
	b	.L22
.L60:
	nop
	b	.L22
.L61:
	nop
	b	.L22
.L62:
	nop
	b	.L22
.L63:
	nop
	b	.L22
.L64:
	nop
.L22:
	add	r7, r7, #12
	mov	sp, r7
	pop	{r7}
	bx	lr
	.size	increase_coordinate, .-increase_coordinate
	.align	2
	.global	collision
	.thumb
	.thumb_func
	.type	collision, %function
collision:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #36
	add	r7, sp, #0
	str	r0, [r7, #4]
	str	r1, [r7, #0]
	mov	r3, #15
	str	r3, [r7, #12]
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #12]
	adds	r3, r2, r3
	str	r3, [r7, #16]
	ldr	r3, [r7, #0]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #12]
	adds	r3, r2, r3
	str	r3, [r7, #20]
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #12]
	adds	r3, r2, r3
	str	r3, [r7, #24]
	ldr	r3, [r7, #0]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #12]
	adds	r3, r2, r3
	str	r3, [r7, #28]
	ldr	r3, [r7, #0]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #16]
	cmp	r2, r3
	bge	.L66
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #20]
	cmp	r2, r3
	bge	.L66
	ldr	r3, [r7, #0]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #24]
	cmp	r2, r3
	bge	.L67
	ldr	r2, [r7, #24]
	ldr	r3, [r7, #28]
	cmp	r2, r3
	bge	.L67
	mov	r3, #1
	b	.L68
.L67:
	ldr	r2, [r7, #24]
	ldr	r3, [r7, #28]
	cmp	r2, r3
	bge	.L69
	ldr	r3, [r7, #0]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #24]
	cmp	r2, r3
	bge	.L69
	mov	r3, #1
	b	.L68
.L69:
	ldr	r2, [r7, #24]
	ldr	r3, [r7, #28]
	cmp	r2, r3
	ble	.L70
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #28]
	cmp	r2, r3
	bge	.L70
	mov	r3, #1
	b	.L68
.L70:
	ldr	r2, [r7, #24]
	ldr	r3, [r7, #28]
	cmp	r2, r3
	ble	.L66
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #28]
	cmp	r2, r3
	bge	.L66
	mov	r3, #1
	b	.L68
.L66:
	mov	r3, #0
.L68:
	mov	r0, r3
	add	r7, r7, #36
	mov	sp, r7
	pop	{r7}
	bx	lr
	.size	collision, .-collision
	.align	2