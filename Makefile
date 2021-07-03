CC = g++

main:
	flex lexer.l
	$(CC) main.cpp lex.yy.cc
	./a.out < test.txt