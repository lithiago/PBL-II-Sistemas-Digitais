.section .text
.global createMappingMemory
.type createMappingMemory, %function

@ Definições das constantes
HW_REGS_BASE       .equ  0xfc000000       @ Base address
HW_REGS_SPAN       .equ  0x04000000       @ Span size
HW_REGS_MASK       .equ  0x03FFFFFF       @ Mask (SPAN - 1)
ALT_LWFPGASLVS_OFST .equ  0xff200000      @ Offset for FPGA slave address

DATA_A_BASE        .equ  0x80
DATA_B_BASE        .equ  0x70
WRREG_BASE         .equ  0xc0
WRFULL_BASE        .equ  0xb0
SCREEN_BASE        .equ  0xa0
RESET_PULSECOUNTER_BASE .equ  0x90

@ Função createMappingMemory
createMappingMemory:
    @ Abrir o arquivo /dev/mem
    ldr r0, =open                 @ Carrega o endereço da função open
    ldr r1, =filename             @ Carrega o endereço da string "/dev/mem"
    mov r2, #2                    @ Define O_RDWR | O_SYNC (2)
    bl open                       @ Chama a função open (r0 retornará o fd)

    @ Configurações para mmap
    mov r0, #0                    @ NULL (mmap addr)
    ldr r1, =HW_REGS_SPAN         @ Carrega HW_REGS_SPAN (mmap length)
    mov r2, #3                    @ PROT_READ | PROT_WRITE (proteções)
    mov r3, #1                    @ MAP_SHARED (opção de compartilhamento)
    mov r4, r0                    @ Coloca o fd retornado pelo open em r4
    ldr r5, =HW_REGS_BASE         @ Carrega HW_REGS_BASE (mmap offset)
    bl mmap                       @ Chama a função mmap (r0 terá o virtual_base)

    @ Calcular os endereços
    ldr r0, =ALT_LWFPGASLVS_OFST  @ Carrega o offset do FPGA no registrador r0
    ldr r1, =HW_REGS_MASK         @ Carrega a máscara HW_REGS_MASK no registrador r1

    @ Calcula e armazena o endereço h2p_lw_dataA_addr
    ldr r2, =DATA_A_BASE          @ Carrega DATA_A_BASE no registrador r2
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com DATA_A_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r2, r0                @ Soma o virtual_base + offset calculado
    str r2, [r1]                  @ Armazena o valor no endereço h2p_lw_dataA_addr

    @ Calcula e armazena o endereço h2p_lw_dataB_addr
    ldr r2, =DATA_B_BASE          @ Carrega DATA_B_BASE no registrador r2
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com DATA_B_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r2, r0                @ Soma o virtual_base + offset calculado
    str r2, [r1]                  @ Armazena o valor no endereço h2p_lw_dataB_addr

    @ Calcula e armazena o endereço h2p_lw_wrReg_addr
    ldr r2, =WRREG_BASE           @ Carrega WRREG_BASE no registrador r2
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com WRREG_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r2, r0                @ Soma o virtual_base + offset calculado
    str r2, [r1]                  @ Armazena o valor no endereço h2p_lw_wrReg_addr

    @ Calcula e armazena o endereço h2p_lw_wrFull_addr
    ldr r2, =WRFULL_BASE          @ Carrega WRFULL_BASE no registrador r2
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com WRFULL_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r2, r0                @ Soma o virtual_base + offset calculado
    str r2, [r1]                  @ Armazena o valor no endereço h2p_lw_wrFull_addr

    @ Calcula e armazena o endereço h2p_lw_screen_addr
    ldr r2, =SCREEN_BASE          @ Carrega SCREEN_BASE no registrador r2
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com SCREEN_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r2, r0                @ Soma o virtual_base + offset calculado
    str r2, [r1]                  @ Armazena o valor no endereço h2p_lw_screen_addr

    @ Calcula e armazena o endereço h2p_lw_result_pulseCounter_addr
    ldr r2, =RESET_PULSECOUNTER_BASE  @ Carrega RESET_PULSECOUNTER_BASE no registrador r2
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com RESET_PULSECOUNTER_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r2, r0                @ Soma o virtual_base + offset calculado
    str r2, [r1]                  @ Armazena o valor no endereço h2p_lw_result_pulseCounter_addr

    mov r0, #1                    @ Define o retorno como 1 (sucesso)
    bx lr                         @ Retorna da função

@ Definição da string "/dev/mem"
.section .rodata
filename:
    .asciz "/dev/mem"
