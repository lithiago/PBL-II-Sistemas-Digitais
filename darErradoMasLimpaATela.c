#include "graphic_processor.c"
#include <stdio.h>
#include <stdlib.h>
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

#define SCREEN_WIDTH 700  // Largura da tela
#define SCREEN_HEIGHT 600 // Altura da tela
#define POLYGON_SIZE 50   // Tamanho do lado do quadrado

void setQuadrado(int coluna, int linha, int R, int G, int B){
	int pcol = coluna;
	for (pcol ; pcol < pcol + 4; pcol++){
		set_background_block(pcol, linha, R, G, B);
	}

}

int main(){
    createMappingMemory();

	//set_background_block(0b111000, 0b111000, 0b111, 0b111, 0b111);
	//set_background_block(1, 0, 0b111, 0b111, 0b111); //coluna / linha
	//set_background_block(20, 0, 0b111, 0b111, 0b111); //coluna / linha
	// set_background_block(0b111000, 0b111001, 0b000, 0b000, 0b000);
	// set_background_block(0b111001, 0b111000, 0b000, 0b000, 0b000);
	// set_background_block(0b111001, 0b111001, 0b000, 0b000, 0b000);
	int i = 0;
    //clear_background();
	//i += 2;
	//clear_background();
	while(1){ if(isFull() == 0) { setQuadrado(1, 1, 0b111, 0b111, 0b111); break; } }

	//setQuadrado(5,5,2,2,2);
	//clear_background1();
	//clear_background2();

    // Aguarde ou finalize o desenho, conforme necessário
    printf("Quadrado desenhado no centro da tela.\n");
    closeMappingMemory();
}	
