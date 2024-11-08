all:
	as -o button.o button.s
	gcc -std=c99 main.c -lintelfpgaup button.o -o teste
	sudo ./teste