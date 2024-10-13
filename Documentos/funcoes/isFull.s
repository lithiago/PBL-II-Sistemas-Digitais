    .global isFull          @ Torna a função isFull visível globalmente
    .type isFull, %function
    
isFull:
    ldr r1, =h2p_lw_wrFull_addr  @ Carrega o endereço de h2p_lw_wrFull_addr no registrador r1
    ldr r0, [r1]                 @ Carrega o valor no endereço apontado por r1 no registrador r0
    bx lr                        @ Retorna o valor no registrador r0 (registrador de retorno padrão)
