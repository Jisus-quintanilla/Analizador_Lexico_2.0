import compilerTools.Token;

%%
%class Lexer
%type Token
%line
%column
%{
    private Token token(String lexeme, String lexicalComp, int line, int column){
        return new Token(lexeme, lexicalComp, line+1, column+1);
    }
%}
/* Variables básicas de comentarios y espacios */
TerminadorDeLinea = \r|\n|\r\n
EntradaDeCaracter = [^\r\n]
EspacioEnBlanco = {TerminadorDeLinea} | [ \t\f]
ComentarioTradicional = "/*" [^*] ~"*/" | "/*" "*"+ "/"
FinDeLineaComentario = "//" {EntradaDeCaracter}* {TerminadorDeLinea}?
ContenidoComentario = ( [^*] | \*+ [^/*] )*
ComentarioDeDocumentacion = "/**" {ContenidoComentario} "*"+ "/"

/* Comentario */
Comentario = {ComentarioTradicional} | {FinDeLineaComentario} | {ComentarioDeDocumentacion}

/* Identificador */
Letra = [A-Za-zÑñ_ÁÉÍÓÚáéíóúÜü]
Digito = [0-9]
Identificador = {Letra}({Letra}|{Digito})*

/* Número */
Numero = 0 | [0-9][0-9]*
%%

/* Asignación */
":=" { return token(yytext(), "Asignación", yyline, yycolumn); }

/* Comentarios o espacios en blanco */
{Comentario}|{EspacioEnBlanco} { /*Ignorar*/ }

/* Palabras reservadas */
"if"|"else"|"for"|"print"|"int" { return token(yytext(), "Palabras reservadas", yyline, yycolumn); }

/* Identificador */
{Identificador} { return token(yytext(), "IDENTIFICADOR", yyline, yycolumn); }

/* Constantes */
{Numero} { return token(yytext(), "Constantes", yyline, yycolumn); }

/* Colores */
#[{Letra}{Digito}]{6} { return token(yytext(), "COLOR", yyline, yycolumn); }

/* Operadores relacionales */
","|"."|">="|"<="|">"|"<"|"="|"<>"|"{"|"}"|"["|"]"|"("|")"|";"|".." { return token(yytext(), "Operadores relacionales", yyline, yycolumn); }

/* Operadores aritméticos */
"+"|"-"|"*"|"/" { return token(yytext(), "Operadores aritméticos", yyline, yycolumn); }



/* Errores */
// Número erróneo
0 {Numero}+ { return token(yytext(), "ERROR_1", yyline, yycolumn); }
// Identificador numero y texto
{Numero}{Identificador} { return token(yytext(), "ERROR_2", yyline, yycolumn); }
. { return token(yytext(), "ERROR", yyline, yycolumn); }