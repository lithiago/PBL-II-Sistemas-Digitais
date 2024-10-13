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
