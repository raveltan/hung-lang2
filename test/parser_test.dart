import 'package:hung_lang2/ast.dart';
import 'package:hung_lang2/parser.dart';
import 'package:hung_lang2/token.dart';
import 'package:test/test.dart';

void main() {
  group('Parsing Statements', () {
    test('Test for var statement', () {
      var input = '''var a =5;
    var x= 10;
    var y = 200;
    ''';
      var p = Parser(input);
      var program = p.parseProgram();
      for (var e in p.errors) {
        // Print each error
        expect(e == null, true, reason: '$e');
      }
      expect(program == null, equals(false),
          reason: 'Program should not be null');
      expect(program.statements.length, equals(3),
          reason: 'Statement length should be 3');
      var results = [
        Token.fromIdentifier('a'),
        Token.fromIdentifier('x'),
        Token.fromIdentifier('y')
      ];

      for (var i = 0; i < results.length; i++) {
        expect(program.statements[i].token.tokenType, equals(TType.VAR),
            reason: 'Statement token type should be var');
        expect(program.statements[i] is VarStatement, true,
            reason: 'Statement should be VarStatement');
        expect((program.statements[i] as VarStatement).name.token.tokenType,
            results[i].tokenType,
            reason: 'Token type should be IDENTIFIER');
        expect((program.statements[i] as VarStatement).name.token, results[i],
            reason: 'Token should be ${results[i]}');
      }
    });
    test('Test for return statements', () {
      var input = '''return 10;
    return 32432;
    ''';

      var p = Parser(input);
      var program = p.parseProgram();

      for (var e in p.errors) {
        // Print each error
        expect(e == null, true, reason: '$e');
      }
      expect(program == null, equals(false),
          reason: 'Program should not be null');
      expect(program.statements.length, equals(2),
          reason: 'Statement length should be 2');

      for (var i = 0; i < program.statements.length; i++) {
        expect(program.statements[i] is ReturnStatement, true,
            reason: 'Not a returnStatement');
        expect(program.statements[i].token.tokenType == TType.RETURN, true,
            reason: 'Not a return token');
      }
    });
    test('Test for toString methods of VAR', () {
      var program = Program();
      var varStatement = VarStatement();
      varStatement.name = Expression(Token.fromIdentifier('data'));
      varStatement.value = Expression(Token.fromIdentifier('data2'));
      program.statements.add(varStatement);
      expect(program.toString(), 'TType.VAR data = data2;',
          reason: 'VarStatement toString method is faulty');
    });
    test('Test for toString method of RETURN', () {
      var program = Program();
      var returnStatement = ReturnStatement();
      returnStatement.returnValue = Expression(Token.fromIdentifier('xy'));
      program.statements.add(returnStatement);
      expect(program.toString(), 'TType.RETURN xy;',
          reason: 'ReturnStatement toString method is faulty');
    });
  });
  group('Parsing Expressions', () {
    test('Test for identifier expression', () {
      var input = 'hello;';
      var p = Parser(input);
      var program = p.parseProgram();
      expect(p.errors.length, 0, reason: 'Parser has error(s):\n${p.errors}');
      expect(program.statements.length, 1,
          reason: 'The output should be 1 statement');
      var statement = program.statements[0];
      expect(statement is ExpressionStatement, true,
          reason: 'Statement is not expression statement');
      expect((statement as ExpressionStatement).expression.token.content,
          equals('hello'),
          reason: 'Identifier value is not hello');
    });
    test('Test for integer Expression', () {
      var input = '10;20;';
      var p = Parser(input);
      var program = p.parseProgram();
      expect(p.errors.length, 0, reason: 'Parser has error(s):\n${p.errors}');
      expect(program.statements.length, 2,
          reason: 'The output should be 2 statement');
      var statement = program.statements[0];
      expect(statement is ExpressionStatement, true,
          reason: 'Statement is not expression statement');
      expect(
          (statement as ExpressionStatement).expression is IntegerLiteral, true,
          reason: 'Statement.expression is not integer literal');
      expect(
          ((statement as ExpressionStatement).expression as IntegerLiteral)
              .value,
          equals(10),
          reason: 'Identifier value is not hello');
    });

    test('Test for prefix expression (!)', () {
      var input = '!43;';
      var op = '!';
      var val = 43;

      var p = Parser(input);
      var program = p.parseProgram();
      expect(p.errors.length, 0, reason: 'There should not be any error:\n${p.errors}');
      expect(program.statements.length, 1,
          reason: 'Length of the program should be 1');
      expect(program.statements[0] is ExpressionStatement, true,
          reason: 'Statement should be ExpressionStatement');
      expect((program.statements[0] as ExpressionStatement).expression is PrefixExpression,true,
      reason: 'Statement.expression should be prefixExpression');
      expect(((program.statements[0] as ExpressionStatement).expression as PrefixExpression).operator,
      op,reason: 'Operator should be $op');
      expect((((program.statements[0] as ExpressionStatement).expression as PrefixExpression).data as IntegerLiteral).value,
      val,reason: 'The number is not $val');
    });
    test('Test for prefix expression (-)', () {
      var input = '-3;';
      var op = '-';
      var val = 3;

      var p = Parser(input);
      var program = p.parseProgram();
      expect(p.errors.length, 0, reason: 'There should not be any error:\n${p.errors}');
      expect(program.statements.length, 1,
          reason: 'Length of the program should be 1');
      expect(program.statements[0] is ExpressionStatement, true,
          reason: 'Statement should be ExpressionStatement');
      expect((program.statements[0] as ExpressionStatement).expression is PrefixExpression,true,
          reason: 'Statement.expression should be prefixExpression');
      expect(((program.statements[0] as ExpressionStatement).expression as PrefixExpression).operator,
          op,reason: 'Operator should be $op');
      expect((((program.statements[0] as ExpressionStatement).expression as PrefixExpression).data as IntegerLiteral).value,
          val,reason: 'The number is not $val');
    });
  });
}
