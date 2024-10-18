.section .text
.global createMappingMemory
.type createMappingMemory, %function

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

@ Função createMappingMemory
createMappingMemory:
    @ Abrir o arquivo /dev/mem
    ldr r0, =filename             @ Carrega o endereço da string "/dev/mem"
    mov r1, #2                    @ Define O_RDWR | O_SYNC (2)
    bl open                       @ Chama a função open (r0 retornará o fd)

    mov r4, r0                    @ Armazena o fd em r4

    @ Configurações para mmap
    mov r0, #0                    @ NULL (mmap addr)
    ldr r1, =HW_REGS_SPAN         @ Carrega HW_REGS_SPAN (mmap length)
    mov r2, #3                    @ PROT_READ | PROT_WRITE (proteções)
    mov r3, #1                    @ MAP_SHARED (opção de compartilhamento)
    ldr r5, =HW_REGS_BASE         @ Carrega HW_REGS_BASE (mmap offset)
    mov r6, r4                    @ Coloca o fd (salvo em r4) para a chamada mmap
    bl mmap                       @ Chama a função mmap (r0 terá o virtual_base)

    mov r7, r0                    @ Armazena o virtual_base em r7

    @ Calcular e armazenar os endereços no registrador correspondente

    @ Calcular h2p_lw_dataA_addr
    ldr r0, =ALT_LWFPGASLVS_OFST
    ldr r1, =HW_REGS_MASK
    ldr r2, =DATA_A_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com DATA_A_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r8, r7, r2                @ Armazena o virtual_base + offset calculado em r8

    @ Calcular h2p_lw_dataB_addr
    ldr r2, =DATA_B_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com DATA_B_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r9, r7, r2                @ Armazena o virtual_base + offset calculado em r9

    @ Calcular h2p_lw_wrReg_addr
    ldr r2, =WRREG_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com WRREG_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r10, r7, r2               @ Armazena o virtual_base + offset calculado em r10

    @ Calcular h2p_lw_wrFull_addr
    ldr r2, =WRFULL_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com WRFULL_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r11, r7, r2               @ Armazena o virtual_base + offset calculado em r11

    @ Calcular h2p_lw_screen_addr
    ldr r2, =SCREEN_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com SCREEN_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r12, r7, r2               @ Armazena o virtual_base + offset calculado em r12

    @ Calcular h2p_lw_result_pulseCounter_addr
    ldr r2, =RESET_PULSECOUNTER_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com RESET_PULSECOUNTER_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r13, r7, r2               @ Armazena o virtual_base + offset calculado em r13

    mov r0, #1                    @ Define o retorno como 1 (sucesso)
    bx lr                         @ Retorna da função

@ Definição da string "/dev/mem"
.section .rodata
filename:
    .asciz "/dev/mem"
