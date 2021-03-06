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
      case "'":
        var _pos = _position + 1;
        while(true){
          _readNextCharacter();
          if(_current == "'") break;
        }
        result = Token(TType.STRING,content: _input.substring(_pos,_position));
        break;
      case '=':
        {
          // Add condition for double operator
          if (_seeNextChar() == '=') {
            _readNextCharacter();
            result = Token(TType.DOUBLE_EQUAL,content: '==');
          } else {
            result = Token(TType.EQUAL,content: '=');
          }
          break;
        }
      case '+':
        {
          result = Token(TType.ADD,content: '+');
          break;
        }
      case '-':
        {
          // Need to set content - See parser.dart/_parsePrefixExpression()
          // See ast.dart/PrefixExpression
          result = Token(TType.SUB,content: '-');
          break;
        }
      case '!':
        {
          // Add new condition for double operator
          if (_seeNextChar() == '='){
            _readNextCharacter();
            result = Token(TType.NOT_EQUAL,content: '!=');
          }else{
            // Need to set content - See parser.dart/_parsePrefixExpression()
            // See ast.dart/PrefixExpression
            result = Token(TType.NOT,content: '!');
          }
          break;
        }
      case '*':
        {
          result = Token(TType.MUL,content: '*');
          break;
        }
      case '/':
        {
          result = Token(TType.DIV,content: '/');
          break;
        }
      case '<':
        {
          result = Token(TType.LESSER,content: '<');
          break;
        }
      case '>':
        {
          result = Token(TType.BIGGER,content: '>');
          break;
        }
      case ',':
        {
          result = Token(TType.COMMA,content: ',');
          break;
        }
      case ';':
        {
          result = Token(TType.SEMICOLON,content: ';');
          break;
        }
      case '(':
        {
          result = Token(TType.LEFT_PAREN,content: '(');
          break;
        }
      case ')':
        {
          result = Token(TType.RIGHT_PAREN,content: ')');
          break;
        }
      case '{':
        {
          result = Token(TType.LEFT_BRACE,content: '{');
          break;
        }
      case '}':
        {
          result = Token(TType.RIGHT_BRACE,content: '}');
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
