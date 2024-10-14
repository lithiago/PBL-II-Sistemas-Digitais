#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>

extern void* map_memory(size_t size, int* fd);

int main() {
    int fd;
    size_t size = 0x1000;  // Tamanho do mapeamento (4KB)
    void* mapped_memory = map_memory(size, &fd);

    if (mapped_memory == MAP_FAILED) {
        perror("Falha no mapeamento de memória");
        return EXIT_FAILURE;
    }

    printf("Mapeamento de memória bem-sucedido em: %p\n", mapped_memory);

    // Faça algo com a memória mapeada, se necessário

    // Libere a memória mapeada
    if (munmap(mapped_memory, size) == -1) {
        perror("Falha ao liberar mapeamento");
        return EXIT_FAILURE;
    }

    close(fd);  // Fechar o descritor de arquivo
    return EXIT_SUCCESS;
}
