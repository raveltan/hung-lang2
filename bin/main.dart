import 'dart:io' show Platform;

import 'package:hung_lang2/repl.dart';

void main(List<String> arguments) {
  //var showToken = arguments.contains('--token');
  var dartVersion = Platform.version;
  print('Hung Lang 2 (v0.0.1)');
  print('Compiled on Dart $dartVersion');
  Repl.start();
}
