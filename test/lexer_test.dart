import 'package:hung_lang2/lexer.dart';
import 'package:hung_lang2/token.dart';
import 'package:test/test.dart';

void main() {
  // Add test for strings
  test('Test for basic operator and delimiter', () {
    var input = '=+,(){};';
    var result = [
      Token(TType.EQUAL, content: '='),
      Token(TType.ADD, content: '+'),
      Token(TType.COMMA, content: ','),
      Token(TType.LEFT_PAREN, content: '('),
      Token(TType.RIGHT_PAREN, content: ')'),
      Token(TType.LEFT_BRACE, content: '{'),
      Token(TType.RIGHT_BRACE, content: '}'),
      Token(TType.SEMICOLON, content: ';'),
      Token(TType.EOF),
    ];
    var lexer = Lexer(input);
    for (var current in result) {
      var t = lexer.nextToken();
      expect(current, equals(t));
    }
  });
  test('Test for keyword (true,false,if,else,return)', () {
    var input = '''if true{
      return false;
      }else{
      return true;
      }
      ''';
    var result = [
      Token.fromIdentifier('if'),
      Token.fromIdentifier('true'),
      Token(TType.LEFT_BRACE, content: '{'),
      Token.fromIdentifier('return'),
      Token.fromIdentifier('false'),
      Token(TType.SEMICOLON, content: ';'),
      Token(TType.RIGHT_BRACE, content: '}'),
      Token.fromIdentifier('else'),
      Token(TType.LEFT_BRACE, content: '{'),
      Token.fromIdentifier('return'),
      Token.fromIdentifier('true'),
      Token(TType.SEMICOLON, content: ';'),
      Token(TType.RIGHT_BRACE, content: '}'),
      Token(TType.EOF)
    ];
    var lexer = Lexer(input);
    for (var current in result) {
      var t = lexer.nextToken();
      expect(current, equals(t));
    }
  });
  test('Test for double character operators', () {
    var input = '''if data == 10{
        data = data != 20;
      }
      ''';
    var result = [
      Token.fromIdentifier('if'),
      Token.fromIdentifier('data'),
      Token(TType.DOUBLE_EQUAL, content: '=='),
      Token(TType.NUMBER, content: '10'),
      Token(TType.LEFT_BRACE, content: '{'),
      Token.fromIdentifier('data'),
      Token(TType.EQUAL, content: '='),
      Token.fromIdentifier('data'),
      Token(TType.NOT_EQUAL, content: '!='),
      Token(TType.NUMBER, content: '20'),
      Token(TType.SEMICOLON, content: ';'),
      Token(TType.RIGHT_BRACE, content: '}'),
      Token(TType.EOF)
    ];
    var lexer = Lexer(input);
    for (var current in result) {
      var t = lexer.nextToken();
      expect(current, equals(t));
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
      Token(TType.EQUAL, content: '='),
      Token(TType.NUMBER, content: '205'),
      Token(TType.SEMICOLON, content: ';'),
      Token.fromIdentifier('input'),
      Token(TType.EQUAL, content: '='),
      Token.fromIdentifier('input'),
      Token(TType.DIV, content: '/'),
      Token(TType.NUMBER, content: '10'),
      Token(TType.SEMICOLON, content: ';'),
      Token.fromIdentifier('go'),
      Token(TType.LEFT_PAREN, content: '('),
      Token(TType.NUMBER, content: '5'),
      Token(TType.BIGGER, content: '>'),
      Token(TType.NUMBER, content: '10'),
      Token(TType.COMMA, content: ','),
      Token(TType.NUMBER, content: '50'),
      Token(TType.MUL, content: '*'),
      Token(TType.NUMBER, content: '2'),
      Token(TType.RIGHT_PAREN, content: ')'),
      Token(TType.SEMICOLON, content: ';'),
      Token(TType.NOT, content: '!'),
      Token.fromIdentifier('input'),
      Token(TType.SEMICOLON, content: ';'),
      Token(TType.EOF),
    ];
    var lexer = Lexer(input);
    for (var current in result) {
      var t = lexer.nextToken();
      expect(current, equals(t));
    }
  });
  test('Test for basic program', () {
    var input = '''var number = 5;
      
      var add = f(x,y){
      x + y;
      }
      var a = 'hello';
      var result = add(number,5);
      ''';
    // Added the result and test
    var result = [
      Token.fromIdentifier('var'),
      Token.fromIdentifier('number'),
      Token(TType.EQUAL, content: '='),
      Token(TType.NUMBER, content: '5'),
      Token(TType.SEMICOLON, content: ';'),
      Token.fromIdentifier('var'),
      Token.fromIdentifier('add'),
      Token(TType.EQUAL, content: '='),
      Token.fromIdentifier('f'),
      Token(TType.LEFT_PAREN, content: '('),
      Token.fromIdentifier('x'),
      Token(TType.COMMA, content: ','),
      Token.fromIdentifier('y'),
      Token(TType.RIGHT_PAREN, content: ')'),
      Token(TType.LEFT_BRACE, content: '{'),
      Token.fromIdentifier('x'),
      Token(TType.ADD, content: '+'),
      Token.fromIdentifier('y'),
      Token(TType.SEMICOLON, content: ';'),
      Token(TType.RIGHT_BRACE, content: '}'),
      Token.fromIdentifier('var'),
      Token.fromIdentifier('a'),
      Token(TType.EQUAL, content: '='),
      Token(TType.STRING, content: 'hello'),
      Token(TType.SEMICOLON,content: ';'),
      Token.fromIdentifier('var'),
      Token.fromIdentifier('result'),
      Token(TType.EQUAL, content: '='),
      Token.fromIdentifier('add'),
      Token(TType.LEFT_PAREN, content: '('),
      Token.fromIdentifier('number'),
      Token(TType.COMMA, content: ','),
      Token(TType.NUMBER, content: '5'),
      Token(TType.RIGHT_PAREN, content: ')'),
      Token(TType.SEMICOLON, content: ';'),
      Token(TType.EOF)
    ];
    var lexer = Lexer(input);
    for (var current in result) {
      var t = lexer.nextToken();
      expect(current, equals(t));
    }
  });
}
