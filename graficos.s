.global draw_pixel
draw_pixel:
    push {r4, r5, r6, r7, lr}     @ Salva registradores R4, R5, R6, R7 e LR

    @ Endereço base da memória de vídeo (VGA), usando movw e movt
    movw r6, #:lower16:0xFF200000  @ Carrega a parte baixa do endereço
    movt r6, #:upper16:0xFF200000  @ Carrega a parte alta do endereço

    @ Parâmetros recebidos:
    @ r0: coordenada y
    @ r1: coordenada x
    @ r2: cor

    @ Carrega a coordenada y, x e cor
    mov r3, r0                    @ r3 = y
    mov r4, r1                    @ r4 = x
    mov r5, r2                    @ r5 = cor (32 bits)

    @ Calcular a posição na memória de vídeo
    mov r7, #640                  @ Largura da tela (640)
    mul r7, r3, r7                @ r7 = y * 640
    add r7, r7, r4                @ r7 = (y * 640) + x

    @ Escrever a cor no endereço calculado (multiplicado por 4)
    str r5, [r6, r7, lsl #2]      @ Escreve a cor no endereço calculado

    pop {r4, r5, r6, r7, lr}      @ Restaura os registradores
    bx lr                         @ Retorna da função
