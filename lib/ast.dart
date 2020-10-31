import 'package:hung_lang2/token.dart';

/*
*Note: toString methods of each classes are only for debug purposes
*Note: Whitespaces is ignored by the lexer
*Note: EXPRESSION produce VALUES while STATEMENT NOT.
Basic building block of an AST:
- Node
- Statement
- Expression
 */
class Node {
  Token token;

  Node(this.token);

  @override
  String toString() {
    return token.toString();
  }
}

class Statement extends Node {
  Statement(Token token) : super(token);

  String statementNode() {
    return '';
  }
}

class Expression extends Node {
  Expression(Token token) : super(token);

  String expressionNode() {
    return '';
  }
}

/*
Statements in Hung Lang 2:
- VarStatement (let x = 10;)
- ReturnStatement (return 20;)
- Expression Statement (10 + 20;) -> legal.
 */
class VarStatement extends Statement {
  Expression name;
  Expression value;

  VarStatement() : super(Token.fromIdentifier('var'));

  @override
  String toString() {
    return '${token.tokenType.toString()} ${name.token.content} = ${value.token.content};';
  }
}

class ReturnStatement extends Statement {
  ReturnStatement() : super(Token.fromIdentifier('return'));
  Expression returnValue;

  @override
  String toString() {
    return '${token.tokenType.toString()} ${returnValue.token.content};';
  }
}

// Class for Expression statement
// 5 + 10; -> Legal in hung lang 2
class ExpressionStatement extends Statement {
  ExpressionStatement(Token token) : super(token);
  Expression expression;

  @override
  String toString() {
    return '${token.toString()} ${expression.toString() ?? ''}';
  }
}

// Integer Literals
class IntegerLiteral extends Expression {
  IntegerLiteral(Token token, int value)
      : value = value,
        super(token);
  final int value;

  @override
  String toString() {
    return token.toString();
  }
}

class PrefixExpression extends Expression {
  PrefixExpression(Token token, String operator)
      : operator = operator,
        super(token);
  final String operator;
  Expression data;

  @override
  String toString() {
    return '<$operator $data>';
  }
}

/*
A Program is collection of statements;
 */
class Program {
  List<Statement> statements = [];

  @override
  String toString() {
    var result = '';
    for (var s in statements) {
      result += s.toString();
    }
    return result;
  }
}
