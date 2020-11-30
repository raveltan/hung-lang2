import 'dart:io' show File, Platform;

import 'package:hung_lang2/evaluator.dart';
import 'package:hung_lang2/parser.dart';
import 'package:hung_lang2/repl.dart';
import 'package:hung_lang2/system.dart';

void main(List<String> arguments) async{
  var debug = false;
  var fileLocation = arguments.isNotEmpty ? arguments[0] : null;
  if (fileLocation == null) {
    var dartVersion = Platform.version;
    print('Hung Lang 2 (v0.0.1)');
    print('Compiled on Dart $dartVersion');
    Repl.start(debug);
  } else {
    var file = File(fileLocation);
    var value = await file.readAsString();
    var p = Parser(value);
    var program = p.parseProgram();
    if(p.errors.isNotEmpty) {
      print(p.errors);
      return;
    }
    var e = Evaluator();
    var s = System();
    print(e.eval(program, s));
  }
}
