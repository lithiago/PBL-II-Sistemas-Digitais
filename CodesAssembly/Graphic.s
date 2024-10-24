.section .text
.global Graphic
.type mapMemory, %function

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
page_len: .word 4096
fpga_base: .word 0xff200
@ Função createMappingMemory
mapMemory:
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


fifo_check:
    ldr r0, =h2p_lw_wrFull_addr   @ Carrega o endereço da FIFO no r0
    ldr r0, [r0]                  @ Carrega o valor da FIFO (0: VAZIO, 1: CHEIO) em r0
    bx lr                         @ Retorna ao chamador


send_instruction:
    @r0 - dataA
    @r1 - dataB
    sub sp, sp, #12               @ Aloca espaço na pilha para salvar r2, r3 e lr
    str r2, [sp, #8]              @ Salva r2 (parâmetro dataA) na pilha
    str r3, [sp, #4]              @ Salva r3 (parâmetro dataB) na pilha
    str lr, [sp, #0]              @ Salva lr na pilha

    mov r2, r0                    @ Move dataA para r2
    mov r3, r1                    @ Move dataB para r3

    bl fifo_check                 @ Chama a função fifo_check

    cbnz r0, return_from_send      @ Se FIFO estiver cheia, retorna sem fazer nada

    ldr r4, =h2p_lw_wrReg_addr     @ Carrega o endereço de h2p_lw_wrReg_addr para r4
    mov r4, #0                    @ Coloca 0 em r4 para o controle de escrita

    ldr r5, =h2p_lw_dataA_addr     @ Carrega o endereço de dataA em r5
    str r2, [r5]                  @ Coloca dataA no endereço correspondente

    ldr r6, =h2p_lw_dataB_addr     @ Carrega o endereço de dataB em r6
    str r3, [r6]                  @ Coloca dataB no endereço correspondente

    ldr r7, =h2p_lw_wrReg_addr     @ Carrega o endereço de wrReg em r7
    str r4, [r7]                  @ Coloca 0 no registro de escrita
    
return_from_send:
    ldr lr, [sp, #0]              @ Restaura lr da pilha
    ldr r3, [sp, #4]              @ Restaura r3 da pilha (parâmetro dataB)
    ldr r2, [sp, #8]              @ Restaura r2 da pilha (parâmetro dataA)
    add sp, sp, #12               @ Libera espaço na pilha
    bx lr                         @ Retorna para a função chamadora

 dataA_construtor:
    @r0 - opcode
    @r1 - reg
    @r2 - memory_address

    mov r3, #0               @ Inicializa r3 com 0
    cmp r0, #0               @ Compara o opcode (r0) com 0
    bne diferente_de_zero     @ Se r0 for diferente de 0, pula para diferente_de_zero

    @ Bloco para r0 == 0
    orr r3, r3, r1            @ r3 = r3 | r1 (insere reg no r3)
    lsl r3, r3, #2            @ Desloca r3 2 bits à esquerda
    orr r3, r3, r0            @ r3 = r3 | r0 (insere opcode no r3)

    mov r0, r3                @ Move o valor final para r0
    bx lr                     @ Retorna da função

diferente_de_zero:
    @ Bloco para r0 != 0
    orr r3, r3, r2            @ r3 = r3 | r2 (insere memory_address no r3)
    lsl r3, r3, #4            @ Desloca r3 2 bits à esquerda
    orr r3, r3, r0            @ r3 = r3 | r0 (insere opcode no r3)
    
    mov r0, r3                @ Move o valor final para r0
    bx lr                     @ Retorna da função


set_background_color:
    sub sp, sp, #16               @ Aloca espaço na pilha para salvar r2, r3 e lr
    str r0, [sp, #12]              @ Salva r2 (parâmetro dataA) na pilha
    str r1, [sp, #8]              @ Salva r3 (parâmetro dataB) na pilha
    str r2, [sp, #4]              @ Salva lr na pilha
    str lr, [sp, #0]              @ Salva lr na pilha

    b dataA_construtor

    mov r3, r0 @carrega o retorno em r3
    ldr r0, [sp, #12]
    ldr r1, [sp, #8]
    ldr r2, [sp, #4]
    mov r4, r2 @Carrega B em color
    lsl r4, r4, #3 @Desloca 2^3
    orr r4, r4, r1 @ (color | G)
    lsl r4, r4, #3
    orr r4, r4, r0 @ (color | R)

    mov r0, r3
    mov r1, r4

    b send_instruction

    ldr lr, [sp, #0]              @ Restaura lr da pilha
    ldr r0, [sp, #4]              @ Restaura r3 da pilha (parâmetro dataB)
    ldr r1, [sp, #8]              @ Restaura r2 da pilha (parâmetro dataA)
    ldr r2, [sp, #12]              @ Restaura r2 da pilha (parâmetro dataA)
    add sp, sp, #16               @ Libera espaço na pilha
    bx lr                         @ Retorna para a função chamadora

@ Definição da string "/dev/mem"
.section .rodata
filename:
    .asciz "/dev/mem"
