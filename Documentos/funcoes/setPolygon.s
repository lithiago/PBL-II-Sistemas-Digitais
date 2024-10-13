    .global setPolygon         @ Mantenha o nome consistente
    .type setPolygon, %function

setPolygon:
    push {lr}                  @ Salvar o registrador de retorno

    @ Montar o dataA chamando dataa_builder(opcode, 0, address)
    mov r2, #0                 @ Segundo argumento: registrador 0
    bl dataa_builder           @ Chamar a função para construir o dataA
    mov r4, r0                 @ DataA retornado em r0, mover para r4

    @ Montar o dataB (form, color, mult, ref_point_y, ref_point_x)
    mov r5, r1                 @ r1 = form
    lsl r5, r5, #9             @ Deslocar form 9 bits para a esquerda

    mov r6, r2                 @ r2 = color
    orr r5, r5, r6             @ Combinar form com color
    lsl r5, r5, #4             @ Deslocar combinação 4 bits para a esquerda

    mov r6, r3                 @ r3 = mult
    orr r5, r5, r6             @ Combinar com mult
    lsl r5, r5, #9             @ Deslocar combinação 9 bits para a esquerda

    mov r6, r4                 @ r4 = ref_point_y
    orr r5, r5, r6             @ Combinar com ref_point_y
    lsl r5, r5, #9             @ Deslocar combinação 9 bits para a esquerda

    mov r6, r5                 @ r5 = ref_point_x
    orr r5, r5, r6             @ Combinar com ref_point_x

    @ Chamar a função sendinstruction(dataA, dataB)
    mov r0, r4                 @ Mover dataA (r4) para r0
    mov r1, r5                 @ Mover dataB (r5) para r1
    bl sendinstruction          @ Enviar os dados ao processador gráfico

    pop {lr}                   @ Restaurar o registrador de retorno
    bx lr                      @ Retornar da função
