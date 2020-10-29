// Definition of available token types
enum TType{
  ILLEGAL,
  EOF,
  IDENTIFIER,

  INTEGER,
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

class Token{
  final TType tokenType;
  Token(this.tokenType);

  @override
  bool operator ==(Object other) {
    return other is Token && other.tokenType == tokenType;
  }

  @override
  String toString() {
    return tokenType.toString();
  }
}

