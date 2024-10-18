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
