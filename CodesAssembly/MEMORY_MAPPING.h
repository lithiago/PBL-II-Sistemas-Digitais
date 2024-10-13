#ifndef MEMORY_MAPPING_H
#define MEMORY_MAPPING_H


// Definições das constantes
#define HW_REGS_BASE       0xfc000000      // Base address
#define HW_REGS_SPAN       0x04000000      // Span size
#define HW_REGS_MASK       0x03FFFFFF      // Mask (SPAN - 1)
#define ALT_LWFPGASLVS_OFST 0xff200000      // Offset for FPGA slave address

#define DATA_A_BASE        0x80
#define DATA_B_BASE        0x70
#define WRREG_BASE         0xc0
#define WRFULL_BASE        0xb0
#define SCREEN_BASE        0xa0
#define RESET_PULSECOUNTER_BASE 0x90


extern int createMappingMemory();
extern void closeMappingMemory();
extern int isFull();
extern void sendInstruction();
extern unsigned long dataA_builder();
extern void setPolygon(int address, int opcode, int color, int form, int mult, int ref_point_x, int ref_point_y);
extern void set_sprite(int registrador, int x, int y, int offset, int activation_bit);
extern void set_background_color(int R, int G, int B);
extern void set_background_block(int column, int line, int R, int G, int B);
extern void waitScreen(int limit);

#endif