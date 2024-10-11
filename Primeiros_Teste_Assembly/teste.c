#include <stdio.h>

extern int soma_valores(int a, int b);


int main(){
    int a = 3;
    int b = 6;
    int x;

    x = soma_valores(a, b);

    printf("Resultado: %d\n", x);


}