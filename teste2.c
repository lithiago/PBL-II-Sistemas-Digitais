#include <stdio.h>

// Declaração da função Assembly
extern int somaValores(int valor1, int valor2);

int main() {
    int valor1 = 10;
    int valor2 = 20;

    // Chama a função Assembly para somar os dois valores
    int resultado = somaValores(valor1, valor2);

    // Exibe o resultado da soma
    printf("Resultado da soma: %d\n", resultado);

    return 0;
}
