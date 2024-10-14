.section .text
.global createMappingMemory
.global closeMappingMemory
.type createMappingMemory, %function
.type closeMappingMemory, %function
.type isFull, %function
.type sendInstruction, %function
.type dataA_builder, %function

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

    @ Verifica falha no mmap
    cmp r0, #-1                   @ Verifica se mmap retornou -1 (falha)
    beq mmap_error                @ Se falhou, vai para o tratamento de erro

    @ Calcula os endereços mapeados (exemplo de h2p_lw_dataA_addr)
    ldr r0, =ALT_LWFPGASLVS_OFST  @ Carrega o offset do FPGA no registrador r0
    ldr r1, =DATA_A_BASE          @ Carrega DATA_A_BASE no registrador r1
    add r1, r0, r1                @ Soma o offset ALT_LWFPGASLVS_OFST com DATA_A_BASE
    and r1, r1, #HW_REGS_MASK     @ Aplica a máscara HW_REGS_MASK
    add r1, r1, r0                @ Soma o virtual_base + offset calculado
    str r1, [r0]                  @ Armazena o valor no endereço h2p_lw_dataA_addr

    mov r0, #1                    @ Define o retorno como 1 (sucesso)
    bx lr                         @ Retorna da função

mmap_error:
    ldr r0, =error_msg            @ Carrega a mensagem de erro
    bl printf                     @ Chama printf para imprimir o erro
    b end                         @ Vai para o final

@ Função closeMappingMemory
closeMappingMemory:
    ldr r0, =virtual_base         @ Carrega o endereço de virtual_base no r0
    ldr r1, =HW_REGS_SPAN         @ Carrega HW_REGS_SPAN no r1
    bl munmap                     @ Chama munmap(virtual_base, HW_REGS_SPAN)

    cmp r0, #0                    @ Verifica se munmap falhou
    bne unmap_error               @ Se falhou, vai para a rotina de erro

    bx lr                         @ Retorna (sucesso)

unmap_error:
    ldr r0, =error_msg            @ Carrega a mensagem de erro
    bl printf                     @ Imprime a mensagem de erro
    ldr r0, =fd                   @ Carrega o descritor de arquivo fd
    bl close                      @ Fecha o arquivo /dev/mem
    bx lr                         @ Retorna

end:
    bx lr                         @ Fim da função

@ Função isFull
isFull:
    ldr r0, =h2p_lw_wrFull_addr    @ Carrega o endereço de h2p_lw_wrFull_addr em r0
    ldr r1, [r0]                  @ Carrega o valor armazenado no endereço apontado por r0 (valor do registrador wrFull)
    mov r0, r1                    @ Move o valor lido para o registrador de retorno r0
    bx lr                        @ Retorna da função
@ Função sendInstruction
sendInstruction:
    push {r0, r1, r2, r3}             @ Empilha r0, r1, r2 e r3 para preservar o estado

    mov r0, r0                        @ r0 contém dataA (primeiro parâmetro)
    mov r1, r1                        @ r1 contém dataB (segundo parâmetro)

    @ Verifica se a pilha está cheia
    bl isFull                         @ Chama a função isFull, o resultado vai em r0
    cbz r0, end_send                 @ Se isFull() retornar 0, continua com o envio

    @ Se não está cheio, continua a execução
    ldr r2, =h2p_lw_wrReg_addr        @ Carrega o endereço de h2p_lw_wrReg_addr em r2
    ldr r3, [r2]                      @ Carrega o endereço armazenado em h2p_lw_wrReg_addr em r3
    mov r0, #0                        @ Prepara o valor 0 para armazenar
    str r0, [r3]                      @ Armazena 0 no endereço apontado por r3

    ldr r2, =h2p_lw_dataA_addr        @ Carrega o endereço de h2p_lw_dataA_addr em r2
    str r0, [r2]                      @ Armazena dataA no endereço de h2p_lw_dataA_addr

    ldr r2, =h2p_lw_dataB_addr        @ Carrega o endereço de h2p_lw_dataB_addr em r2
    str r1, [r2]                      @ Armazena dataB no endereço de h2p_lw_dataB_addr

    ldr r2, =h2p_lw_wrReg_addr        @ Carrega o endereço de h2p_lw_wrReg_addr em r2
    ldr r3, [r2]                      @ Carrega o endereço armazenado em h2p_lw_wrReg_addr em r3
    mov r0, #1                        @ Prepara o valor 1 para armazenar
    str r0, [r3]                      @ Armazena 1 no endereço apontado por r3

    str r0, [r3]                      @ Armazena 0 novamente em h2p_lw_wrReg_addr para finalização

end_send:
    pop {r0, r1, r2, r3}              @ Desempilha os registradores
    bx lr                               @ Retorna da função

