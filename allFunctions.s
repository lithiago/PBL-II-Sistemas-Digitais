    @ Constantes para mapeamento de memória
    .equ HW_REGS_BASE, 0xfc000000   @ Base de registradores
    .equ HW_REGS_SPAN, 0x04000000   @ Tamanho da região mapeada
    .equ HW_REGS_MASK, 0x03FFFFFF   @ Máscara
    .equ ALT_LWFPGASLVS_OFST, 0xff200000 @ Offset para registradores da FPGA
    
    .data
    fd:         .word 0             @ File descriptor para /dev/mem
    virtual_base: .word 0           @ Base virtual mapeada
    h2p_lw_dataA_addr: .word 0      @ Endereço mapeado de DATA_A
    h2p_lw_dataB_addr: .word 0      @ Endereço mapeado de DATA_B
    h2p_lw_wrReg_addr: .word 0      @ Endereço mapeado de WRREG
    h2p_lw_wrFull_addr: .word 0     @ Endereço mapeado de WRFULL
    h2p_lw_screen_addr: .word 0     @ Endereço mapeado de SCREEN
    h2p_lw_result_pulseCounter_addr: .word 0 @ Endereço mapeado do pulse counter

    .text
    .global _start

_start:
    bl createMappingMemory

    @ Checa se o mapeamento foi bem sucedido
    cmp r0, #1
    bne end_program

    @ Exemplo: verificar se o FIFO está cheio usando a função isFull
    bl isFull


end_program:
    mov r7, #1        @ Código de system call para exit
    mov r0, #0        @ Código de retorno 0
    svc #0

createMappingMemory:
    @ Abre /dev/mem com as permissões corretas
    mov r7, #5        @ Código de system call para open
    ldr r0, =dev_mem  @ Ponteiro para string "/dev/mem"
    mov r1, #2        @ O_RDWR
    mov r2, #0x1000   @ O_SYNC
    svc #0
    mov r4, r0        @ Armazena o file descriptor em r4
    str r4, [fd]

    @ Mapeia a memória para acessar os registradores da FPGA
    mov r7, #192      @ System call para mmap
    mov r0, #0        @ NULL (endereçamento automático)
    ldr r1, =HW_REGS_SPAN
    mov r2, #3        @ PROT_READ | PROT_WRITE
    mov r3, #0x01     @ MAP_SHARED
    ldr r4, [fd]      @ File descriptor (fd)
    ldr r5, =HW_REGS_BASE  @ Base dos registradores de hardware
    svc #0
    mov r4, r0        @ Guarda o endereço virtual em r4
    str r4, [virtual_base]

    @ Verifica se mmap falhou
    addi r0, #1                             @correto????
    beq mmap_failed

    @ Calcula os endereços mapeados para os registradores da FPGA
    ldr r0, [virtual_base]
    ldr r1, =ALT_LWFPGASLVS_OFST
    add r0, r0, r1
    ldr r2, =DATA_A_BASE
    add r0, r0, r2
    str r0, [h2p_lw_dataA_addr]

    @ Repetir para os outros registradores (DATA_B, WRREG, WRFULL)
    ldr r0, [virtual_base]
    ldr r2, =DATA_B_BASE
    add r0, r0, r2
    str r0, [h2p_lw_dataB_addr]

    @ Outros endereços de registradores mapeados
    ...

    @ Sucesso, retorna 1
    mov r0, #1
    bx lr

mmap_failed:
    @ mmap falhou, retorna -1
    mov r0, #-1
    bx lr

isFull:
    @ Verifica se o FIFO está cheio
    ldr r0, [h2p_lw_wrFull_addr]  @ Carrega o endereço de WRFULL
    ldr r0, [r0]                  @ Carrega o valor em WRFULL
    bx lr                         @ Retorna o valor

sendInstruction:
    @ Checa se o FIFO está cheio
    bl isFull
    cmp r0, #0
    bne fifo_full

    @ Escreve 0 no registrador WRREG para iniciar
    ldr r0, [h2p_lw_wrReg_addr]
    mov r1, #0
    str r1, [r0]

    @ Escreve os valores de dataA e dataB
    ldr r0, [h2p_lw_dataA_addr]
    str r1, [r0]
    ldr r0, [h2p_lw_dataB_addr]
    str r2, [r0]

    @ Finaliza a escrita no WRREG
    ldr r0, [h2p_lw_wrReg_addr]
    mov r1, #1
    str r1, [r0]
    mov r1, #0
    str r1, [r0]
    bx lr

fifo_full:
    @ Caso FIFO esteja cheio, retorna
    bx lr

dev_mem:
    .ascii "/dev/mem\0"
