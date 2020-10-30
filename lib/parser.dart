/*
This parser is based on the "Top down operator precedence" parser
or sometimes also called "Pratt Parser" (by Vaughan Pratt).
 */

/*
*Note: Whitespaces is ignored by the lexer
*Note: EXPRESSION produce VALUES while STATEMENT NOT.
Statements:
var <identifier> = <expression>;
return <expression>;
 */

import 'package:hung_lang2/ast.dart';
import 'package:hung_lang2/lexer.dart';
import 'package:hung_lang2/token.dart';

class Parser {
  Lexer _lexer;
  Token _currentToken;
  Token _peekNextToken;
  List<String> errors = [];

  Parser(String input) {
    _lexer = Lexer(input);
    // Fill the value of current and peek token
    _nextToken();
    _nextToken();
  }

  void _nextToken() {
    _currentToken = _peekNextToken;
    _peekNextToken = _lexer.nextToken();
  }

  Program parseProgram() {
    var program = Program();
    while (_currentToken.tokenType != TType.EOF) {
      var statement = parseStatement();
      if (statement != null) {
        program.statements.add(statement);
      }
      _nextToken();
    }
    return program;
  }

  Statement parseStatement() {
    switch (_currentToken.tokenType) {
      case TType.VAR:
        {
          return parseVarStatement();
        }
      case TType.RETURN:
        {
          return parseReturnStatement();
        }
      default:
        {
          return null;
        }
    }
  }
  Statement parseReturnStatement(){
    var statement = ReturnStatement();
    _nextToken();

    // TODO: PROCESS EXPRESION
    while(_currentToken.tokenType!=TType.SEMICOLON){
      _nextToken();
    }
    return statement;
  }

  Statement parseVarStatement() {
    var statement = VarStatement();
    if (!_expectAndPeek(TType.IDENTIFIER)) {
      return null;
    }
    statement.name = Expression(_currentToken);
    if (!_expectAndPeek(TType.EQUAL)) {
      return null;
    }

    // TODO: PROCESS EXPRESSION UNTIL SEMICOLON
    while (_currentToken.tokenType != TType.SEMICOLON) {
      _nextToken();
    }
    return statement;
  }

  bool _expectAndPeek(TType t) {
    if (_peekNextToken.tokenType == t) {
      _nextToken();
      return true;
    }
    _peekError(t);
    return false;
  }

  void _peekError(TType type) => errors
      .add('Expected next token to be $type got ${_peekNextToken.tokenType}');
}
