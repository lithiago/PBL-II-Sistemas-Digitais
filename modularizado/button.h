#ifndef BUTTON_H
#define BUTTON_H


extern void createMappingMemory(void);
extern void sendInstruction(uint32_t dataA, uint32_t dataB);
extern void set_background_block(uint32_t column, uint32_t line, uint32_t r, uint32_t g, uint32_t b);
extern void isFull(void);
extern int open_hex(uint32_t hex_digit);
extern uint32_t open_button(void);

#endif