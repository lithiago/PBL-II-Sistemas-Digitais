#include "graphic_processor.c"
#include <stdio.h>
#include "graphic_processor.h"
//#include "hps_0.h"


int main(){
    createMappingMemory();
	
	//while(1){ if(isFull() == 0) { setQuadrado(1,1,1,1,1); break; } }
	
	while (1){
		if (isFull() == 0){
			setQuadrado(1,1,1,1,1);
			break;
		}
	}

    // Aguarde ou finalize o desenho, conforme necessário
    printf("Quadrado desenhado no centro da tela.\n");
    closeMappingMemory();
	return 0;
}