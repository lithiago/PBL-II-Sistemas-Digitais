.global map_memory
.section .data
dev_mem_file:
    .asciz "/dev/mem"    @ String para /dev/mem

.section .text
map_memory:
    @ Parâmetros:
    @ r0: tamanho do mapeamento
    @ r1: ponteiro para o descritor de arquivo (fd)

    @ Abrir /dev/mem
    ldr r0, =dev_mem_file  @ r0 aponta para a string "/dev/mem"
    mov r1, #2             @ O_RDWR
    mov r7, #5             @ syscall number para open
    svc #0                 @ Chamada de sistema
    mov r4, r0             @ Salvar o descritor de arquivo em r4

    @ Verificar se a abertura foi bem-sucedida
    cmp r0, #0
    blt open_failed        @ Se r0 < 0, a abertura falhou

    @ Mapear memória
    mov r0, #0             @ Endereço virtual solicitado (NULL para auto)
    mov r1, r0             @ Tamanho (passar o parâmetro de r0)
    mov r2, #3             @ PROT_READ | PROT_WRITE
    mov r3, #1             @ MAP_SHARED
    mov r5, #0             @ Offset
    mov r7, #192           @ syscall number para mmap2
    svc #0                 @ Chamada de sistema

    @ Retornar
    cmp r0, #0             @ Verificar se mmap retornou um valor válido
    blt mmap_failed        @ Se mmap falhou, pular para mmap_failed
    mov r0, r0             @ Mapeamento bem-sucedido, retorna o ponteiro
    b end                  @ Pular para o fim

open_failed:
    mov r0, #0             @ Retornar NULL em caso de falha na abertura
    b end

mmap_failed:
    mov r0, #0             @ Retornar NULL em caso de falha no mmap

end:
    mov r1, r4             @ Passar o descritor de arquivo para o C
    bx r14                 @ Retornar ao chamador
