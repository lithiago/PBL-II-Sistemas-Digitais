    .global sendinstruction
    .type sendinstruction, %function

sendinstruction:
    push {lr}                  @ Salvar o registrador de retorno

    @ Chamar a função isFull() para verificar o status do FIFO
    bl isfull                  @ Chama isFull(), retorna em R0
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
