import 'dart:developer';
import 'dart:io';

import 'package:hung_lang2/ast.dart';
import 'package:hung_lang2/parser.dart';
import 'package:hung_lang2/token.dart';
import 'package:test/test.dart';

void main() {
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
      expect(program.statements[i] is ReturnStatement,true,reason: 'Not a returnStatement');
      expect(program.statements[i].token.tokenType==TType.RETURN,true,reason: 'Not a return token');
    }
  });
  test('Test for toString methods',(){
    var program = Program();
    var varStatement = VarStatement();
    varStatement.name = Expression(Token.fromIdentifier('data'));
    varStatement.value = Expression(Token.fromIdentifier('data2'));
    program.statements.add(varStatement);
    expect(program.toString(),'TType.VAR data = data2;',reason: 'toString method is faulty');
  });
}
