// Definition of available token types
enum TType {
  ILLEGAL,
  EOF,
  IDENTIFIER,
  NUMBER,
  // Operators
  EQUAL,
  ADD,
  SUB,
  NOT,
  MUL,
  DIV,
  LESSER,
  BIGGER,
  //Double Operators
  DOUBLE_EQUAL,
  NOT_EQUAL,
  // Delimiters
  COMMA,
  SEMICOLON,
  LEFT_PAREN,
  RIGHT_PAREN,
  LEFT_BRACE,
  RIGHT_BRACE,
  // Keywords
  METHOD,
  VAR,
  TRUE,
  FALSE,
  IF,
  ELSE,
  RETURN,
}

class Token {
  final TType tokenType;
  String content;

  Token(this.tokenType, {this.content = ''});

  Token.fromIdentifier(String identifier)
      : tokenType = _keywordParser(identifier),
        content = identifier;

  static TType _keywordParser(String identifier) {
    // Check if an identifier is a keyword.
    switch (identifier) {
      case 'f':
        {
          return TType.METHOD;
        }
      case 'var':
        {
          return TType.VAR;
        }
      case 'true':{
        return TType.TRUE;
      }
      case 'false':{
        return TType.FALSE;
      }
      case 'if':{
        return TType.IF;
      }
      case 'else':{
        return TType.ELSE;
      }
      case 'return':{
        return TType.RETURN;
      }
      default:
        {
          return TType.IDENTIFIER;
        }
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Token && other.tokenType == tokenType;
  }

  @override
  String toString() {
    return '($tokenType,$content)';
  }
}
