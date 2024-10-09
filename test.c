#include <stdio.h>


// Declaração da função Assembly
extern void draw_pixel(int y, int x, int color);

//Para o código c
int main() {
    // Inicializa o sistema gráfico (se necessário)

    // Exemplo: Desenha um ponto vermelho na posição (100, 150)
    int x = 150;
    int y = 100;
    int red_color = 0xFF0000; // Cor vermelha em formato RGB (0xFF0000) 

    // Chama a função Assembly para desenhar o ponto
    draw_pixel(y, x, red_color);

    // Loop infinito para manter o ponto visível na tela
    while (1) {
        // Pode implementar outras atualizações gráficas aqui
    }

    return 0;
}
