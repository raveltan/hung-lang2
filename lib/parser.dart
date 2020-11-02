/*
This parser is based on the "Top down operator precedence" parser
or sometimes also called "Pratt Parser" (by Vaughan Pratt).

Statements
* Semicolon can be ommited
let <expression> = <expression>;
return <expression>;

<prefix operator | !- > <expression>;
<expression> <<infix operator | + - * / > < == >> <expression>;
if (<condition>) <result> else <alternative>;
 */

import 'package:hung_lang2/ast.dart';
import 'package:hung_lang2/lexer.dart';
import 'package:hung_lang2/token.dart';

// OrderOfOperation
enum OpOrder { LOWEST, DOUBLE_EQUAL, GREATER_LESS, ADD, MUL, PREFIX, CALL }

extension ParseToInt on OpOrder {
  int getPrecedence() {
    return index;
  }
}

const Map<TType, OpOrder> precedences = {
  TType.DOUBLE_EQUAL: OpOrder.DOUBLE_EQUAL,
  TType.NOT_EQUAL: OpOrder.DOUBLE_EQUAL,
  TType.LESSER: OpOrder.GREATER_LESS,
  TType.BIGGER: OpOrder.GREATER_LESS,
  TType.ADD: OpOrder.ADD,
  TType.SUB: OpOrder.ADD,
  TType.DIV: OpOrder.MUL,
  TType.MUL: OpOrder.MUL,
};

class Parser {
  Lexer _lexer;
  Token _currentToken;
  Token _peekNextToken;
  List<String> errors = [];
  Map<TType, Expression Function()> _parsePrefixFunctions;
  Map<TType, Expression Function(Expression)> _parseInfixFunctions;

  Parser(String input) {
    _lexer = Lexer(input);
    // Fill the value of current and peek token
    _nextToken();
    _nextToken();
    // Setup the parsing function for different prefix expressions.
    _parsePrefixFunctions = {
      TType.IDENTIFIER: () =>
          Expression(Token.fromIdentifier(_currentToken.content)),
      TType.NUMBER: () {
        var number = 0;
        try {
          number = int.tryParse(_currentToken.content);
        } catch (_) {
          errors.add('Cannot parse string to int');
          return null;
        }
        return IntegerLiteral(_currentToken, number);
      },
      TType.LEFT_PAREN:(){
        _nextToken();
        var expression = _parseExpression(OpOrder.LOWEST.getPrecedence());
        if (!_expectAndPeek(TType.RIGHT_PAREN)){
          errors.add('Cannot find right parentheses');
          return null;
        }
        return expression;
      },
      TType.NOT: _parsePrefixExpression,
      TType.SUB: _parsePrefixExpression,
      TType.TRUE: _parseBooleanLiteral,
      TType.FALSE: _parseBooleanLiteral,
    };
    _parseInfixFunctions = {
      TType.BIGGER: _parseInfixExpression,
      TType.LESSER: _parseInfixExpression,
      TType.NOT_EQUAL: _parseInfixExpression,
      TType.DOUBLE_EQUAL: _parseInfixExpression,
      TType.MUL: _parseInfixExpression,
      TType.DIV: _parseInfixExpression,
      TType.SUB: _parseInfixExpression,
      TType.ADD: _parseInfixExpression,
    };
  }

  Expression _parseBooleanLiteral() => BooleanLiteral(_currentToken)
    ..data = _currentToken.tokenType == TType.TRUE ? true : false;

  Expression _parseInfixExpression(Expression leftExpression) {
    var expression =
        InfixExpression(_currentToken, _currentToken.content, leftExpression);
    var currentPrecedence = _currentPrecedence();
    _nextToken();
    expression.right = _parseExpression(currentPrecedence);

    return expression;
  }

  int _peekPrecedence() {
    if (precedences.containsKey(_peekNextToken.tokenType)) {
      return precedences[_peekNextToken.tokenType].getPrecedence();
    }
    return OpOrder.LOWEST.getPrecedence();
  }

  int _currentPrecedence() {
    if (precedences.containsKey(_currentToken.tokenType)) {
      return precedences[_currentToken.tokenType].getPrecedence();
    }
    return OpOrder.LOWEST.getPrecedence();
  }

  Expression _parsePrefixExpression() {
    var ex = PrefixExpression(_currentToken, _currentToken.content);
    _nextToken();
    ex.data = _parseExpression(OpOrder.PREFIX.getPrecedence());
    return ex;
  }

  // Advance the pointer to current and nextToken.
  void _nextToken() {
    _currentToken = _peekNextToken;
    _peekNextToken = _lexer.nextToken();
  }

  // Get the program AST for certain input
  Program parseProgram() {
    var program = Program();
    while (_currentToken.tokenType != TType.EOF) {
      var statement = _parseStatement();
      if (statement != null) {
        program.statements.add(statement);
      }
      _nextToken();
    }
    return program;
  }

  // Parse a single statement
  // The parsing will be delegated to each statement parser
  Statement _parseStatement() {
    switch (_currentToken.tokenType) {
      case TType.VAR:
        {
          return _parseVarStatement();
        }
      case TType.RETURN:
        {
          return _parseReturnStatement();
        }
      default:
        {
          return _parseExpressionStatement();
        }
    }
  }

  /*
   Parse Statement:
   - ReturnStatement
   - VarStatement
   - !!! ExpressionStatement*;
   * Refer to ast.dart for more info.
   */
  Statement _parseReturnStatement() {
    var statement = ReturnStatement();
    _nextToken();

    // TODO: PROCESS EXPRESION
    while (_currentToken.tokenType != TType.SEMICOLON) {
      _nextToken();
    }
    return statement;
  }

  Statement _parseVarStatement() {
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

  Statement _parseExpressionStatement() {
    var statement = ExpressionStatement(_currentToken);
    statement.expression = _parseExpression(OpOrder.LOWEST.getPrecedence());

    if (_peekNextToken.tokenType == TType.SEMICOLON) {
      _nextToken();
    }
    return statement;
  }

  Expression _parseExpression(int precedence) {
    if (!_parsePrefixFunctions.containsKey(_currentToken.tokenType)) {
      errors
          .add('no prefix parse function found for ${_currentToken.tokenType}');
      return null;
    }
    var leftExpression = _parsePrefixFunctions[_currentToken.tokenType]();

    while (!(_peekNextToken.tokenType == TType.SEMICOLON) &&
        precedence < _peekPrecedence()) {
      if (!_parseInfixFunctions.containsKey(_peekNextToken.tokenType)) {
        return leftExpression;
      }
      var prefixClosure = _parseInfixFunctions[_peekNextToken.tokenType];
      _nextToken();
      leftExpression = prefixClosure(leftExpression);
    }
    return leftExpression;
  }

  // Return true and advance to next token if next token is of expected type
  bool _expectAndPeek(TType t) {
    if (_peekNextToken.tokenType == t) {
      _nextToken();
      return true;
    }
    _peekError(t);
    return false;
  }

  // Add error if the next token is unexpected
  void _peekError(TType type) => errors
      .add('Expected next token to be $type got ${_peekNextToken.tokenType}');
}
