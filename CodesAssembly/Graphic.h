#ifndef MAP_MEMORY_H
#define MAP_MEMORY_H

// Declaração de funções externas (assembly)
extern void* mapMemory(void);
extern void send_instruction(int dataA, int dataB);
extern int fifo_check(void);
extern int dataA_construtor(int opcode, int reg, int memory_address);
extern void set_background_color(int red, int green, int blue);

// Definições dos registradores e variáveis de hardware
#define RDWR_OR_SYNC                 0x00101002
#define HW_REGS_BASE                 0xfc000000  // Base address
#define HW_REGS_SPAN                 0x04000000  // Span size
#define HW_REGS_MASK                 (HW_REGS_SPAN - 1)
#define ALT_LWFPGASLVS_OFST          0xff200000  // Offset for FPGA slave address

// Definição dos offsets para os registradores FPGA
#define DATA_A_BASE                  0x80
#define DATA_B_BASE                  0x70
#define WRREG_BASE                   0xc0
#define WRFULL_BASE                  0xb0
#define SCREEN_BASE                  0xa0
#define RESET_PULSECOUNTER_BASE      0x90

// Variáveis globais (pode ser utilizado extern se necessário)
extern unsigned int virtual_base;
extern unsigned int h2p_lw_dataA_addr;
extern unsigned int h2p_lw_dataB_addr;
extern unsigned int h2p_lw_wrReg_addr;
extern unsigned int h2p_lw_wrFull_addr;
extern unsigned int h2p_lw_screen_addr;
extern unsigned int h2p_lw_result_pulseCounter_addr;
extern unsigned int fd;
extern unsigned int page_len;

#endif /* MAP_MEMORY_H */
