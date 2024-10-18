#include <stdio.h>
#include "functions.h"

int main(){

    if (createMappingMemory() == -1) {
        printf("Erro ao mapear memória.\n");
        return -1; // Encerra caso ocorra um erro
    }

    return 0;
}

/*

@ Definição das constantes e strings
mem_device:      .asciz "/dev/mem"
error_open_str:  .asciz "[ERROR]: could not open \"/dev/mem\"...\n"
error_mmap_str:  .asciz "[ERROR]: mmap() failed...\n"
open_flags:      .word 0x1010         @ O_RDWR | O_SYNC
PROT_READ_WRITE: .word 0x3            @ PROT_READ | PROT_WRITE
NULL:            .word 0              @ NULL definido como 0
HW_REGS_SPAN:    .word 0x20000        @ Valor para HW_REGS_SPAN
MAP_SHARED:      .word 0x01           @ MAP_SHARED flag
MAP_FAILED:      .word 0xFFFFFFFF     @ Definindo o valor MAP_FAILED para mmap()
HW_REGS_BASE:    .word 0xff200000     @ Valor para HW_REGS_BASE
HW_REGS_MASK:    .word 0xFFFFF        @ Máscara HW_REGS_MASK
DATA_A_BASE:     .word 0x80           @ Base address para DATA_A
DATA_B_BASE:     .word 0x90           @ Base address para DATA_B
WRREG_BASE:      .word 0x100          @ Base address para WRREG
WRFULL_BASE:     .word 0x110          @ Base address para WRFULL
SCREEN_BASE:     .word 0x120          @ Base address para SCREEN
RESET_PULSECOUNTER_BASE: .word 0x130  @ Base address para RESET_PULSECOUNTER
ALT_LWFPGASLVS_OFST: .word 0x40000    @ Offset para ALT_LWFPGASLVS_OFST

@ Definição das variáveis
h2p_lw_wrFull_addr:          .word 0
h2p_lw_wrReg_addr:           .word 0
h2p_lw_dataA_addr:           .word 0
h2p_lw_dataB_addr:           .word 0
h2p_lw_screen_addr:          .word 0
h2p_lw_result_pulseCounter_addr: .word 0
virtual_base:                .word 0
fd:                          .word 0
error_msg:                  .asciz "[ERROR]: Failed to unmap memory.\n"


createMappingMemory:
    push {r4, r5, lr}         @ Salvar os registradores que vamos usar

    ldr r0, =mem_device       @ Carregar o nome do dispositivo em r0
    ldr r1, =open_flags       @ Carregar flags de abertura
    bl open                   @ Chamar a função open

    cmp r0, #0                @ Verificar se fd é negativo
    blt error_open            @ Se fd < 0, ir para error_open

    ldr r4, =HW_REGS_BASE     @ Carregar o endereço base para mapeamento
    ldr r5, =HW_REGS_SPAN     @ Carregar o tamanho do mapeamento
    bl mmap                   @ Chamar mmap

    cmp r0, #MAP_FAILED       @ Verificar se mmap falhou
    beq error_mmap            @ Se falhou, ir para error_mmap

    ldr r1, =virtual_base     @ Carregar virtual_base
    str r0, [r1]              @ Salvar o endereço mapeado

    pop {r4, r5, lr}          @ Restaurar registradores
    bx lr                     @ Retornar

error_open:
    ldr r0, =error_open_str    @ Carregar mensagem de erro
    bl puts                    @ Exibir mensagem
    pop {r4, r5, lr}          @ Restaurar registradores
    bx lr                     @ Retornar

error_mmap:
    ldr r0, =error_mmap_str    @ Carregar mensagem de erro
    bl puts                    @ Exibir mensagem
    pop {r4, r5, lr}          @ Restaurar registradores
    bx lr                     @ Retornar
*/
