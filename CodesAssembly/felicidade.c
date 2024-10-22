#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include "hps_0.h"


#define HW_REGS_BASE 0xfc000000
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 ) //0x3FFFFFF
#define ALT_LWFPGASLVS_OFST 0xff200000

void *h2p_lw_dataA_addr;
void *h2p_lw_dataB_addr;
void *h2p_lw_wrReg_addr;
void *h2p_lw_wrFull_addr;
void *h2p_lw_screen_addr;
void *h2p_lw_result_pulseCounter_addr;

int fd;

int main() {
    
    /*if (result == 1) {
        printf("Memória mapeada.\n");
    } else {
        printf("Falha ao mapear memória\n");
    }*/

    void* virtual_base = createMappingMemory();
    // A FUNCAO RETORNA O ENDEREÇO NUNCA PASSA NESSE IF AQUI
    if (virtual_base == 1) {
        printf("Memória mapeada.\n");
    } else {
        printf("%p\n", virtual_base);
        h2p_lw_dataA_addr  = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + DATA_A_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
        printf("%p\n", h2p_lw_dataA_addr);
        h2p_lw_dataB_addr  = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + DATA_B_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
        printf("%p\n", h2p_lw_dataB_addr);
    }

    return 0;
	/*h2p_lw_dataB_addr  = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + DATA_B_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	h2p_lw_wrReg_addr  = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + WRREG_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	h2p_lw_wrFull_addr = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + WRFULL_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	h2p_lw_screen_addr = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SCREEN_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	h2p_lw_result_pulseCounter_addr = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + RESET_PULSECOUNTER_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
    */

    return 0;
}
