/*  this is the starting of the lex file which takes some C header files for proper working. */
/* #include<stdio.h> and #include<ctype.h>: These lines are header files include the standard C library header files stdio.h and ctype.h. */
/* These headers provide functions and definitions for input/output operations (printf, scanf) and character classification (isalpha, isdigit, etc.), respectively.*/

%option noyywrap
%{
#include<stdio.h>
#include<ctype.h>
#include "parser.tab.h"
extern int yyval;
int val;

%}

/* These are regular expression defines a pattern for recognizing specific kinds of tokens in a text input.  */
/* alpha [a-zA-Z]: This defines a pattern for matching single alphabetic characters (lowercase or uppercase). */
/* space1 [ ]: This pattern matches a single space character. */
/* digit [0-9]: This pattern matches a single digit. */
/* alphanum ([a-zA-Z]|{digit}): This pattern matches either a single alphabetic character or a digit. */
/* punc [@$%^&;\:\"',\\<>\/?~]`: This pattern matches various punctuation characters. */
/* strikethrough (\~\~): This pattern matches a tilde character repeated twice, representing a strikethrough markup. */
/* text (({alpha}(\.?)(\-?)(\!?))|{digit}|{punc}|#{7,})*...: This pattern defines a complex expression that seems to match different types of characters in a text, including alphabetic characters, digits, punctuation, and sequences of # characters. */
/* olist ^[0-9]+\.[ ]: This pattern matches a numbered list item. */
/* line1 [\-]{3,}: This pattern matches a line consisting of at least three dashes. */
/* line2 [\*]{4,}: This pattern matches a line consisting of at least four asterisks. */
/* sbo ("\["): This pattern matches an opening square bracket ([). */
/* sbc ("\]"): This pattern matches a closing square bracket (]). */
/* bo ("\("): This pattern matches an opening parenthesis ((). */
/* bc ("\)"): This pattern matches a closing parenthesis ()). */


alpha           [a-zA-Z]
space1          [ ]
digit           [0-9]
alphanum        ([a-zA-Z]|{digit})

punc            [@$%^&;\:\"\',\\<>\/?`~]
strikethough    (\~\~)
text            (({alpha}(\.?)(\-?)(\!?))|{digit}|{punc}|#{7,})*({space1}(({alpha}(\.?)(\-?)(\!?))|{digit}|{punc}|#{7,})+)*
olist           ^[0-9]+\.[ ] 
sbo                      ("\[")
sbc                      ("\]")
bo                       ("\(")
bc               ("\)")

%%
^"# "              {   yylval.str = strdup(yytext); return(HEADING1);}
^"## "                    {  yylval.str = strdup(yytext); return(HEADING2); }
^"### "                   {  yylval.str = strdup(yytext); return(HEADING3); }
^"#### "                  {  yylval.str = strdup(yytext); return(HEADING4); }
^"##### "                {  yylval.str = strdup(yytext); return(HEADING5);  }
^"###### "               {  yylval.str = strdup(yytext); return(HEADING6);  }
{olist}                   {yylval.str = strdup(yytext); return(ORDLIST_LIST);}
\n(\n)+                  {  yylval.str = strdup(yytext); return(PARA);}
\n                       {  yylval.str = strdup(yytext); return(SOFTBREAK); }
{strikethough}           {  yylval.str = strdup(yytext); return(STRIKE);}
({space1}{space1}\n)     {  yylval.str = strdup(yytext); return(LINEBREAK); }
"\*\*"                  {  yylval.str = strdup(yytext); return(BOLD1);} 
"\_\_"                  {  yylval.str = strdup(yytext); return(BOLD2);}
"\_"                    {  yylval.str = strdup(yytext); return(ITALIC1); }
"\*"                    {  yylval.str = strdup(yytext); return(ITALIC2); }
"\_\_\_"                {   yylval.str = strdup(yytext); return(BOLDITALIC1); }
"\*\*\*"                {   yylval.str = strdup(yytext); return(BOLDITALIC2); }
"\*\*\_"                 {  yylval.str = strdup(yytext); return(BI1_O); }
"\_\*\*"                 {  yylval.str = strdup(yytext); return(BI1_C); }
"\_\_\*"                 {  yylval.str = strdup(yytext); return(BI2_O); }
"\*\_\_"                 {  yylval.str = strdup(yytext); return(BI2_C); }
{sbo}                     {  yylval.str = strdup(yytext); return(SBO); }
{sbc}                    {  yylval.str = strdup(yytext); return(SBC); }
{bo}                    {  yylval.str = strdup(yytext); return(BO); }
{bc}                     {  yylval.str = strdup(yytext); return(BC); }
"\!"                     {  yylval.str = strdup(yytext); return(IMG_ST); }
[\-|\*|\+]{space1}       {  yylval.str = strdup(yytext); return(UNORDLIST_LIST);}
  
{text}                  {  yylval.str = strdup(yytext); return(TEXT); }
%%

  // int main  (){
  //  yylexreturn 0;
  //  }

// text            ({alphanum}|{punc}|#{7,})*({space1}({alphanum}|{punc}|#{7,})+)*