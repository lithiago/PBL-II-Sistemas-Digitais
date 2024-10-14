int main() {
    int result = createMappingMemory();

    if (result == 1) {
        printf("Memória mapeada.\n");
    } else {
        printf("Falha ao mapear memória\n");
    }

    return 0;
}
