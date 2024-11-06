all:
	as -o button.o button.s
	gcc -std=c99 -g *.c
	gcc *.o -o exec
	sudo ./exec