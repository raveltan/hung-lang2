/*
This parser is based on the "Top down operator precedence" parser
or sometimes also called "Pratt Parser" (by Vaughan Pratt).
 */

/*
*Note: Whitespaces is ignored by the lexer
*Note: EXPRESSION produce VALUES while STATEMENT NOT.
Statements:
var <identifier> = <expression>;
 */

