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
