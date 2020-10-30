import 'package:hung_lang2/token.dart';

class Lexer {
  final String _input;
  int _position = 0;
  int _readPosition = 0;
  String _current;

  Lexer(this._input) {
    _readNextCharacter();
  }

  void _readNextCharacter() {
    if (_readPosition >= _input.length) {
      _current = '';
    } else {
      _current = _input[_readPosition];
    }
    _position = _readPosition;
    _readPosition++;
  }

  Token nextToken() {
    Token result;
    // Skip all whitespaces.
    while (_current == ' ' ||
        _current == '\t' ||
        _current == '\n' ||
        _current == '\r') {
      _readNextCharacter();
    }
    switch (_current) {
      case '=':
        {
          // Add condition for double operator
          if (_seeNextChar() == '=') {
            _readNextCharacter();
            result = Token(TType.DOUBLE_EQUAL);
          } else {
            result = Token(TType.EQUAL);
          }
          break;
        }
      case '+':
        {
          result = Token(TType.ADD);
          break;
        }
      case '-':
        {
          result = Token(TType.SUB);
          break;
        }
      case '!':
        {
          // Add new condition for double operator
          if (_seeNextChar() == '='){
            _readNextCharacter();
            result = Token(TType.NOT_EQUAL);
          }else{
            result = Token(TType.NOT);
          }
          break;
        }
      case '*':
        {
          result = Token(TType.MUL);
          break;
        }
      case '/':
        {
          result = Token(TType.DIV);
          break;
        }
      case '<':
        {
          result = Token(TType.LESSER);
          break;
        }
      case '>':
        {
          result = Token(TType.BIGGER);
          break;
        }
      case ',':
        {
          result = Token(TType.COMMA);
          break;
        }
      case ';':
        {
          result = Token(TType.SEMICOLON);
          break;
        }
      case '(':
        {
          result = Token(TType.LEFT_PAREN);
          break;
        }
      case ')':
        {
          result = Token(TType.RIGHT_PAREN);
          break;
        }
      case '{':
        {
          result = Token(TType.LEFT_BRACE);
          break;
        }
      case '}':
        {
          result = Token(TType.RIGHT_BRACE);
          break;
        }
      case '':
        {
          result = Token(TType.EOF);
          break;
        }
      default:
        {
          // Check if the current character is a letter to make identifier.
          // WARNING: _ is not allowed as character in identifier.
          // data_new is not a valid identifier name.
          if (_isAsciiLetter(_current)) {
            // Read identifier / keyword
            // Add checks for the content of the identifier
            // Return appropriate token if it is keyword
            // Token is returned here as
            // readCharacter function is replace by the readIdentifier above
            return Token.fromIdentifier(_readIdentifier());
          }
          //check if the current character is number
          // TODO: ADD SUPPORT FOR DOUBLE
          if (_isNumber(_current)) {
            return Token(TType.NUMBER, content: _readNumber());
          }
          result = Token(TType.ILLEGAL);
          break;
        }
    }
    _readNextCharacter();
    return result;
  }

  // Get the next character without advancing
  String _seeNextChar() =>
      _readPosition >= _input.length ? '' : _input[_readPosition];

  bool _isNumber(String current) {
    // Space and empty checking is done on the top,
    // We need to recheck here
    if (current == '' || current == ' ') return false;
    return current.codeUnitAt(0) >= 48 && current.codeUnitAt(0) <= 57;
  }

  // WILL ONLY CHECK FOR ASCII CHARACTER
  // IDENTIFIER WOULD BE IMPOSSIBLE TO BE IN Unicode
  bool _isAsciiLetter(String current) {
    // Space and empty checking is done on the top,
    // We need to recheck here
    if (current == '' || current == ' ') return false;
    return current.codeUnitAt(0) >= 65 && current.codeUnitAt(0) <= 90 ||
        current.codeUnitAt(0) >= 97 && current.codeUnitAt(0) <= 122;
  }

  String _readIdentifier() {
    var pos = _position;
    while (_isAsciiLetter(_current)) {
      _readNextCharacter();
    }
    return _input.substring(pos, _position);
  }

  String _readNumber() {
    var pos = _position;
    while (_isNumber(_current)) {
      _readNextCharacter();
    }
    return _input.substring(pos, _position);
  }
}
