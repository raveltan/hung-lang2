import 'package:hung_lang2/token.dart';

class Node{
  @override
  String toString() {
    return super.toString();
  }
}

class Statement{
  Node node;

  Statement(this.node);
}

class Program{
  List<Statement> statements;
  @override
  String toString() {
    return statements.isEmpty ? '' : statements[0].toString();
  }
}

class Expression{
  Node node;
  Expression(this.node);
}