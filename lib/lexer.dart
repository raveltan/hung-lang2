import 'package:hung_lang2/token.dart';

class Lexer {
  final String input;
  int position = 0;
  int readPosition = 0;
  String current;

  Lexer(this.input) {
    readCharacter();
  }

  void readCharacter() {
    if (readPosition >= input.length) {
      current = '';
    } else {
      current = input[readPosition];
    }
    position = readPosition;
    readPosition++;
  }

  Token nextToken() {
    Token result;
    switch (current) {
      case '=':
        {
          result = Token(TType.EQUAL);break;
        }
      case '+':
        {
          result = Token(TType.ADD);break;
        }
      case ',':
        {
          result = Token(TType.COMMA);break;
        }
      case ';':
        {
          result = Token(TType.SEMICOLON);break;
        }
      case '(':
        {
          result = Token(TType.LEFT_PAREN);break;
        }
      case ')':
        {
          result = Token(TType.RIGHT_PAREN);break;
        }
      case '{':
        {
          result = Token(TType.LEFT_BRACE);break;
        }
      case '}':
        {
          result = Token(TType.RIGHT_BRACE);break;
        }
      default:
        {
          result = Token(TType.ILLEGAL);break;
        }
    }
    readCharacter();
    return result;
  }
}
