.section .data                ; Seção de dados
    msg: .asciz "Hello, World!\n" ; Mensagem a ser exibida

.section .text                ; Seção de código
    .global hello_world       ; Tornar a função global

hello_world:                  ; Início da função
    ldr r0, =1                ; Descritor de arquivo 1 (stdout)
    ldr r1, =msg              ; Endereço da mensagem
    ldr r2, =14               ; Comprimento da mensagem (14 bytes)

    ; Chamada de sistema para escrever na saída padrão
    mov r7, #4                ; Número da chamada de sistema para sys_write
    svc 0                     ; Executa a chamada de sistema

    bx lr                     ; Retorna da função
