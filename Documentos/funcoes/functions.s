    .global isFull          @ Torna a função isFull visível globalmente
    .type isFull, %function
    
isFull:
    ldr r1, =h2p_lw_wrFull_addr  @ Carrega o endereço de h2p_lw_wrFull_addr no registrador r1
    ldr r0, [r1]                 @ Carrega o valor no endereço apontado por r1 no registrador r0
    bx lr                        @ Retorna o valor no registrador r0 (registrador de retorno padrão)

    .global dataa_builder
    .type dataa_builder, %function

dataa_builder:
    push {r4, lr}               @ Salva os registradores r4 e lr na pilha
    mov r4, #0                  @ Inicializa o registrador r4 (data) com 0

    cmp r0, #0                  @ Compara opcode (r0) com 0
    beq case_0                  @ Se for igual a 0, vai para case 0
    cmp r0, #3                  @ Compara opcode (r0) com 3
    bgt end_switch              @ Se for maior que 3, sai da função (ou trate o erro)
    b case_1_2_3                @ Se for 1, ou 2, ou 3, vai para case 1, 2 ou 3

case_0:
    orr r4, r4, r1              @ data = data | reg (r4 = r4 | r1)
    lsl r4, r4, #4              @ data = data << 4
    orr r4, r4, r0              @ data = data | opcode (r4 = r4 | r0)
    b end_switch                @ Vai para o fim

case_1_2_3:
    orr r4, r4, r2              @ data = data | memory_address (r4 = r4 | r2)
    lsl r4, r4, #4              @ data = data << 4
    orr r4, r4, r0              @ data = data | opcode (r4 = r4 | r0)

end_switch:
    mov r0, r4                  @ Coloca o resultado em r0 (valor de retorno)
    pop {r4, lr}                @ Restaura os registradores r4 e lr
    bx lr                       @ Retorna da função

    .global sendinstruction
    .type sendinstruction, %function

sendinstruction:
    push {lr}                  @ Salvar o registrador de retorno

    @ Chamar a função isFull() para verificar o status do FIFO
    bl isFull                  @ Chama isFull(), retorna em R0
    cmp r0, #0                 @ Comparar o resultado com 0
    bne end_send               @ Se não for 0, sair da função

    @ FIFO não está cheio, prosseguir com o envio

    @ Escrever 0 em h2p_lw_wrReg_addr (endereçado em 0x60, por exemplo)
    ldr r1, =0x60              @ Carregar o endereço de h2p_lw_wrReg_addr
    mov r0, #0                 @ Carregar o valor 0
    str r0, [r1]               @ Escrever 0 no endereço h2p_lw_wrReg_addr

    @ Escrever dataA em h2p_lw_dataA_addr (endereçado em 0x80, por exemplo)
    ldr r2, =0x80              @ Carregar o endereço de h2p_lw_dataA_addr
    mov r0, r4                 @ Mover dataA para r0 (assumindo que r4 contém dataA)
    str r0, [r2]               @ Escrever dataA em h2p_lw_dataA_addr

    @ Escrever dataB em h2p_lw_dataB_addr (endereçado em 0x70, por exemplo)
    ldr r3, =0x70              @ Carregar o endereço de h2p_lw_dataB_addr
    mov r0, r5                 @ Mover dataB para r0 (assumindo que r5 contém dataB)
    str r0, [r3]               @ Escrever dataB em h2p_lw_dataB_addr

    @ Escrever 1 em h2p_lw_wrReg_addr para iniciar a escrita
    mov r0, #1                 @ Carregar o valor 1
    str r0, [r1]               @ Escrever 1 no endereço h2p_lw_wrReg_addr

    @ Escrever 0 novamente em h2p_lw_wrReg_addr para finalizar a escrita
    mov r0, #0                 @ Carregar o valor 0
    str r0, [r1]               @ Escrever 0 no endereço h2p_lw_wrReg_addr

end_send:
    pop {lr}                   @ Restaurar o registrador de retorno
    bx lr                      @ Retornar da função

    .global createMappingMemory
    .type createMappingMemory, %function
    
