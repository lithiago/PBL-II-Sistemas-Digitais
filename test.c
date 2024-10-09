#include <stdio.h>

int main() {
    int soma = main1(2, 3);
    printf("\nresultado soma de 2 + 3: %d\n", soma);
    
    int sub = subtrai(soma, 1);
    printf("\nresultado da subtracao: %d\n", sub);

    printf("valor atual da soma: %d\n",soma);


    int mult = multiplica(soma);
    printf("multiplica: %d\n", mult);
}
