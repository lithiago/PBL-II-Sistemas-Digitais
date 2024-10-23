#include "graphic_processor.c"
#include <stdio.h>
#include <stdint.h>
#include "graphic_processor.h"
#include "hps_0.h"
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

#define HW_REGS_BASE 0xfc000000
#define HW_REGS_SPAN (0x04000000)
#define HW_REGS_MASK (HW_REGS_SPAN - 1) // 0x3FFFFFF
#define ALT_LWFPGASLVS_OFST 0xff200000

#define SCREEN_WIDTH 800  // Largura da tela
#define SCREEN_HEIGHT 600 // Altura da tela
#define POLYGON_SIZE 50   // Tamanho do lado do quadrado

int main()
{
    createMappingMemory();

    set_background_block(0b111000, 0b111000, 0b111, 0b111, 0b111);
    set_background_block(0b111000, 0b111001, 0b000, 0b000, 0b000);
    set_background_block(0b111001, 0b111000, 0b000, 0b000, 0b000);
    set_background_block(0b111001, 0b111001, 0b000, 0b000, 0b000);
    int i = 0;
    int j = 0;

/*verificar o estado de armaze
namento (0 = vazio, 1 = cheia) das FIFOs de instruc¸˜ ao (Fig.
 3). */

    for (i=0; i < 60; i++)
    {
        for (j=0; j < 80; j++)
        {
            while(isFull() == 1){}
            set_background_block(j, i, 0b000, 0b000, 0b000);
        }
    }
    // Aguarde ou finalize o desenho, conforme necessário
    printf("Quadrado desenhado no centro da tela.\n");
    closeMappingMemory();
}