@ Função dataA_builder
dataA_builder:
    push {r4, r5, r6}              @ Empilha r4, r5 e r6 para preservar o estado

    mov r4, #0                     @ r4 irá armazenar o valor de 'data' (inicialmente 0)
    mov r5, r0                     @ r5 irá armazenar 'opcode' (primeiro parâmetro)
    mov r6, r1                     @ r6 irá armazenar 'reg' (segundo parâmetro)

    cmp r5, #0                     @ Compara 'opcode' com 0
    beq case0                      @ Se opcode == 0, salta para case0

    cmp r5, #3                     @ Compara 'opcode' com 3
    blt default_case               @ Se opcode < 3 (ou seja, 1 ou 2), salta para default_case

    @ default_case para opcode 1, 2 ou 3
    lsl r4, r6, #4                 @ Desloca 'reg' 4 bits para a esquerda
    orr r4, r4, r5                 @ 'data = data | opcode'
    b end_function                 @ Salta para o fim da função

case0:
    lsl r4, r6, #4                 @ Desloca 'reg' 4 bits para a esquerda
    orr r4, r4, r5                 @ 'data = data | opcode'

default_case:
    lsl r4, r0, #4                 @ Desloca 'memory_address' 4 bits para a esquerda
    orr r4, r4, r5                 @ 'data = data | opcode'

end_function:
    mov r0, r4                     @ Move o valor final de 'data' para r0 (retorno da função)
    pop {r4, r5, r6}               @ Desempilha os registradores
    bx lr                          @ Retorna da função

setPolygon:
    setPolygon:
    push {r4, r5, r6, r7, r8}            @ Empilha registradores para preservar o estado

    @ Carrega os parâmetros
    mov r4, r0                            @ r4 = address
    mov r5, r1                            @ r5 = opcode
    mov r6, r2                            @ r6 = color
    mov r7, r3                            @ r7 = form
    mov r8, r4                            @ r8 = mult (usar r8 para evitar conflito)

    @ Chama a função dataA_builder
    mov r0, r5                            @ Passa 'opcode' em r0
    mov r1, #0                            @ Passa 0 em r1 (segundo parâmetro)
    mov r2, r4                            @ Passa 'address' em r2
    bl dataA_builder                      @ Chama dataA_builder, resultado em r0

    @ O resultado de dataA_builder está agora em r1 (dataA)
    mov r1, r0                            @ Armazena o resultado de dataA_builder em r1 (dataA)

    @ Inicializa dataB (usando r2 para evitar sobrescrever r0)
    mov r2, r7                            @ r2 = form
    lsl r2, r2, #9                        @ dataB = form << 9
    orr r2, r2, r6                        @ dataB = dataB | color
    lsl r2, r2, #4                        @ dataB = dataB << 4
    orr r2, r2, r8                        @ dataB = dataB | mult
    lsl r2, r2, #9                        @ dataB = dataB << 9
    orr r2, r2, r3                        @ dataB = dataB | ref_point_y
    lsl r2, r2, #9                        @ dataB = dataB << 9
    orr r2, r2, r4                        @ dataB = dataB | ref_point_x

    @ Envia os dados para sendInstruction
    mov r0, r1                            @ Primeiro argumento: dataA (em r1)
    mov r1, r2                            @ Segundo argumento: dataB (em r2)
    bl sendInstruction                    @ Chama sendInstruction(dataA, dataB)

    pop {r4, r5, r6, r7, r8}              @ Desempilha os registradores
    bx lr                                 @ Retorna da função


@ Função Sprite
set_sprite:
    push {r4, r5, r6, r7, r8}              @ Empilha registradores para preservar o estado

    @ Carrega os parâmetros
    mov r4, r0                            @ r4 = registrador
    mov r5, r1                            @ r5 = x
    mov r6, r2                            @ r6 = y
    mov r7, r3                            @ r7 = offset
    mov r8, r4                            @ r8 = activation_bit (usar r8 para evitar conflito)

    @ Chama a função dataA_builder
    mov r0, #0                            @ Passa 0 para opcode
    mov r1, r4                            @ Passa registrador em r1
    mov r2, #0                            @ Passa 0 como memory_address
    bl dataA_builder                       @ Chama dataA_builder, resultado em r0

    @ O resultado de dataA_builder está agora em r0
    mov r0, r0                            @ Armazena o resultado de dataA_builder em r0 (dataA)

    @ Inicializa dataB
    mov r1, r8                            @ r1 = activation_bit
    orr r1, r1, r0                        @ dataB = activation_bit (inicializa dataB com activation_bit)
    lsl r1, r1, #10                       @ dataB = dataB << 10

    orr r1, r1, r5                        @ dataB = dataB | x
    lsl r1, r1, #10                       @ dataB = dataB << 10

    orr r1, r1, r6                        @ dataB = dataB | y
    lsl r1, r1, #9                        @ dataB = dataB << 9

    orr r1, r1, r7                        @ dataB = dataB | offset

    @ Envia os dados para sendInstruction
    bl sendInstruction                     @ Chama sendInstruction(dataA, dataB)

    pop {r4, r5, r6, r7, r8}              @ Desempilha os registradores
    bx lr                                  @ Retorna da função

