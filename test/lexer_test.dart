import 'package:hung_lang2/lexer.dart';
import 'package:hung_lang2/token.dart';
import 'package:test/test.dart';

void main(){
  group('Basic lexing tests', (){
    test('Test for basic operator and delimiter',(){
      var input = '=+,(){};';
      var result = [
        Token(TType.EQUAL),Token(TType.ADD),Token(TType.COMMA),Token(TType.LEFT_PAREN),
        Token(TType.RIGHT_PAREN),Token(TType.LEFT_BRACE),Token(TType.RIGHT_BRACE),
        Token(TType.SEMICOLON)
      ];
      var lexer = Lexer(input);
      for(var current in result){
        var t = lexer.nextToken();
        expect(t,equals(current));
      }
    });
  });
}