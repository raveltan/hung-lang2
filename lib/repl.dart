import 'dart:io';

import 'package:hung_lang2/lexer.dart';
import 'package:hung_lang2/token.dart';

class Repl{
  static void start(){
    var run = true;
    while(run){
      print('Type your command ~');
      var input = stdin.readLineSync();
      // Check for REPL specific keyword
      if (input == '.exit'){
        return;
      }
      var lex = Lexer(input);
      // TODO: remove or conditionally display.
      var currentToken = lex.nextToken();
      while(currentToken != Token(TType.EOF)){
        print(currentToken);
        currentToken = lex.nextToken();
      }
    }
  }
}
