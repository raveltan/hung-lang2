import 'package:hung_lang2/token.dart';

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

class VarStatement extends Statement {
  Expression name;
  Expression value;

  VarStatement() : super(Token.fromIdentifier('var'));

  @override
  String toString() {
    return '${token.tokenType.toString()} ${name.token.content} = ${value.token.content};';
  }
}

class ReturnStatement extends Statement{
  ReturnStatement() : super(Token.fromIdentifier('return'));
  Expression returnValue;

  @override
  String toString() {
    return '${token.tokenType.toString()} ${returnValue.token.content};';
  }
}

// Class for Expression statement
// 5 + 10; -> Legal in hung lang 2
class ExpressionStatement extends Statement{
  ExpressionStatement(Token token) : super(token);
  Expression expression;

  @override
  String toString() {
    return expression.toString() ?? '';
  }

}

class Program {
  List<Statement> statements = [];

  @override
  String toString() {
    var result = '';
    for(var s in statements){
      result += s.toString();
    }
    return result;
  }
}