createMappingMemory:
    push {r4, r5, r6, r7, lr}     @ Salva os registradores e o endereço de retorno na pilha

    ldr r0, =open_flags           @ Carrega os flags O_RDWR | O_SYNC
    ldr r1, =mem_device           @ Carrega o caminho "/dev/mem"
    bl open                       @ Chama a função open

    ldr r2, =0xFFFFFFFF           @ Carrega o valor 0xFFFFFFFF (equivalente a -1)
    cmp r0, r2                    @ Compara o retorno de open com 0xFFFFFFFF (erro)
    beq error_open                @ Se for 0xFFFFFFFF, vai para erro

    mov r4, r0                    @ Salva o fd (file descriptor) em r4

    ldr r0, =NULL                 @ NULL como primeiro argumento do mmap
    ldr r1, =HW_REGS_SPAN         @ Carrega HW_REGS_SPAN no segundo argumento
    ldr r2, =PROT_READ_WRITE      @ Carrega as permissões PROT_READ | PROT_WRITE
    ldr r3, =MAP_SHARED           @ Carrega a flag MAP_SHARED
    mov r5, r4                    @ Coloca o fd (salvo em r4) em r5
    ldr r6, =HW_REGS_BASE         @ Carrega HW_REGS_BASE
    bl mmap                       @ Chama mmap()

    ldr r2, =MAP_FAILED           @ Carrega MAP_FAILED (indica falha do mmap)
    cmp r0, r2                    @ Verifica se mmap falhou (retorno MAP_FAILED)
    beq error_mmap                @ Se for MAP_FAILED, vai para erro

    mov r7, r0                    @ Salva o retorno de mmap (virtual_base) em r7

    @ Calcula h2p_lw_dataA_addr
    ldr r0, =ALT_LWFPGASLVS_OFST  @ Carrega ALT_LWFPGASLVS_OFST
    ldr r1, =DATA_A_BASE          @ Carrega DATA_A_BASE
    add r0, r0, r1                @ ALT_LWFPGASLVS_OFST + DATA_A_BASE
    ldr r1, =HW_REGS_MASK         @ Carrega HW_REGS_MASK
    and r0, r0, r1                @ Aplica a máscara
    add r0, r7, r0                @ virtual_base + (ALT_LWFPGASLVS_OFST + DATA_A_BASE) & HW_REGS_MASK
    str r0, =h2p_lw_dataA_addr    @ Salva o endereço em h2p_lw_dataA_addr

    @ Calcula h2p_lw_dataB_addr
    ldr r0, =ALT_LWFPGASLVS_OFST
    ldr r1, =DATA_B_BASE
    add r0, r0, r1
    and r0, r0, r1
    add r0, r7, r0
    str r0, =h2p_lw_dataB_addr

    @ Calcule os outros endereços da mesma forma (WRREG_BASE, WRFULL_BASE, SCREEN_BASE, RESET_PULSECOUNTER_BASE)

    mov r0, #1                    @ Retorna 1 (sucesso)
    b end_createMappingMemory

error_open:
    ldr r0, =error_open_str       @ Carrega a string de erro "[ERROR]: could not open..."
    bl printf                     @ Chama printf
    mov r0, #0xFFFFFFFF           @ Retorna 0xFFFFFFFF (equivalente a -1)

    b end_createMappingMemory

error_mmap:
    ldr r0, =error_mmap_str       @ Carrega a string de erro "[ERROR]: mmap() failed..."
    bl printf                     @ Chama printf
    mov r0, r4                    @ Passa o fd para close()
    bl close                      @ Fecha o descritor de arquivo
    mov r0, #0xFFFFFFFF           @ Retorna 0xFFFFFFFF (equivalente a -1)

end_createMappingMemory:
    pop {r4, r5, r6, r7, lr}      @ Restaura os registradores e o endereço de retorno
    bx lr                         @ Retorna da função

    @ Definição das constantes e strings
mem_device:      .asciz "/dev/mem"
error_open_str:  .asciz "[ERROR]: could not open \"/dev/mem\"...\n"
error_mmap_str:  .asciz "[ERROR]: mmap() failed...\n"
open_flags:      .word 0x1010         @ O_RDWR | O_SYNC
PROT_READ_WRITE: .word 0x3            @ PROT_READ | PROT_WRITE
NULL:            .word 0              @ NULL definido como 0
HW_REGS_SPAN:    .word 0x20000        @ Valor para HW_REGS_SPAN
MAP_SHARED:      .word 0x01           @ MAP_SHARED flag
MAP_FAILED:      .word 0xFFFFFFFF     @ Definindo o valor MAP_FAILED para mmap()
HW_REGS_BASE:    .word 0xff200000     @ Valor para HW_REGS_BASE
HW_REGS_MASK:    .word 0xFFFFF        @ Máscara HW_REGS_MASK
DATA_A_BASE:     .word 0x80           @ Base address para DATA_A
DATA_B_BASE:     .word 0x90           @ Base address para DATA_B
WRREG_BASE:      .word 0x100          @ Base address para WRREG
WRFULL_BASE:     .word 0x110          @ Base address para WRFULL
SCREEN_BASE:     .word 0x120          @ Base address para SCREEN
RESET_PULSECOUNTER_BASE: .word 0x130  @ Base address para RESET_PULSECOUNTER
ALT_LWFPGASLVS_OFST: .word 0x40000    @ Offset para ALT_LWFPGASLVS_OFST
