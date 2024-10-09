.global somaValores   @ Define a função `somaValores` como global para poder ser chamada externamente

somaValores:
    @ A função recebe dois parâmetros:
    @ r0: primeiro valor (valor1)
    @ r1: segundo valor (valor2)

    add r0, r0, r1    @ Soma o valor de r0 (valor1) e r1 (valor2) e armazena o resultado em r0

    bx lr             @ Retorna da função usando o registrador LR (link register)
