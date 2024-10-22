.section .text
.global createMappingMemory
.type createMappingMemory, %function

.section .data
RDWR_OR_SYNC: .word 0x00101002
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
    sub sp, sp, #28
    str r1, [sp, #24]
    str r2, [sp, #20]
    str r3, [sp, #16]
    str r4, [sp, #12]
    str r5, [sp, #8]
    str r7, [sp, #4]

    @ Abrir o arquivo /dev/mem
    ldr r0, =filename             @ Carrega o endereço da string "/dev/mem"
    mov r1, #2
    mov r7, #5                    @ SC/ Open
    svc 0

    mov r2, r0                    @ Armazena o fd em r2

    @ Carregar endereço de fd
    ldr r3, =fd              @ Carrega o endereço de fd
    str r2, [r3]             @ Armazena o fd no endereço de fd

    str r0, [sp, #0]         @ Armazena o fd
    

    @ Configurações para mmap
    mov r0, #0
    ldr r1, =HW_REGS_SPAN
    ldr r1, [r1]      
    mov r2, #3               @ PROT_READ | PROT_WRITE
    mov r3, #1               @ MAP_SHARED
    ldr r4, =fd             
    ldr r4, [r4]             
    ldr r5, =HW_REGS_BASE        
    ldr r5, [r5]
    mov r7, #90             @ SC/ mmap2 = 192; SC/ mmap = 90
    svc 0                 

    mov r2, r0               @ Armazena virtual_base em r2

    @ Carregar endereço e armazenar o valor de virtual_base
    ldr r3, =virtual_base   
    str r2, [r3]

    ldr r0, =ALT_LWFPGASLVS_OFST
    ldr r0, [r0]
    ldr r1, =HW_REGS_MASK
    ldr r1, [r1]
    ldr r2, =DATA_A_BASE
    ldr r2, [r2]

    @ Calcular h2p_lw_dataA_addr
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
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com WRREG_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r3, r2                @ Armazena o virtual_base + offset calculado em r2
    ldr r4, =h2p_lw_wrReg_addr
    str r2, [r4]

    @ Calcular h2p_lw_wrFull_addr
    ldr r2, =WRFULL_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com WRFULL_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r3, r2                @ Armazena o virtual_base + offset calculado em r2
    ldr r4, =h2p_lw_wrFull_addr
    str r2, [r4]


    @ Calcular h2p_lw_screen_addr
    ldr r2, =SCREEN_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com SCREEN_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r3, r2                @ Armazena o virtual_base + offset calculado em r2
    ldr r4, =h2p_lw_screen_addr
    str r2, [r4]

    @ Calcular h2p_lw_result_pulseCounter_addr
    ldr r2, =RESET_PULSECOUNTER_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com RESET_PULSECOUNTER_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r2, r3, r2                @ Armazena o virtual_base + offset calculado em r2
    ldr r4, =h2p_lw_result_pulseCounter_addr
    str r2, [r4]
                                 
    ldr r1, [sp, #24]
    ldr r2, [sp, #20]
    ldr r3, [sp, #16]
    ldr r4, [sp, #12]
    ldr r5, [sp, #8]
    ldr r7, [sp, #4]

    add sp, sp, #24

    mov r0, #1
    bx lr  

@ Definição da string "/dev/mem"
.section .rodata
filename:
    .asciz "/dev/mem"