@ Função set_background_color
set_background_color:
    push {r4, r5, r6, r7}               @ Empilha registradores para preservar o estado

    mov r4, r0                          @ r4 = R
    mov r5, r1                          @ r5 = G
    mov r6, r2                          @ r6 = B

    @ Chama a função dataA_builder
    mov r0, #0                          @ Passa 0 para opcode
    mov r1, #0                          @ Passa 0 para reg
    mov r2, #0                          @ Passa 0 como memory_address
    bl dataA_builder                     @ Chama dataA_builder, resultado em r0

    @ O resultado de dataA_builder está agora em r0
    mov r1, r0                          @ Armazena o resultado de dataA_builder em r1 (dataA)

    @ Inicializa color
    mov r2, r6                          @ r2 = B
    lsl r2, r2, #3                      @ color = B << 3

    orr r2, r2, r5                      @ color = color | G
    lsl r2, r2, #3                      @ color = color << 3

    orr r2, r2, r4                      @ color = color | R

    @ Envia os dados para sendInstruction
    bl sendInstruction                   @ Chama sendInstruction(dataA, color)

    pop {r4, r5, r6, r7}                @ Desempilha os registradores
    bx lr                                @ Retorna da função

.section .text
.global set_background_block

set_background_block:
    push {r4, r5, r6}                    @ Empilha registradores para preservar o estado

    @ Carrega os parâmetros
    mov r4, r0                           @ r4 = column
    mov r5, r1                           @ r5 = line
    mov r6, r2                           @ r6 = R (mais tarde)
    mov r3, r2                           @ r3 = G (mais tarde)
    
    @ Calcula o endereço
    mul r5, r5, #80                      @ r5 = line * 80
    add r5, r5, r4                       @ r5 = (line * 80) + column

    @ Chama a função dataA_builder
    mov r0, #2                           @ Passa 2 para opcode
    mov r1, #0                           @ Passa 0 para reg
    mov r2, r5                           @ Passa address (line * 80 + column)
    bl dataA_builder                     @ Chama dataA_builder, resultado em r0

    @ O resultado de dataA_builder está agora em r0
    mov r1, r0                           @ Armazena o resultado de dataA_builder em r1 (dataA)

    @ Inicializa color
    mov r2, r3                           @ r2 = B (presumido estar em r3)
    lsl r2, r2, #3                       @ color = B << 3

    orr r2, r2, r4                       @ color = color | G (presumido estar em r4)
    lsl r2, r2, #3                       @ color = color << 3

    orr r2, r2, r6                       @ color = color | R (presumido estar em r6)

    @ Envia os dados para sendInstruction
    bl sendInstruction                    @ Chama sendInstruction(dataA, color)

    pop {r4, r5, r6}                     @ Desempilha os registradores
    bx lr                                 @ Retorna da função

@ Função Wait Screen
waitScreen:
    push {r4, r5}                      @ Salva r4 e r5 na pilha

    mov r4, r0                         @ r4 = limit (o limite de telas)
    mov r5, #0                         @ r5 = screens (contador de telas desenhadas)

loop:
    ldr r0, =h2p_lw_screen_addr        @ Carrega o endereço de h2p_lw_screen_addr em r0
    ldr r0, [r0]                       @ Lê o valor em h2p_lw_screen_addr (1 ou 0)
    cmp r0, #1                         @ Compara se o valor é igual a 1
    bne loop                           @ Se não for, volta para o início do loop

    @ Incrementa o contador de telas
    add r5, r5, #1                     @ screens++

    @ Reseta o contador de pulsos de resultado
    ldr r0, =h2p_lw_result_pulseCounter_addr @ Carrega o endereço de h2p_lw_result_pulseCounter_addr
    mov r1, #1                         @ Coloca 1 em r1
    str r1, [r0]                       @ Escreve 1 no endereço
    str r1, [r0]                       @ Escreve 0 no endereço (reset)

    cmp r5, r4                         @ Compara screens com limit
    ble loop                           @ Se screens <= limit, continua o loop

    pop {r4, r5}                       @ Restaura r4 e r5 da pilha
    bx lr                               @ Retorna da função
@ Definição das strings
.section .rodata
filename:
    .asciz "/dev/mem"

error_msg:
    .asciz "[ERROR]: mmap() or munmap() failed...\n"
