# Assembly e Bibliotecas de Software
## Problema 2| - TEC499 - MI Sistemas Digitais - 2024.2 

Professor: Wild Freitas da Silva Santos

Grupo: [Guilherme Ferreira Rocha Lopes](https://github.com/GuilhermeFRLopes), [Thiago Ramon Santos de Jesus](https://github.com/lithiago) e [Ícaro de Souza Gonçalves](https://github.com/icarosg)

## Seções

1. [Introdução](#introdução)
2. [Requisitos do Projeto](#requisitos-do-projeto)
3. [Objetivos](#objetivos)
4. [Descrição das Ferramentas Utilizadas](#descrição-das-ferramentas-utilizadas)
5. [Metodologia](#metodologia)
6. [Testes realizados](#testes-realizados)
7. [Dificuldades](#dificuldades)
8. [Execução do jogo](#execução-do-jogo)

<a id="introdução"></a>
## Introdução

Este documento descreve em detalhes o desenvolvimento de um jogo de quebra-cabeça  conhecido como Tetris. Utiliza a linguagem C para implementação lógica e Assembly LEGV7 para construção de uma biblioteca para uso do processador gráfico presente na placa de desenvolvimento modelo [DE1-SoC da terasIC](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=167&No=836#contents).

O projeto representa uma evolução de um trabalho anterior, em que as funcionalidades gráficas eram realizadas pela FPGA. Posto isso, este relatório apresenta o desenvolvimento de uma biblioteca com funções gráficas, a qual abstrai o projeto desenvolvido pelo discente Gabriel Sá Barreto. Em suas atividades de Iniciação Científica e trabalho de conclusão de curso, o estudante projetou e implementou um processador gráfico que permite mover e controlar elementos em um monitor VGA. Durante esse desenvolvimento, o aluno utilizou como unidade principal de processamento o NIOS II, embarcado na mesma FPGA que o processador gráfico.

<a id="requisitos"></a>

## Requisitos do Projeto
O problema proposto deve ser desenvolvido no Kit de desenvolvimento DE1-Soc atendendo as seguintes requisições:

1. O código da biblioteca deve ser escrito em linguagem aseembly;
2. A biblioteca deve conter as funções essenciais para que seja possível implementar a parte gráfica do jogo usando o Processador Gráfico.

## Objetivos
- Aplicar conhecimentos de interação hardware-software;
-  Compreender o mapeamento de memória em uma arquitetura ARM;
-  Utilizar a interface de conexão entre HPS e FPGA da DE1-SoC;
-  Programar em assembly para um processador com arquitetura ARM;
-  Entender políticas de gerenciamento de sistema operacional Linux em arquitetura ARM;
 - Compreender os princípios básicos da arquitetura da plataforma DE1-SoC.


## Descrição das Ferramentas Utilizadas
- Placa de Desenvolvimento: O projeto em questão faz uso de hardware específico para seu desenvolvimento, sendo empregada uma placa de desenvolvimento DE1-SoC da terasIC . Ela é ideal para diversos projetos de prototipagem e desenvolvimento de sistemas embarcados. Ela combina um FPGA Cyclone V SoC da Intel com um processador dual-core ARM Cortex-A9, oferecendo uma plataforma completa e flexível para implementação de hardware e software. Seu acesso para a execução do jogo é feito através da conexão via SSH (ethernet) no terminal de um computador.
- Visual Studio Code: é um editor de código-fonte gratuito e de código aberto desenvolvido pela Microsoft. É multiplataforma, altamente extensível, oferece integração com Git, suporte a várias linguagens de programação, ferramentas de depuração integradas e um terminal incorporado.
- Makefile: Um Makefile é um arquivo de configuração utilizado pela ferramenta make, um utilitário de automação de compilação em sistemas Unix e Linux. Ele descreve como compilar e montar um projeto, especialmente aqueles que envolvem múltiplos arquivos de código-fonte e etapas de compilação complexas
- Github: Uma plataforma de hospedagem de código-fonte e colaboração que utiliza o sistema de controle de versão Git. Ele permite que desenvolvedores gerenciem, compartilhem e trabalhem colaborativamente em projetos de software de forma organizada e eficiente.
- Linguagem C: Linguagem de programação em alto nível usada para implementação da lógica do Tetris
- Assembly LegV7: O Assembly LEGv7 é uma linguagem de montagem (assembly) para a arquitetura ARM especificamente baseada no conjunto de instruções ARMv7
- Bibliotecas do Kernel: Para auxiliar no desenvolvimento do código em C do Jogo foram utilizadas as seguintes bibliotecas: Stdio, stdlib, stdint, time, sys/mman, fcntl, Stdbool e unistd.
1. As bibliotecas Stdio stdlib, stdint, time, Stdbool fornecem funções para diversas tarefas em C, como manipulação de entrada/saída, operações de baixo nível em sistemas Unix-like e tipos booleanos.
2. sys/mman: Essa biblioteca fornece funções para gerenciamento de memória, especialmente para mapeamento de arquivos ou dispositivos na memória. 
3. fcntl: Essa biblioteca contém definições relacionadas a arquivos e controladores de entrada/saída.

## Metodologia
Para a realização deste projeto, decidiu-se reaproveitar elementos já desenvolvidos na primeira versão do jogo. Foram mantidas as implementações das funções que constituem a lógica central do jogo, bem como o mapeamento de memória do dispositivo ADXL345, o acelerômetro. Apenas as funções relacionadas ao módulo da FPGA foram excluídas, uma vez que não seriam utilizadas na nova abordagem.

Para a implementação atual, tornou-se necessário o aprofundamento em conceitos sobre a arquitetura do processador gráfico, bem como o entendimento do desenvolvimento de código em linguagem assembly para a arquitetura ARM. Isso permitiu uma integração mais eficaz com os recursos de hardware e a otimização do desempenho da aplicação.

- **Mapeamento de Memória em Assembly**: O mapeamento de memória foi essencial para viabilizar o controle preciso no envio de instruções e comandos à unidade de processamento gráfico (GPU). Esse processo foi implementado através do uso de Syscalls (chamadas de sistema), que permitem que o código Assembly interaja diretamente com o sistema operacional para acessar serviços específicos, como o mapeamento de dispositivos de memória e arquivos. Por meio dessas chamadas, o Assembly pode manipular endereços virtuais, garantindo que a GPU receba os dados de controle de forma eficaz e eficiente.
- **Arquitetura do Processador Gráfico**:
