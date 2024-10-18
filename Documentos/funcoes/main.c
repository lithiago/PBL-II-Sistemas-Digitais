#include <stdio.h>
#include <stdint.h>
#include "graphic_processor.h"
#include "hps_0.h"
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

#define HW_REGS_BASE 0xfc000000
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 ) //0x3FFFFFF
#define ALT_LWFPGASLVS_OFST 0xff200000

#define SCREEN_WIDTH 800  // Largura da tela
#define SCREEN_HEIGHT 600 // Altura da tela
#define POLYGON_SIZE 50   // Tamanho do lado do quadrado

int main(){
    createMappingMemory();
    //if (createMappingMemory() != -1){
		// r0 - vermelho, r1 - azul, r2 - verde
        set_background_color(0b000,0b111,0b111);
    //}
	 int form = 0; // Definição do formato do polígono (ajuste conforme necessário)
    int color = 0xFF00FF; // Cor do polígono (exemplo: roxo)
    int mult = 1; // Fator de multiplicação (ajuste conforme necessário)

    // Calcular o ponto de referência para o centro da tela
    int ref_point_x = SCREEN_WIDTH / 2;
    int ref_point_y = SCREEN_HEIGHT / 2;

    // Os pontos do quadrado (pode variar conforme a implementação)
    int vertices[4][2] = {
        { ref_point_x - POLYGON_SIZE / 2, ref_point_y - POLYGON_SIZE / 2 }, // Canto superior esquerdo
        { ref_point_x + POLYGON_SIZE / 2, ref_point_y - POLYGON_SIZE / 2 }, // Canto superior direito
        { ref_point_x + POLYGON_SIZE / 2, ref_point_y + POLYGON_SIZE / 2 }, // Canto inferior direito
        { ref_point_x - POLYGON_SIZE / 2, ref_point_y + POLYGON_SIZE / 2 }  // Canto inferior esquerdo
    };

    // Chamar a função para definir os pontos do polígono (isso depende da sua implementação)
    // Supondo que você tenha uma função que configura os pontos do polígono, como setPolygon
	//int i = 0;
    //for (i = 0; i < 4; i++) {
		setPolygon(0b000000001, 0b0011, 0b11111111, 1, 0b0001, 50, 50);
		//void setPolygon(int address, int opcode, int color, int form, int mult, int ref_point_x, int ref_point_y);
    //}

    // Aguarde ou finalize o desenho, conforme necessário
    printf("Quadrado desenhado no centro da tela.\n");
    closeMappingMemory();
}
/*


@ Definições das constantes
HW_REGS_BASE:       .word  0xfc000000       @ Base address
HW_REGS_SPAN:       .word  0x04000000       @ Span size
HW_REGS_MASK:       .word  0x03FFFFFF       @ Mask (SPAN - 1)
ALT_LWFPGASLVS_OFST: .word  0xff200000      @ Offset for FPGA slave address

DATA_A_BASE:        .word  0x80
DATA_B_BASE:        .word  0x70
WRREG_BASE:         .word  0xc0
WRFULL_BASE:        .word  0xb0
SCREEN_BASE:        .word  0xa0
RESET_PULSECOUNTER_BASE: .word  0x90

.global isFull          
.type isFull, %function

isFull:
    ldr r1, =h2p_lw_wrFull_addr  @ Carrega o endereço de h2p_lw_wrFull_addr no registrador r1
    ldr r0, [r1]                 @ Carrega o valor no endereço apontado por r1 no registrador r0
    bx lr                        @ Retorna o valor no registrador r0

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

.global sendinstruction
.type sendinstruction, %function

sendinstruction:
    push {lr}                  @ Salvar o registrador de retorno

    @ Chamar a função isFull() para verificar o status do FIFO
    bl isFull                  @ Chama isFull(), retorna em R0
    cmp r0, #0                 @ Comparar o resultado com 0
    bne end_send               @ Se não for 0, sair da função

    @ FIFO não está cheio, prosseguir com o envio

    @ Escrever 0 em h2p_lw_wrReg_addr
    ldr r1, =h2p_lw_wrReg_addr @ Carregar o endereço de h2p_lw_wrReg_addr
    mov r0, #0                 @ Carregar o valor 0
    str r0, [r1]               @ Escrever 0 no endereço h2p_lw_wrReg_addr

    @ Escrever dataA em h2p_lw_dataA_addr
    ldr r2, =h2p_lw_dataA_addr @ Carregar o endereço de h2p_lw_dataA_addr
    str r4, [r2]               @ Escrever dataA em h2p_lw_dataA_addr (assumindo que r4 contém dataA)

    @ Escrever dataB em h2p_lw_dataB_addr
    ldr r3, =h2p_lw_dataB_addr @ Carregar o endereço de h2p_lw_dataB_addr
    str r5, [r3]               @ Escrever dataB em h2p_lw_dataB_addr (assumindo que r5 contém dataB)

    @ Escrever 1 em h2p_lw_wrReg_addr para iniciar a escrita
    mov r0, #1                 @ Carregar o valor 1
    str r0, [r1]               @ Escrever 1 no endereço h2p_lw_wrReg_addr

    @ Escrever 0 novamente em h2p_lw_wrReg_addr para finalizar a escrita
    mov r0, #0                 @ Carregar o valor 0
    str r0, [r1]               @ Escrever 0 no endereço h2p_lw_wrReg_addr

end_send:
    pop {lr}                   @ Restaurar o registrador de retorno
    bx lr                      @ Retornar da função

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

.global set_background_color
.type set_background_color, %function

set_background_color:
    push {lr}                  @ Salvar o registrador de retorno

    @ Construir dataA usando dataA_builder(0, 0, 0)
    mov r0, #0                 @ opcode = 0
    mov r1, #0                 @ segundo argumento = 0
    mov r2, #0                 @ terceiro argumento = 0
    bl dataa_builder           @ Chama dataa_builder
    mov r4, r0                 @ Armazenar dataA retornado em r4

    @ Construir a cor a partir de R, G, B
    mov r5, r1                 @ R em r5
    lsl r5, r5, #3             @ R << 3
    mov r6, r2                 @ G em r6
    orr r5, r5, r6             @ R << 3 | G
    lsl r5, r5, #3             @ (R << 3 | G) << 3
    mov r6, r0                 @ B em r6
    orr r5, r5, r6             @ (R << 6 | G << 3) | B -> cor

    @ Chamar sendInstruction(dataA, color)
    mov r0, r4                 @ dataA em r0
    mov r1, r5                 @ color em r1
    bl sendInstruction          @ Enviar os dados

    pop {lr}                   @ Restaurar o registrador de retorno
    bx lr                      @ Retornar da função
 

@ Função createMappingMemory
createMappingMemory:
    @ Abrir o arquivo /dev/mem
    ldr r0, =filename             @ Carrega o endereço da string "/dev/mem"
    mov r1, #2                    @ Define O_RDWR | O_SYNC (2)
    bl open                       @ Chama a função open (r0 retornará o fd)

    mov r4, r0                    @ Armazena o fd em r4

    @ Verifica se a abertura foi bem-sucedida
    cmp r4, #0                    @ Verifica se fd é negativo
    blt open_failed               @ Se for, falha ao abrir

    @ Configurações para mmap
    mov r0, #0                    @ NULL (mmap addr)
    ldr r1, =HW_REGS_SPAN         @ Carrega HW_REGS_SPAN (mmap length)
    mov r2, #3                    @ PROT_READ | PROT_WRITE (proteções)
    mov r3, #1                    @ MAP_SHARED (opção de compartilhamento)
    ldr r5, =HW_REGS_BASE         @ Carrega HW_REGS_BASE (mmap offset)
    mov r6, r4                    @ Coloca o fd (salvo em r4) para a chamada mmap
    svc #0                        @ Chama o kernel para mmap

    @ Verifica se mmap falhou
    cmp r0, #0
    blt mmap_failed               @ Se mmap falhar, pular para mmap_failed
    mov r7, r0                    @ Armazena o virtual_base em r7

    @ Calcular e armazenar os endereços no registrador correspondente
    ldr r0, =ALT_LWFPGASLVS_OFST
    ldr r1, =HW_REGS_MASK

    @ Calcular h2p_lw_dataA_addr
    ldr r2, =DATA_A_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com DATA_A_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r8, r7, r2                @ Armazena o virtual_base + offset calculado em r8

    @ Calcular h2p_lw_dataB_addr
    ldr r2, =DATA_B_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com DATA_B_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r9, r7, r2                @ Armazena o virtual_base + offset calculado em r9

    @ Calcular h2p_lw_wrReg_addr
    ldr r2, =WRREG_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com WRREG_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r10, r7, r2               @ Armazena o virtual_base + offset calculado em r10

    @ Calcular h2p_lw_wrFull_addr
    ldr r2, =WRFULL_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com WRFULL_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r11, r7, r2               @ Armazena o virtual_base + offset calculado em r11

    @ Calcular h2p_lw_screen_addr
    ldr r2, =SCREEN_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com SCREEN_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r12, r7, r2               @ Armazena o virtual_base + offset calculado em r12

    @ Calcular h2p_lw_result_pulseCounter_addr
    ldr r2, =RESET_PULSECOUNTER_BASE
    add r2, r0, r2                @ Soma o offset ALT_LWFPGASLVS_OFST com RESET_PULSECOUNTER_BASE
    and r2, r2, r1                @ Aplica a máscara HW_REGS_MASK
    add r13, r7, r2               @ Armazena o virtual_base + offset calculado em r13

    mov r0, #1                    @ Define o retorno como 1 (sucesso)
    bx lr                         @ Retorna da função

open_failed:
    ldr r0, =error_open_msg       @ Mensagem de erro para falha ao abrir
    bl printf
    mov r0, #0                    @ Retorna 0 em caso de falha
    bx lr                         @ Retorna da função

mmap_failed:
    ldr r0, =error_mmap_msg       @ Mensagem de erro para falha no mmap
    bl printf
    mov r0, #0                    @ Retorna 0 em caso de falha
    bx lr                         @ Retorna da função

@ Definição da string /dev/mem
.section .rodata
filename:
    .asciz "/dev/mem"
error_open_msg:
    .asciz "[ERROR]: could not open \"/dev/mem\"...\n"
error_mmap_msg:
    .asciz "[ERROR]: mmap() failed...\n"



	set_background_color:
    push {lr}                  @ Salvar o registrador de retorno

    @ Construir dataA usando dataA_builder(0, 0, 0)
    mov r0, #0                 @ opcode = 0
    
    @ Construir a cor a partir de R, G, B
    mov r5, r1                 @ R em r5
    lsl r5, r5, #3             @ R << 3
    mov r6, r2                 @ G em r6
    orr r5, r5, r6             @ R << 3 | G
    lsl r5, r5, #3             @ (R << 3 | G) << 3
    mov r6, r0                 @ B em r6
    orr r5, r5, r6             @ (R << 6 | G << 3) | B -> cor

    @ Chamar sendInstruction(dataA, color)
   
    mov r1, r5                 @ color em r1
    bl sendInstruction          @ Enviar os dados

    pop {lr}                   @ Restaurar o registrador de retorno
    bx lr                      @ Retornar da função esse codigo de ARMv7

*/