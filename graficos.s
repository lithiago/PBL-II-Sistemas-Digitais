.global init_graphics
init_graphics:
    bx lr                         @ Retorna da função sem fazer nada (não implementada)

.global draw_sprite
draw_sprite:
    bx lr                         @ Retorna da função sem fazer nada (não implementada)

.global draw_pixel
draw_pixel:
    push {r4, r5, r6, r7, lr}     @ Salva registradores R4, R5, R6, R7 e LR no stack

    @ Endereço base da memória de vídeo (VGA)
    ldr r1, =0xFF200000           @ Carrega o endereço base da memória de vídeo no registrador r1

    @ Parâmetros recebidos:
    @ r0: coordenada y (linha)
    @ r1: coordenada x (coluna)
    @ r2: cor (valor da cor em 32 bits)

    @ Carrega os valores das coordenadas e da cor para registradores temporários
    mov r3, r0                    @ r3 = y (linha)
    mov r4, r1                    @ r4 = x (coluna)
    mov r5, r2                    @ r5 = cor (32 bits)

    @ Calcular a posição na memória de vídeo
    mov r6, #640                  @ r6 = largura da tela (640 pixels por linha)
    mul r7, r3, r6                @ r7 = y * 640
    add r7, r7, r4                @ r7 = (y * 640) + x, posição no buffer de vídeo

    @ Multiplica r7 por 4, pois cada pixel tem 4 bytes (32 bits por pixel) e armazena no endereço correto
    lsl r7, r7, #2                @ r7 = r7 * 4 (desloca bits 2 posições para a esquerda)

    @ Calcula o endereço final adicionando r7 ao endereço base (r1)
    add r0, r1, r7                @ r0 = endereço final de vídeo (base + offset calculado)

    @ Escreve o valor da cor no endereço calculado
    str r5, [r0]                  @ Armazena r5 (cor) no endereço r0

    pop {r4, r5, r6, r7, lr}      @ Restaura os registradores salvos
    bx lr                         @ Retorna da função
