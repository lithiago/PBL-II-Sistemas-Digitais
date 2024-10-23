#include "graphic_processor.c"
#include <stdio.h>
#include "graphic_processor.h"
//#include "hps_0.h"


int main(){
    createMappingMemory();

	//set_background_block(0b111000, 0b111000, 0b111, 0b111, 0b111);
	//set_background_block(1, 0, 0b111, 0b111, 0b111); //coluna / linha
	//set_background_block(20, 0, 0b111, 0b111, 0b111); //coluna / linha
	// set_background_block(0b111000, 0b111001, 0b000, 0b000, 0b000);
	// set_background_block(0b111001, 0b111000, 0b000, 0b000, 0b000);
	// set_background_block(0b111001, 0b111001, 0b000, 0b000, 0b000);
	//int i = 0;
    //clear_background();
	//i += 2;
	//clear_background();
	while(1){ if(isFull() == 0) { setQuadrado(1,1,1,1,1); break; } }
	//set_background_block(20,20,0b000,0b000,0b111);
	// setQuadrado(7,7,1,0,1);
	// setQuadrado(15,15,0b111,0b000,0b111);
	// setQuadrado(15,15,0b111,0b000,0b111);
	//setQuadrado(5,5,2,2,2);
	//clear_background1();
	//clear_background2();

    // Aguarde ou finalize o desenho, conforme necessário
    printf("Quadrado desenhado no centro da tela.\n");
    closeMappingMemory();
	return 0;
}	
