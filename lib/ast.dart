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
}

class Expression extends Node {
  Expression(Token token) : super(token);
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
    return '{var ${name.token.content} = ${value.token.content};}';
  }
}

class ReturnStatement extends Statement {
  ReturnStatement() : super(Token.fromIdentifier('return'));
  Expression returnValue;

  @override
  String toString() {
    return '{return ${returnValue.token.content};}';
  }
}

// Class for Expression statement
// 5 + 10;
class ExpressionStatement extends Statement {
  ExpressionStatement(Token token) : super(token);
  Expression expression;

  @override
  String toString() {
    return '{${expression.toString()}}';
  }
}

class FunctionLiteral extends Expression{
  FunctionLiteral(Token token) : super(token);
  List<Expression> params;
  MultilineStatement body;
  @override
  String toString() {
    return 'f $params {$body}';
  }
}

class IfExpression extends Expression {
  IfExpression(Token token) : super(token);
  Expression condition;
  MultilineStatement result;
  MultilineStatement alternative;

  @override
  String toString() {
    return 'if $condition $result ${alternative != null ? "else $alternative" : ""}';
  }
}

class MultilineStatement extends Statement {
  MultilineStatement(Token token) : super(token);
  List<Statement> statements;

  @override
  String toString() {
    return statements.join('\n');
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
    return value.toString();
  }
}

class BooleanLiteral extends Expression {
  BooleanLiteral(Token token) : super(token);
  bool data;

  @override
  String toString() {
    return data.toString();
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
    return '{$operator $data}';
  }
}

class InfixExpression extends Expression {
  InfixExpression(Token token, String operator, Expression left)
      : operator = operator,
        left = left,
        super(token);
  final String operator;
  final Expression left;
  Expression right;

  @override
  String toString() {
    return '{$left $operator $right}';
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
