#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <time.h>

#define I2C0_BASE_ADDR 0xFFC04000 // Endereço base do I2C0
#define IC_CON_OFFSET 0x0         // Deslocamento do registrador ic_con
#define MAP_SIZE 0x1000           // Tamanho do mapeamento de memória

#define IC_TAR_REG 0x04                             // Offset do registrador IC_TAR
#define IC_CON_REG (I2C0_BASE_ADDR + IC_CON_OFFSET) // Correto
#define IC_DATA_CMD_REG 0x10                        // Offset do registrador IC_DATA_CMD
#define IC_ENABLE_REG 0x6C                          // Offset do registrador IC_ENABLE
#define I2C0_ENABLE_STATUS 0x9C 
#define IC_RXFLR_REG 0x78                           // Offset do registrador IC_RXFLR

// Endereço I2C do ADXL345
#define ADXL345_ADDR 0x53
#define DATA_FORMAT 0x31
#define BW_RATE 0x2C
#define POWER_CTL 0x2D

// Registradores internos do ADXL345
#define ADXL345_REG_DATA_X0 0x32 // Registrador inicial dos dados X, Y, Z (6 bytes)

#define SYSMGR_GENERALIO7 ((volatile unsigned int *) 0xFFD0849C)
#define SYSMGR_GENERALIO8 ((volatile unsigned int *) 0xFFD084A0)
#define SYSMGR_I2C0USEFPGA ((volatile unsigned int *) 0xFFD08704)

#define I2C0_FS_SCL_HCNT 0x1C
#define I2C0_FS_SCL_LCNT 0x20


int fd1;
void *i2c_base;

int main() {
    createMappingMemory();

    while(1) {
        set_sprite(1, 220, 100, 0 , 0);
        setPolygon(0b0000, 0b0011, 0b000000111, 0, 0b0001, 150, 150);
    }

    return 0;
}
