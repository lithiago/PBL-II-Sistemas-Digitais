#include <stdio.h>
#include <stdint.h>
#include <gpu_funcoes.s>
#include "hps_0.h"
#include <map.s>
#include <gpu_funcoes.s>


#define HW_REGS_BASE 0xfc000000
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 ) //0x3FFFFFF
#define ALT_LWFPGASLVS_OFST 0xff200000

void *virtual_base;
void *h2p_lw_dataA_addr;
void *h2p_lw_dataB_addr;
void *h2p_lw_wrReg_addr;
void *h2p_lw_wrFull_addr;
void *h2p_lw_screen_addr;
void *h2p_lw_result_pulseCounter_addr;
int fd;

int main(){
    int retorno;
    retorno = createMappingMemory(&fd, virtual_base);
    if (retorno == 2){
        printf("Erro");    
        return -1;    
    }    
    h2p_lw_dataA_addr  = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + DATA_A_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	h2p_lw_dataB_addr  = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + DATA_B_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	h2p_lw_wrReg_addr  = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + WRREG_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	h2p_lw_wrFull_addr = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + WRFULL_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	h2p_lw_screen_addr = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SCREEN_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	h2p_lw_result_pulseCounter_addr = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + RESET_PULSECOUNTER_BASE ) & ( unsigned long)( HW_REGS_MASK ) );


    set_background_color(0b111,0b111,0b000, h2p_lw_wrFull_addr);
    set_background_block(1, 1, 0, 0, 1, h2p_lw_wrFull_addr);

}