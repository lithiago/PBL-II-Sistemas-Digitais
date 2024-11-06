main: main.o graphic_functions.o logic_game.o button.o
	gcc -o main main.o graphic_functions.o logic_game.o button.o
main.o: main.c graphic_functions.h logic_game.h button.h
	gcc -c -o main.o main.c

graphic_functions.o: graphic_functions.c logic_game.h button.h
	gcc -c -o graphic_functions.o graphic_functions.c

logic_game.o: logic_game.c logic_game.h button.h
	gcc -c -o logic_game.o logic_game.c

button.o: button.s button.h
	as -o button.o button.s

