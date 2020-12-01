import 'dart:io';

import 'package:hung_lang2/evaluator.dart';
import 'package:hung_lang2/parser.dart';
import 'package:hung_lang2/system.dart';

class Repl {
  static void start(bool debug) {
    var run = true;
    var e = Evaluator();
    var s = System();
    while (run) {
      stdout.write('~ ');
      var input = stdin.readLineSync();
      // Check for REPL specific keyword
      if (input == '.exit') {
        return;
      }
      var p = Parser(input);
      var result = p.parseProgram();
      if (debug && p.errors.isEmpty) {
        print('AST: $result');
      } else if (p.errors.isNotEmpty) {
        print('Parsing Errors: ${p.errors}');
        continue;
      }
      var res = e.eval(result, s);
      if(res !=null) print(res);
    }
  }
}
