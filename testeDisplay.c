#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <time.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "map.h"

// Define os padrões dos números para o display de 7 segmentos
// BIT 1 DESATIVA OS SEG (G, F, E, D, C, B, A)
#define ZERO 0b1000000
#define UM 0b1111001
#define DOIS 0b0100100
#define TRES 0b0110000
#define QUATRO 0b0011001
#define CINCO 0b0010010
#define SEIS 0b0000010
#define SETE 0b1111000
#define OITO 0b0000000
#define NOVE 0b0010000
#define hex5 0x10
#define hex4 0x20
#define hex3 0x30
#define hex2 0x40
#define hex1 0x50
#define hex0 0x60

int main()
{
    volatile int *DISPLAY_ptr5 = 0;
    volatile int *DISPLAY_ptr4= 0;
    volatile int *DISPLAY_ptr3 = 0;
    volatile int *DISPLAY_ptr2;
    volatile int *DISPLAY_ptr1;
    volatile int *DISPLAY_ptr0;
    int index = 0;
    int bit0 = 0;
    int bit1 = 0;
    int bit2 = 0;
    void *virtual_base;
        void *LW_virtual;          // used to map physical addresses for the light-weight bridge
    int numeros[10] = {

        0b1000000, 0b1111001, 0b0100100, 0b0110000, 0b0011001, 0b0010010, 0b0000010, 0b1111000, 0b0000000, 0b0010000};

   
  /*  int fd = -1;
    if (fd == -1)
        if ((fd = open( "/dev/mem", (O_RDWR | O_SYNC))) == -1) {
            printf ("ERROR: could not open \"/dev/mem\"...\n");
            return (-1);
        }
     // Get a mapping from physical addresses to virtual addresses
    LW_virtual = mmap (NULL, LW_BRIDGE_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, LW_BRIDGE_BASE);
    if (virtual_base == MAP_FAILED) {
        printf ("ERROR: mmap() failed...\n");
        close (fd);
        return (NULL);
    }
    printf("\n %X", LW_virtual);

*/
    void *add;
   // DISPLAY_ptr5 = open_hex5();
    printf("\n %X", add);
    DISPLAY_ptr5 = (unsigned int *) (LW_virtual + 0x10); // SEGMENTO A, B, C, D
    DISPLAY_ptr4 = (unsigned int *) (LW_virtual + 0x20); // SEGMENTO E F G
    DISPLAY_ptr3 = (unsigned int *) (LW_virtual + 0x30); // SEGMENTO E F G
    *DISPLAY_ptr5 = numeros[4];
    volatile uint32_t *KEY_ptr;

    KEY_ptr = open_button();
    if (*KEY_ptr == 0b1111)
    {
        printf("1");
    }
   /* while (1)
    {
        if (*KEY_ptr == 0b1111)
        {
            printf("1");
        }
        else if (*KEY_ptr == 0b1110)
        { // 4 BOTAO
            printf("2");
            if (bit0 < 9)
            {
                bit0++;
            }
            else
            {
                bit0 = 0;
                if (bit1 < 9)
                {
                    bit1++;
                }
                else
                {
                    bit1 = 0;
                    if (bit2 < 9)
                    {
                        bit2++;
                    }
                    else
                    {
                        bit2 = 0; // Reset total se necessário
                    }
                    *DISPLAY_ptr3 = numeros[bit2];
                }
                *DISPLAY_ptr4 = numeros[bit1];
            }
            *DISPLAY_ptr5 = numeros[bit0];
        }
        else if (*KEY_ptr == 0b1101)
        { // 3 BOTAO
            printf("3");
        }
        else if (*KEY_ptr == 0b1011)
        { // SEGUNDO BOTAO
            printf("4");
        }
    }*/
}