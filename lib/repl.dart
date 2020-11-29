import 'dart:io';

import 'package:hung_lang2/evaluator.dart';
import 'package:hung_lang2/lexer.dart';
import 'package:hung_lang2/parser.dart';
import 'package:hung_lang2/token.dart';

class Repl{
  static void start(){
    var run = true;
    var e = Evaluator();
    while(run){
      stdout.write('~ ');
      var input = stdin.readLineSync();
      // Check for REPL specific keyword
      if (input == '.exit'){
        return;
      }
      var p = Parser(input);
      var result = p.parseProgram();
      print('Parsed: ' + (p.errors.isEmpty ? result.toString() : p.errors.toString()));
      print('Eval: ' + e.eval(result).toString());
    }
  }
}
