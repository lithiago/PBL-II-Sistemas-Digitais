#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <time.h>
// Define os padrões dos números para o display de 7 segmentos
#define ZERO 0b00111111
#define UM   0b00000110
#define DOIS 0b01011011
#define TRES 0b01001111
#define QUATRO 0b01100110
#define CINCO 0b01101101
#define SEIS 0b01111101
#define SETE 0b00000111
#define OITO 0b01111111
#define NOVE 0b01101111

int main(){
    volatile int * DISPLAY_ptr;
    volatile int * DISPLAY_ptr2;
    createMappingMemory();
    DISPLAY_ptr = open_hex0_3(); // SEGMENTO A, B, C, D
    DISPLAY_ptr2 = open_hex5_4(); // SEGMENTO E F G

    * DISPLAY_ptr = 


}