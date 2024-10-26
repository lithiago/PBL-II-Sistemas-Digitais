#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <time.h>

#define I2C0_BASE_ADDR 0xFFC04000 // Endereço base do I2C0
#define IC_CON_OFFSET 0x0         // Deslocamento do registrador ic_con
#define MAP_SIZE 0x1000           // Tamanho do mapeamento de memória

#define IC_TAR_REG 0x04           // Offset do registrador IC_TAR
#define IC_CON_REG (I2C0_BASE_ADDR + IC_CON_OFFSET)
#define IC_DATA_CMD_REG 0x10      // Offset do registrador IC_DATA_CMD
#define IC_ENABLE_REG 0x6C        // Offset do registrador IC_ENABLE
#define IC_RXFLR_REG 0x78         // Offset do registrador IC_RXFLR

// Endereço I2C do ADXL345
#define ADXL345_ADDR 0x53
#define ADXL345_REG_DATA_X0 0x32 // Registrador inicial dos dados X, Y, Z

void configure_pinmux() {
    volatile unsigned int *SYSMGR_I2C0USEFPGA = (volatile unsigned int *)0xFFD08704;
    *SYSMGR_I2C0USEFPGA = 0;
}

int main() {
    int fd1;
    void *i2c_base;

    // Abrir /dev/mem para acessar a memória do sistema
    fd1 = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd1 == -1) {
        perror("Erro ao abrir /dev/mem");
        return -1;
    }

    // Mapear a memória do controlador I2C0
    i2c_base = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd1, I2C0_BASE_ADDR);
    if (i2c_base == MAP_FAILED) {
        perror("Erro ao mapear a memória do I2C");
        close(fd1);
        return -1;
    }

    configure_pinmux();

    // Configurar o registrador IC_CON
    uint32_t ic_con_value = 0x65; // Mestre, modo rápido, 7 bits
    *((volatile uint32_t *)(i2c_base + IC_CON_OFFSET)) = ic_con_value;
    printf("Registrador IC_CON configurado com valor: 0x%X\n", ic_con_value);

    // Configurar o registrador IC_TAR para o ADXL345
    *((uint32_t *)(i2c_base + IC_TAR_REG)) = ADXL345_ADDR;
    printf("Registrador IC_TAR configurado com valor: 0x%X\n", ADXL345_ADDR);

    // Habilitar o I2C
    *((uint32_t *)(i2c_base + IC_ENABLE_REG)) = 0x1;
    printf("I2C habilitado\n");

    while (1) {
        // Enviar o registrador inicial (0x32) para leitura
        *((uint32_t *)(i2c_base + IC_DATA_CMD_REG)) = ADXL345_REG_DATA_X0;

        // Esperar até que os dados estejam prontos
        while (*((uint32_t *)(i2c_base + IC_RXFLR_REG)) < 6);

        // Ler os dados de X, Y, Z
        int16_t accel_data[3] = {0}; // Array para armazenar os valores de X, Y, Z

        for (int i = 0; i < 3; i++) {
            // Esperar para garantir que temos dados suficientes
            while (*((uint32_t *)(i2c_base + IC_RXFLR_REG)) == 0);
            uint8_t low_byte = *((uint32_t *)(i2c_base + IC_DATA_CMD_REG)) & 0xFF;
            while (*((uint32_t *)(i2c_base + IC_RXFLR_REG)) == 0);
            uint8_t high_byte = *((uint32_t *)(i2c_base + IC_DATA_CMD_REG)) & 0xFF;
            accel_data[i] = (int16_t)((high_byte << 8) | low_byte); // Combinar os dois bytes
        }

        // Imprimir os valores de aceleração
        printf("\n------------------------------------\n");
        printf("Aceleração em X: %d\n", accel_data[0]);
        printf("Aceleração em Y: %d\n", accel_data[1]);
        printf("Aceleração em Z: %d\n", accel_data[2]);
        printf("------------------------------------\n");

        // Aguardar um pouco antes da próxima leitura
        usleep(500000); // 500 ms
    }

    // Desabilitar o I2C0 após a operação
    *((uint32_t *)(i2c_base + IC_ENABLE_REG)) = 0x0;
    printf("I2C desabilitado\n");

    // Desmapear a memória e fechar o arquivo de memória
    munmap(i2c_base, MAP_SIZE);
    close(fd1);

    return 0;
}
