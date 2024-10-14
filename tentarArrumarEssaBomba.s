.section .text
.global createMappingMemory
.type createMappingMemory, %function

@ Definições das constantes
.section .data
virtual_base: .word 0
h2p_lw_dataA_addr: .word 0
h2p_lw_dataB_addr: .word 0
h2p_lw_wrReg_addr: .word 0
h2p_lw_wrFull_addr: .word 0
h2p_lw_screen_addr: .word 0
h2p_lw_result_pulseCounter_addr: .word 0
fd: .word 0
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

@ Função createMappingMemory
createMappingMemory:
    @ Abrir o arquivo /dev/mem
    ldr r0, =filename             @ Carrega o endereço da string "/dev/mem"
    movw	r1, #4098
	movt	r1, 16                @ Define O_RDWR | O_SYNC (2)
    bl open                       @ Chama a função open (r0 retornará o fd)

    mov r2, r0                    @ Armazena o fd em r2

    @ Carregar endereço de fd
    ldr r3, =fd              @ Carrega o endereço de fd
    str r2, [r3]             @ Armazena o fd no endereço de fd

    @ Verificar se fd foi armazenado corretamente
    ldr r3, [r3]             @ Carrega o valor armazenado em fd

    @ Configurações para mmap
    ldr r3, =fd              @ Carrega novamente o endereço de fd
    ldr r3, [r3]             @ Carrega o valor de fd
    str r3, [sp]             @ Armazena em [sp]
    mov r3, #-67108864       @ Valor de offset, ajuste conforme necessário
    str r3, [sp, #4]         @ Armazena em [sp + 4]

    mov r0, #0               @ NULL (mmap addr)
    mov r1, #67108864        @ Tamanho para mmap
    mov r2, #3               @ PROT_READ | PROT_WRITE
    mov r3, #1               @ MAP_SHARED
    bl mmap                  @ Chama a função mmap

    mov r2, r0               @ Armazena virtual_base em r2

    @ Carregar endereço de virtual_base
    ldr r3, =fd              @ Carrega o endereço de virtual_base
    str r2, [r3]             @ Armazena o virtual_base no endereço de virtual_base

    @ Verificar se virtual_base foi armazenado corretamente
    ldr r3, [r3]             @ Carrega o valor armazenado em virtual_base


    @ Calcular e armazenar os endereços no registrador correspondente

    @ Calcular h2p_lw_dataA_addr
    ldr r0, =ALT_LWFPGASLVS_OFST
    ldr r1, =HW_REGS_MASK
    ldr r2, =DATA_A_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com DATA_A_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r3, r2                @ Armazena o virtual_base + offset calculado em r2
    ldr r4, =h2p_lw_dataA_addr    @ Carrega o endereço de h2p_lw_dataA_addr
    str r2, [r4]                  @ Armazena o h2p_lw_dataA_addr no endereço de h2p_lw_dataA_addr

    @ Calcular h2p_lw_dataB_addr
    ldr r2, =DATA_B_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com DATA_B_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r3, r2                @ Armazena o virtual_base + offset calculado em r2
    ldr r4, =h2p_lw_dataB_addr
    str r2, [r4]

    @ Calcular h2p_lw_wrReg_addr
    ldr r2, =WRREG_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com DATA_B_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r3, r2                @ Armazena o virtual_base + offset calculado em r2
    ldr r4, =h2p_lw_wrReg_addr
    str r2, [r4]

    @ Calcular h2p_lw_wrFull_addr
    ldr r2, =WRFULL_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com DATA_B_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r3, r2                @ Armazena o virtual_base + offset calculado em r2
    ldr r4, =h2p_lw_wrFull_addr
    str r2, [r4]


    @ Calcular h2p_lw_screen_addr
    ldr r2, =SCREEN_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com DATA_B_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r3, r2                @ Armazena o virtual_base + offset calculado em r2
    ldr r4, =h2p_lw_screen_addr
    str r2, [r4]

    @ Calcular h2p_lw_result_pulseCounter_addr
    ldr r2, =RESET_PULSECOUNTER_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com DATA_B_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r3, r2                @ Armazena o virtual_base + offset calculado em r2
    ldr r4, =h2p_lw_result_pulseCounter_addr
    str r2, [r4]

    mov r0, #1                    @ Define o retorno como 1 (sucesso)
    bx lr                         @ Retorna da função

@ Definição da string "/dev/mem"
.section .rodata
filename:
    .asciz "/dev/mem"






@ @ Definição da string "/dev/mem"
@ .section .rodata
@ filename:
@     .asciz "/dev/mem"


@ 	.syntax unified
@ 	.arch armv7-a
@ 	.eabi_attribute 27, 3
@ 	.eabi_attribute 28, 1
@ 	.fpu vfpv3-d16
@ 	.eabi_attribute 20, 1
@ 	.eabi_attribute 21, 1
@ 	.eabi_attribute 23, 3
@ 	.eabi_attribute 24, 1
@ 	.eabi_attribute 25, 1
@ 	.eabi_attribute 26, 2
@ 	.eabi_attribute 30, 6
@ 	.eabi_attribute 34, 1
@ 	.eabi_attribute 18, 4
@ 	.thumb
@ 	.file	"main.c"
@ 	.comm	virtual_base,4,4
@ 	.comm	h2p_lw_dataA_addr,4,4
@ 	.comm	h2p_lw_dataB_addr,4,4
@ 	.comm	h2p_lw_wrReg_addr,4,4
@ 	.comm	h2p_lw_wrFull_addr,4,4
@ 	.comm	h2p_lw_screen_addr,4,4
@ 	.comm	h2p_lw_result_pulseCounter_addr,4,4
@ 	.comm	fd,4,4
@ 	.section	.rodata
@ 	.align	2
@ .LC0:
@ 	.ascii	"/dev/mem\000"
@ 	.align	2
@ .LC1:
@ 	.ascii	"[ERROR]: could not open \"/dev/mem\"...\000"
@ 	.align	2
@ .LC2:
@ 	.ascii	"[ERROR]: mmap() failed...\000"
@ 	.text
@ 	.align	2
@ 	.global	createMappingMemory
@ 	.thumb
@ 	.thumb_func
@ 	.type	createMappingMemory, %function
@ createMappingMemory:
@ 	@ args = 0, pretend = 0, frame = 0
@ 	@ frame_needed = 1, uses_anonymous_args = 0
@ 	push	{r7, lr}
@ 	sub	sp, sp, #8
@ 	add	r7, sp, #8
@ 	movw	r0, #:lower16:.LC0
@ 	movt	r0, #:upper16:.LC0
@ 	movw	r1, #4098
@ 	movt	r1, 16
@ 	bl	open
@ 	mov	r2, r0
@ 	movw	r3, #:lower16:fd
@ 	movt	r3, #:upper16:fd
@ 	str	r2, [r3, #0]
@ 	movw	r3, #:lower16:fd
@ 	movt	r3, #:upper16:fd
@ 	ldr	r3, [r3, #0]
@ 	cmp	r3, #-1
@ 	bne	.L2
@ 	movw	r0, #:lower16:.LC1
@ 	movt	r0, #:upper16:.LC1
@ 	bl	puts
@ 	mov	r3, #-1
@ 	b	.L3
@ .L2:
@ 	movw	r3, #:lower16:fd
@ 	movt	r3, #:upper16:fd
@ 	ldr	r3, [r3, #0]
@ 	str	r3, [sp, #0]
@ 	mov	r3, #-67108864
@ 	str	r3, [sp, #4]
@ 	mov	r0, #0
@ 	mov	r1, #67108864
@ 	mov	r2, #3
@ 	mov	r3, #1
@ 	bl	mmap
@ 	mov	r2, r0
@ 	movw	r3, #:lower16:virtual_base
@ 	movt	r3, #:upper16:virtual_base
@ 	str	r2, [r3, #0]
@ 	movw	r3, #:lower16:virtual_base
@ 	movt	r3, #:upper16:virtual_base
@ 	ldr	r3, [r3, #0]
@ 	cmp	r3, #-1
@ 	bne	.L4
@ 	movw	r0, #:lower16:.LC2
@ 	movt	r0, #:upper16:.LC2
@ 	bl	puts
@ 	movw	r3, #:lower16:fd
@ 	movt	r3, #:upper16:fd
@ 	ldr	r3, [r3, #0]
@ 	mov	r0, r3
@ 	bl	close
@ 	mov	r3, #-1
@ 	b	.L3
@ .L4:
@ 	movw	r3, #:lower16:virtual_base
@ 	movt	r3, #:upper16:virtual_base
@ 	ldr	r3, [r3, #0]
@ 	add	r2, r3, #52428800
@ 	add	r2, r2, #128
@ 	movw	r3, #:lower16:h2p_lw_dataA_addr
@ 	movt	r3, #:upper16:h2p_lw_dataA_addr
@ 	str	r2, [r3, #0]
@ 	movw	r3, #:lower16:virtual_base
@ 	movt	r3, #:upper16:virtual_base
@ 	ldr	r3, [r3, #0]
@ 	add	r2, r3, #52428800
@ 	add	r2, r2, #112
@ 	movw	r3, #:lower16:h2p_lw_dataB_addr
@ 	movt	r3, #:upper16:h2p_lw_dataB_addr
@ 	str	r2, [r3, #0]
@ 	movw	r3, #:lower16:virtual_base
@ 	movt	r3, #:upper16:virtual_base
@ 	ldr	r3, [r3, #0]
@ 	add	r2, r3, #52428800
@ 	add	r2, r2, #192
@ 	movw	r3, #:lower16:h2p_lw_wrReg_addr
@ 	movt	r3, #:upper16:h2p_lw_wrReg_addr
@ 	str	r2, [r3, #0]
@ 	movw	r3, #:lower16:virtual_base
@ 	movt	r3, #:upper16:virtual_base
@ 	ldr	r3, [r3, #0]
@ 	add	r2, r3, #52428800
@ 	add	r2, r2, #176
@ 	movw	r3, #:lower16:h2p_lw_wrFull_addr
@ 	movt	r3, #:upper16:h2p_lw_wrFull_addr
@ 	str	r2, [r3, #0]
@ 	movw	r3, #:lower16:virtual_base
@ 	movt	r3, #:upper16:virtual_base
@ 	ldr	r3, [r3, #0]
@ 	add	r2, r3, #52428800
@ 	add	r2, r2, #160
@ 	movw	r3, #:lower16:h2p_lw_screen_addr
@ 	movt	r3, #:upper16:h2p_lw_screen_addr
@ 	str	r2, [r3, #0]
@ 	movw	r3, #:lower16:virtual_base
@ 	movt	r3, #:upper16:virtual_base
@ 	ldr	r3, [r3, #0]
@ 	add	r2, r3, #52428800
@ 	add	r2, r2, #144
@ 	movw	r3, #:lower16:h2p_lw_result_pulseCounter_addr
@ 	movt	r3, #:upper16:h2p_lw_result_pulseCounter_addr
@ 	str	r2, [r3, #0]
@ 	mov	r3, #1
@ .L3:
@ 	mov	r0, r3
@ 	mov	sp, r7
@ 	pop	{r7, pc}
@ 	.size	createMappingMemory, .-createMappingMemory
@ 	.section	.rodata
@ 	.align	2
@ .LC3:
@ 	.ascii	"[ERROR]: munmap() failed...\000"
@ 	.text
@ 	.align	2
@ 	.global	closeMappingMemory
@ 	.thumb
@ 	.thumb_func
@ 	.type	closeMappingMemory, %function
