all : parser

parser.tab.c parser.tab.h : parser.y
	bison -d --debug parser.y

lex.yy.c : lexer.l parser.tab.h
	flex lexer.l

parser : parser.tab.c lex.yy.c
	gcc -o parser parser.tab.c lex.yy.c -lfl

clean :
	rm -f lex.yy.c *.tab.* parser
