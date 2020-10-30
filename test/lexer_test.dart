import 'package:hung_lang2/lexer.dart';
import 'package:hung_lang2/token.dart';
import 'package:test/test.dart';

void main() {
  group('Lexing tests', () {
    test('Test for basic operator and delimiter', () {
      var input = '=+,(){};';
      var result = [
        Token(TType.EQUAL),
        Token(TType.ADD),
        Token(TType.COMMA),
        Token(TType.LEFT_PAREN),
        Token(TType.RIGHT_PAREN),
        Token(TType.LEFT_BRACE),
        Token(TType.RIGHT_BRACE),
        Token(TType.SEMICOLON)
      ];
      var lexer = Lexer(input);
      for (var current in result) {
        var t = lexer.nextToken();
        expect(t, equals(current));
      }
    });
    test('Test for keyword (true,false,if,else,return)',(){
      var input = '''if true{
      return false;
      }else{
      return true;
      }
      ''';
      var result = [
        Token(TType.IF),
        Token(TType.TRUE),
        Token(TType.LEFT_BRACE),
        Token(TType.RETURN),
        Token(TType.FALSE),
        Token(TType.SEMICOLON),
        Token(TType.RIGHT_BRACE),
        Token(TType.ELSE),
        Token(TType.LEFT_BRACE),
        Token(TType.RETURN),
        Token(TType.TRUE),
        Token(TType.SEMICOLON),
        Token(TType.RIGHT_BRACE)
      ];
      var lexer = Lexer(input);
      for (var current in result) {
        var t = lexer.nextToken();
        expect(t, equals(current));
      }
    });
    test('Test for double character operators',(){
      var input = '''if data == 10{
        data = data != 20;
      }
      ''';
      var result = [
        Token(TType.IF),
        Token(TType.IDENTIFIER),
        Token(TType.DOUBLE_EQUAL),
        Token(TType.NUMBER),
        Token(TType.LEFT_BRACE),
        Token(TType.IDENTIFIER),
        Token(TType.EQUAL),
        Token(TType.IDENTIFIER),
        Token(TType.NOT_EQUAL),
        Token(TType.NUMBER),
        Token(TType.SEMICOLON),
        Token(TType.RIGHT_BRACE),
      ];
      var lexer = Lexer(input);
      for (var current in result) {
        var t = lexer.nextToken();
        expect(t, equals(current));
      }
    });
    test('Test for single character operator', () {
      var input = '''
        var input= 205;
        input = input/10;
        go(5>10,50*2);
        !input;
      ''';
      // TODO: Add the correct test result
      var result = [
        Token(TType.VAR),
        Token(TType.IDENTIFIER),
        Token(TType.EQUAL),
        Token(TType.NUMBER),
        Token(TType.SEMICOLON),
        Token(TType.IDENTIFIER),
        Token(TType.EQUAL),
        Token(TType.IDENTIFIER),
        Token(TType.DIV),
        Token(TType.NUMBER),
        Token(TType.SEMICOLON),
        Token(TType.IDENTIFIER),
        Token(TType.LEFT_PAREN),
        Token(TType.NUMBER),
        Token(TType.BIGGER),
        Token(TType.NUMBER),
        Token(TType.COMMA),
        Token(TType.NUMBER),
        Token(TType.MUL),
        Token(TType.NUMBER),
        Token(TType.RIGHT_PAREN),
        Token(TType.SEMICOLON),
        Token(TType.NOT),
        Token(TType.IDENTIFIER),
        Token(TType.SEMICOLON),
      ];
      var lexer = Lexer(input);
      for (var current in result) {
        var t = lexer.nextToken();
        expect(t, equals(current));
      }
    });
    test('Test for basic program', () {
      var input = '''var number = 5;
      
      var add = f(x,y){
      x + y;
      }
      
      var result = add(number,5);
      ''';
      // Added the result and test
      var result = [
        Token(TType.VAR),
        Token(TType.IDENTIFIER),
        Token(TType.EQUAL),
        Token(TType.NUMBER),
        Token(TType.SEMICOLON),
        Token(TType.VAR),
        Token(TType.IDENTIFIER),
        Token(TType.EQUAL),
        Token(TType.METHOD),
        Token(TType.LEFT_PAREN),
        Token(TType.IDENTIFIER),
        Token(TType.COMMA),
        Token(TType.IDENTIFIER),
        Token(TType.RIGHT_PAREN),
        Token(TType.LEFT_BRACE),
        Token(TType.IDENTIFIER),
        Token(TType.ADD),
        Token(TType.IDENTIFIER),
        Token(TType.SEMICOLON),
        Token(TType.RIGHT_BRACE),
        Token(TType.VAR),
        Token(TType.IDENTIFIER),
        Token(TType.EQUAL),
        Token(TType.IDENTIFIER),
        Token(TType.LEFT_PAREN),
        Token(TType.IDENTIFIER),
        Token(TType.COMMA),
        Token(TType.NUMBER),
        Token(TType.RIGHT_PAREN)
      ];
      var lexer = Lexer(input);
      for (var current in result) {
        var t = lexer.nextToken();
        expect(t, equals(current));
      }
    });
  });
}
