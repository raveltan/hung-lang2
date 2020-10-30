

import 'package:hung_lang2/lexer.dart';
import 'package:hung_lang2/token.dart';

void main(List<String> arguments) {
  var l = Lexer('''var number = 5;
      
      var add = f(x,y){
      x + y;
      }
      
      var result = add(number,5);''');
  var d = l.nextToken();
  print(d);
  while(d!=Token(TType.EOF)){
    d = l.nextToken();
    print(d);
  }
}
