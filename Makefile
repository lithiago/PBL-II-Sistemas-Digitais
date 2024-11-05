all:
	as -o assembly.o button.s
	gcc -std=c99 main.c -o main.o
	gcc -std=c99 logic_game.c -o logic_game.o
	gcc -std=c99 graphic_functions.c -o graphic_functions.o
	gcc main.o logic_game.o assembly.o graphic_functions.o -o game
	sudo ./game