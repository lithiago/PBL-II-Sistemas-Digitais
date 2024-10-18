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

@ Definições de syscalls
.data
filename: .asciz "/dev/mem"  @ Nome do arquivo a ser aberto
sys_open: .word 5                 @ Número da syscall para open
sys_map: .word 192                @ Número da syscall para mmap2
page_len: .word 4096              @ Tamanho da página

@ Função createMappingMemory

createMappingMemory:
    ldr r0, =filename            @ Carrega o endereço do nome do arquivo em r0
    mov r1, #2                   @ Flags de abertura (O_RDWR)
    orr r1, r1, #0x00000080      @ Adiciona O_SYNC (bit 7)
    mov r7, #5                   @ Número da syscall para open
    svc #0                        @ Chamada de sistema
    movs r4, r0                  @ Armazena o descritor de arquivo em r4

    cmp r0, #0                   @ Verifica se houve erro na abertura
    blt open_failed              @ Salta para open_failed se r0 < 0

    bx lr
    
/*     ldr r1, =page_len            @ Carrega o tamanho da página
    mov r0, #0                   @ Endereço virtual solicitado (NULL para auto)
    mov r2, #3                   @ PROT_READ | PROT_WRITE
    mov r3, #1                   @ MAP_SHARED
    mov r5, #0                   @ Offset
    mov r7, #192                 @ Número da syscall para mmap2
    svc #0                       @ Chamada de sistema
    movs r5, r0                  @ Armazena o endereço mapeado em r5

    cmp r0, #0                   @ Verifica se houve erro no mapeamento
    blt map_failed               @ Salta para map_failed se r0 < 0

    bx lr                        @ Retorna da função
 */
open_failed:
    mov r0, #2                   @ Código de erro (1)
    bx lr                        @ Retorna da função

map_failed:
    mov r0, #2                   @ Código de erro (2)
    bx lr                        @ Retorna da função

/*createMappingMemory:
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
    .asciz "/dev/mem"*/
