// Definition of available token types
enum TType {
  ILLEGAL,
  EOF,
  IDENTIFIER,
  NUMBER,
  // Operators
  EQUAL,
  ADD,
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
