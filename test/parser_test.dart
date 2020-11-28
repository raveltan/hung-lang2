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
      expect(program.toString(), '{var data = data2;}',
          reason: 'VarStatement toString method is faulty');
    });
    test('Test for toString method of RETURN', () {
      var program = Program();
      var returnStatement = ReturnStatement();
      returnStatement.returnValue = Expression(Token.fromIdentifier('xy'));
      program.statements.add(returnStatement);
      expect(program.toString(), '{return xy;}',
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
      expect(p.errors.length, 0,
          reason: 'There should not be any error:\n${p.errors}');
      expect(program.statements.length, 1,
          reason: 'Length of the program should be 1');
      expect(program.statements[0] is ExpressionStatement, true,
          reason: 'Statement should be ExpressionStatement');
      expect(
          (program.statements[0] as ExpressionStatement).expression
              is PrefixExpression,
          true,
          reason: 'Statement.expression should be prefixExpression');
      expect(
          ((program.statements[0] as ExpressionStatement).expression
                  as PrefixExpression)
              .operator,
          op,
          reason: 'Operator should be $op');
      expect(
          (((program.statements[0] as ExpressionStatement).expression
                      as PrefixExpression)
                  .data as IntegerLiteral)
              .value,
          val,
          reason: 'The number is not $val');
    });
    test('Test for prefix expression (-)', () {
      var input = '-3;';
      var op = '-';
      var val = 3;

      var p = Parser(input);
      var program = p.parseProgram();
      expect(p.errors.length, 0,
          reason: 'There should not be any error:\n${p.errors}');
      expect(program.statements.length, 1,
          reason: 'Length of the program should be 1');
      expect(program.statements[0] is ExpressionStatement, true,
          reason: 'Statement should be ExpressionStatement');
      expect(
          (program.statements[0] as ExpressionStatement).expression
              is PrefixExpression,
          true,
          reason: 'Statement.expression should be prefixExpression');
      expect(
          ((program.statements[0] as ExpressionStatement).expression
                  as PrefixExpression)
              .operator,
          op,
          reason: 'Operator should be $op');
      expect(
          (((program.statements[0] as ExpressionStatement).expression
                      as PrefixExpression)
                  .data as IntegerLiteral)
              .value,
          val,
          reason: 'The number is not $val');
    });
    test('Test for infix expressions', () {
      var input = [
        '1 + 1;',
        '1!= 3;',
        '1==3;',
        '5-3;',
        '5<9;',
        '3*4;',
        '3/3;',
        '4>9;'
      ];
      var left = [1, 1, 1, 5, 5, 3, 3, 4];
      var right = [1, 3, 3, 3, 9, 4, 3, 9];
      var operator = ['+', '!=', '==', '-', '<', '*', '/', '>'];

      for (var i = 0; i < input.length; i++) {
        var p = Parser(input[i]);
        var program = p.parseProgram();
        expect(p.errors.length, 0, reason: 'Parser has error(s):\n${p.errors}');
        expect(program.statements.length, 1,
            reason: 'Program should have 1 statement');
        expect(program.statements[0] is ExpressionStatement, true,
            reason: 'Statement should be expressionStatement');
        var exStatement =
            (program.statements[0] as ExpressionStatement).expression;
        expect(exStatement is InfixExpression, true,
            reason: 'Statement should be InfixExpression');
        var inStatement = exStatement as InfixExpression;
        expect((inStatement.left as IntegerLiteral).value, left[i],
            reason: 'Left data should be ${left[i]}');
        expect((inStatement.right as IntegerLiteral).value, right[i],
            reason: 'Left data should be ${right[i]}');
        expect(inStatement.operator, operator[i],
            reason: 'Operator should be ${operator[i]}');
      }
    });
    test('Test for boolean literal', () {
      var input = 'true == false';
      var operator = '==';
      var left = true;
      var right = false;
      var p = Parser(input);
      var program = p.parseProgram();
      expect(p.errors.length, 0, reason: 'Parser has error(s):\n${p.errors}');
      expect(program.statements.length, 1,
          reason: 'Program should have 1 statement');
      expect(program.statements[0] is ExpressionStatement, true,
          reason: 'Expression should be expression statement');
      var exStatement = program.statements[0] as ExpressionStatement;
      expect(exStatement.expression is InfixExpression, true,
          reason: 'Expression statement should be infix expression');
      var inStatement = exStatement.expression as InfixExpression;
      expect(inStatement.left is BooleanLiteral, true,
          reason: 'Left data should be boolean');
      var leftData = inStatement.left as BooleanLiteral;
      expect(inStatement.operator, operator,
          reason: 'Operator should be $operator');
      expect(inStatement.right is BooleanLiteral, true,
          reason: 'Right data should be boolean literal');
      var rightData = inStatement.right as BooleanLiteral;
      expect(leftData.data, left, reason: 'Left data should be $left');
      expect(rightData.data, right, reason: 'right data should be $right');
    });
    test('Test for grouped expression', () {
      var input = ['1+(2+3)'];
      var result = ['{{1 + {2 + 3}}}'];
      for (var i = 0; i < input.length; i++) {
        var p = Parser(input[i]);
        var program = p.parseProgram();
        expect(p.errors.length, 0, reason: 'Parser has error(s):\n${p.errors}');
        expect(program.statements.length, 1,
            reason: 'Program should have 1 statement');
        expect(program.toString(), result[i], reason: 'AST is incorrect');
      }
    });
    test('Test for if expression', () {
      var input = 'if (a <b) {c}';
      var p = Parser(input);
      var program = p.parseProgram();
      expect(p.errors.length, 0, reason: 'Parser has error(s):\n${p.errors}');
      expect(program.statements.length, 1,
          reason: 'Statement length should be 1');
      expect(program.statements[0] is ExpressionStatement, true,
          reason: 'Statement should be expression statement');
      var expression =
          (program.statements[0] as ExpressionStatement).expression;
      expect(expression is IfExpression, true,
          reason: 'Statement is not if expression');
      var ifExpression = expression as IfExpression;
      expect(ifExpression.result.statements.length == 1, true,
          reason: 'Result statement length should be 1');
      expect(ifExpression.result.statements[0] is ExpressionStatement, true,
          reason: 'Result should be expression statement');
      expect(ifExpression.alternative == null, true,
          reason: 'Alternative statement should be null');
    });
    test('Test for if else expression', () {
      var input = 'if (a <b) {c} else {d}';
      var p = Parser(input);
      var program = p.parseProgram();
      expect(p.errors.length, 0, reason: 'Parser has error(s):\n${p.errors}');
      expect(program.statements.length, 1,
          reason: 'Statement length should be 1');
      expect(program.statements[0] is ExpressionStatement, true,
          reason: 'Statement should be expression statement');
      var expression =
          (program.statements[0] as ExpressionStatement).expression;
      expect(expression is IfExpression, true,
          reason: 'Statement is not if expression');
      var ifExpression = expression as IfExpression;
      expect(ifExpression.result.statements.length == 1, true,
          reason: 'Result statement length should be 1');
      expect(ifExpression.result.statements[0] is ExpressionStatement, true,
          reason: 'Result should be expression statement');
      expect(ifExpression.alternative == null, false,
          reason: 'Alternative statement should not be null');
      expect(ifExpression.alternative.statements.length == 1, true,
          reason: 'Alternative statement length should be 1');
      expect(
          ifExpression.alternative.statements[0] is ExpressionStatement, true,
          reason: 'Alternative should be expression statement');
    });
    test('Test for Function literal',(){
      var input = 'f(a,b) { a*b};';
      var p = Parser(input);
      var program = p.parseProgram();
      expect(p.errors.length,0,reason: 'Parser has error(s):\n${p.errors}');
      expect(program.statements.length,1,reason: 'Program should have 1 statement');
      expect(program.statements[0] is ExpressionStatement,true,reason: 'Program statement should be expression statement');
      var exStatement = program.statements[0] as ExpressionStatement;
      expect(exStatement.expression is FunctionLiteral,true,reason: 'Expression should be function literal');
      var funcLiteral = exStatement.expression as FunctionLiteral;
      expect(funcLiteral.params.length,2,reason: 'There should be 2 params');
      expect(funcLiteral.body.statements.length, 1,reason: 'There should be 1 statement in body');
      expect(funcLiteral.body.statements[0] is ExpressionStatement,true,reason: 'Function body should be expression statement');
    });
  });
}
