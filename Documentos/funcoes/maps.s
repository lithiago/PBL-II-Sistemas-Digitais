.section .text
.global createMappingMemory
.type createMappingMemory, %function


@ Definições de syscalls
.data
filename: .asciz "/dev/mem"  @ Nome do arquivo a ser aberto
sys_open: .word 5                 @ Número da syscall para open
sys_map: .word 192                @ Número da syscall para mmap2
page_len: .word 4096              @ Tamanho da página
@ Definições das constantes
@HW_REGS_BASE       .word  0xfc000000       @ Base address
@HW_REGS_SPAN       .word  0x04000000       @ Span size
@HW_REGS_MASK       .word  0x03FFFFFF       @ Mask (SPAN - 1)
@ALT_LWFPGASLVS_OFST .word  0xff200000      @ Offset for FPGA slave address

@DATA_A_BASE        .word  0x80
@DATA_B_BASE        .word  0x70
@WRREG_BASE         .word  0xc0
@WRFULL_BASE        .word  0xb0
@SCREEN_BASE        .word  0xa0
@RESET_PULSECOUNTER_BASE .word  0x90

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
    

open_failed:
    mov r0, #2                   @ Código de erro (1)
    bx lr                        @ Retorna da função

map_failed:
    mov r0, #2                   @ Código de erro (2)
    bx lr                        @ Retorna da função

