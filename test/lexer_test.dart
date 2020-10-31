import 'package:hung_lang2/lexer.dart';
import 'package:hung_lang2/token.dart';
import 'package:test/test.dart';

void main() {
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
        expect(current,equals(t));
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
        Token.fromIdentifier('if'),
        Token.fromIdentifier('true'),
        Token(TType.LEFT_BRACE),
        Token.fromIdentifier('return'),
        Token.fromIdentifier('false'),
        Token(TType.SEMICOLON),
        Token(TType.RIGHT_BRACE),
        Token.fromIdentifier('else'),
        Token(TType.LEFT_BRACE),
        Token.fromIdentifier('return'),
        Token.fromIdentifier('true'),
        Token(TType.SEMICOLON),
        Token(TType.RIGHT_BRACE)
      ];
      var lexer = Lexer(input);
      for (var current in result) {
        var t = lexer.nextToken();
        expect(current,equals(t));
      }
    });
    test('Test for double character operators',(){
      var input = '''if data == 10{
        data = data != 20;
      }
      ''';
      var result = [
        Token.fromIdentifier('if'),
        Token.fromIdentifier('data'),
        Token(TType.DOUBLE_EQUAL),
        Token(TType.NUMBER,content: '10'),
        Token(TType.LEFT_BRACE),
        Token.fromIdentifier('data'),
        Token(TType.EQUAL),
        Token.fromIdentifier('data'),
        Token(TType.NOT_EQUAL),
        Token(TType.NUMBER,content: '20'),
        Token(TType.SEMICOLON),
        Token(TType.RIGHT_BRACE),
      ];
      var lexer = Lexer(input);
      for (var current in result) {
        var t = lexer.nextToken();
        expect(current,equals(t));
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
        Token.fromIdentifier('var'),
        Token.fromIdentifier('input'),
        Token(TType.EQUAL),
        Token(TType.NUMBER,content: '205'),
        Token(TType.SEMICOLON),
        Token.fromIdentifier('input'),
        Token(TType.EQUAL),
        Token.fromIdentifier('input'),
        Token(TType.DIV),
        Token(TType.NUMBER,content: '10'),
        Token(TType.SEMICOLON),
        Token.fromIdentifier('go'),
        Token(TType.LEFT_PAREN),
        Token(TType.NUMBER,content: '5'),
        Token(TType.BIGGER),
        Token(TType.NUMBER,content: '10'),
        Token(TType.COMMA),
        Token(TType.NUMBER,content: '50'),
        Token(TType.MUL),
        Token(TType.NUMBER,content: '2'),
        Token(TType.RIGHT_PAREN),
        Token(TType.SEMICOLON),
        Token(TType.NOT,content: '!'),
        Token.fromIdentifier('input'),
        Token(TType.SEMICOLON),
      ];
      var lexer = Lexer(input);
      for (var current in result) {
        var t = lexer.nextToken();
        expect(current,equals(t));
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
        Token.fromIdentifier('var'),
        Token.fromIdentifier('number'),
        Token(TType.EQUAL),
        Token(TType.NUMBER,content: '5'),
        Token(TType.SEMICOLON),
        Token.fromIdentifier('var'),
        Token.fromIdentifier('add'),
        Token(TType.EQUAL),
        Token.fromIdentifier('f'),
        Token(TType.LEFT_PAREN),
        Token.fromIdentifier('x'),
        Token(TType.COMMA),
        Token.fromIdentifier('y'),
        Token(TType.RIGHT_PAREN),
        Token(TType.LEFT_BRACE),
        Token.fromIdentifier('x'),
        Token(TType.ADD),
        Token.fromIdentifier('y'),
        Token(TType.SEMICOLON),
        Token(TType.RIGHT_BRACE),
        Token.fromIdentifier('var'),
        Token.fromIdentifier('result'),
        Token(TType.EQUAL),
        Token.fromIdentifier('add'),
        Token(TType.LEFT_PAREN),
        Token.fromIdentifier('number'),
        Token(TType.COMMA),
        Token(TType.NUMBER,content: '5'),
        Token(TType.RIGHT_PAREN)
      ];
      var lexer = Lexer(input);
      for (var current in result) {
        var t = lexer.nextToken();
        expect(current,equals(t));
      }
    });
}
