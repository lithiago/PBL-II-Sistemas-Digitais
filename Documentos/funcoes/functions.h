#ifndef FUNCTIONS_H
#define FUNCTIONS_H

// Declarações das funções assembly
extern int isFull(void);
extern unsigned long dataa_builder(int opcode, int reg, int memory_address);
//extern void setPolygon(int form, int color, int mult, int ref_point_y, int ref_point_x);
//extern int createMappingMemory(void);
extern void closeMappingMemory(void);
extern void sendinstruction(unsigned long dataA, unsigned long dataB);

#endif // FUNCTIONS_H