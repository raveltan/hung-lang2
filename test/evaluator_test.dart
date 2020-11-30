import 'package:hung_lang2/entity.dart';
import 'package:hung_lang2/evaluator.dart';
import 'package:hung_lang2/parser.dart';
import 'package:hung_lang2/system.dart';
import 'package:test/test.dart';

void main() {
  test('Test Number Evaluation', () {
    var input = ['5', '-10', '10', '-20'];
    var expected = [5, -10, 10, -20];
    var e = Evaluator();
    for (var i = 0; i < input.length; i++) {
      var p = Parser(input[i]);
      var s = System();
      expect(p.errors.length, 0,
          reason: 'Parser on $i has error(s):\n${p.errors}');
      var entity = e.eval(p.parseProgram(), s);
      expect(entity is Number, true, reason: 'Entity on $i should be number');
      var num = entity as Number;
      expect(num.data == expected[i], true,
          reason: 'Value on $i is unexpected');
    }
  });
  test('Test Boolean Evaluation', () {
    var input = 'true';
    var expected = true;
    var p = Parser(input);
    var s = System();
    expect(p.errors.length, 0, reason: 'Parser has error(s):\n${p.errors}');
    var entity = Evaluator().eval(p.parseProgram(), s);
    expect(entity is Boolean, true, reason: 'Entity should be boolean entity');
    var bool = entity as Boolean;
    expect(bool.data == expected, true, reason: 'Value is unexpected');
  });
  test('Test prefix statement evaluation', () {
    var input = ['!true', '!false', '!!false', '!!true', '!!!false'];
    var expected = [false, true, false, true, true];
    var e = Evaluator();
    for (var i = 0; i < input.length; i++) {
      var p = Parser(input[i]);
      expect(p.errors.isEmpty, true,
          reason: 'Parsing on $i has error(s):\n${p.errors}');
      var program = p.parseProgram();
      var s = System();
      var entity = e.eval(program, s);
      expect(entity is Boolean, true, reason: 'Entity $i should be boolean');
      var bool = entity as Boolean;
      expect(bool.data, expected[i], reason: 'Value on $i is unexpected');
    }
  });
  test('Test for number infix expression Evaluation', () {
    var input = ['5*20+20', '90-8*2/2', '10-3'];
    var expected = [120, 82, 7];
    var e = Evaluator();
    for (var i = 0; i < input.length; i++) {
      var p = Parser(input[i]);
      expect(p.errors.isEmpty, true,
          reason: 'Parsing on $i has error(s):\n${p.errors}');
      var program = p.parseProgram();
      var s = System();
      var entity = e.eval(program, s);
      expect(entity is Number, true, reason: 'Entity $i should be number');
      var num = entity as Number;
      expect(num.data, expected[i], reason: 'Value on $i is unexpected');
    }
  });
  test('Test for boolean resulting number infix expression evaluation', () {
    var input = ['1<2', '4>9', '1 == 1', '8!=9'];
    var expected = [true, false, true, true];
    var e = Evaluator();
    for (var i = 0; i < input.length; i++) {
      var p = Parser(input[i]);
      expect(p.errors.isEmpty, true,
          reason: 'Parsing on $i has error(s):\n${p.errors}');
      var program = p.parseProgram();
      var s = System();
      var entity = e.eval(program, s);
      expect(entity is Boolean, true, reason: 'Entity $i should be boolean');
      var bool = entity as Boolean;
      expect(bool.data, expected[i], reason: 'Value on $i is unexpected');
    }
  });
  test('Test for boolean resulting boolean infix expression evalutaion', () {
    var input = [
      'true==false',
      'false!=true',
      '(1>2) == false',
      '(5==10) != true'
    ];
    var expected = [false, true, true, true];
    var e = Evaluator();
    for (var i = 0; i < input.length; i++) {
      var p = Parser(input[i]);
      expect(p.errors.isEmpty, true,
          reason: 'Parsing on $i has error(s):\n${p.errors}');
      var program = p.parseProgram();
      var s = System();
      var entity = e.eval(program, s);
      expect(entity is Boolean, true, reason: 'Entity $i should be boolean');
      var bool = entity as Boolean;
      expect(bool.data, expected[i], reason: 'Value on $i is unexpected');
    }
  });
  test('Test for if expression', () {
    var input = [
      'if(false){20}',
      'if(!false){30}',
      'if(1){20}',
      'if(1){20}else{30}',
      'if(1>9){30}else{40}'
    ];
    var expected = [null, 30, 20, 20, 40];
    var e = Evaluator();
    for (var i = 0; i < input.length; i++) {
      var p = Parser(input[i]);
      expect(p.errors.isEmpty, true,
          reason: 'Parsing on $i has error(s):\n${p.errors}');
      var program = p.parseProgram();
      var s = System();
      var entity = e.eval(program, s);
      expect(entity is Number || entity is Null, true,
          reason: 'Entity $i should be number or null');
      var data = entity is Number ? entity : null;
      expect(data is Number ? data.data : data, expected[i],
          reason: 'Value on $i is unexpected');
    }
  });
  test('Test for return statements', () {
    var input = [
      '30>5;return 9*9;',
      'return 10;20;',
      '''
    if(50>49){
    if(10>1{
      return 8*8;
      }
      return 5+2;
      }
    '''
    ];
    var expected = [81, 10, 64];
    var e = Evaluator();
    for (var i = 0; i < input.length; i++) {
      var p = Parser(input[i]);
      expect(p.errors.isEmpty, true,
          reason: 'Parsing on $i has error(s):\n${p.errors}');
      var program = p.parseProgram();
      var s = System();
      var entity = e.eval(program, s);
      expect(entity is Number, true, reason: 'Entity should be number');
      expect(((entity as Number).data), expected[i],
          reason: 'Value on $i is not ${expected[i]}');
    }
  });
  test('Test for variable declaration and evaluation', () {
    var input = [
      'var x = 20*6;x',
      'var y = 8*8-2;y',
      'var a = 10;var b= 20;var c =a*b;c'
    ];
    var expected = [120, 62, 200];
    var e = Evaluator();
    for (var i = 0; i < input.length; i++) {
      var p = Parser(input[i]);
      expect(p.errors.isEmpty, true,
          reason: 'Parsing on $i has error(s):\n${p.errors}');
      var program = p.parseProgram();
      var s = System();
      var entity = e.eval(program, s);
      expect(entity is Number, true, reason: 'Entity $i should be number');
      expect(((entity as Number).data), expected[i],
          reason: 'Value on $i is not ${expected[i]}');
    }
  });
  test('Test for function evaluation 1', () {
    var input = 'f(x) {x*10;};';
    var e = Evaluator();
    var p = Parser(input);
    expect(p.errors.isEmpty, true,
        reason: 'Parsing on  has error(s):\n${p.errors}');
    var programs = p.parseProgram();
    var s = System();
    var entity = e.eval(programs, s);

    expect(entity is FunctionEntity, true,
        reason: 'Entity should be function entity');
    var fe = entity as FunctionEntity;
    expect(fe.params.length == 1, true, reason: 'Params length should be 1');
    expect(fe.params[0].token.content == "x", true);
    expect(fe.body.statements.length == 1, true);
  });
  test('Test for function evaluation 2', () {
    var input = [
      'var count = f(a){a*100};count(100)',
      'var add = f(a,b){a+b};add(1,2);',
      'var mul = f(a){ f(b) {a*b} };var x = mul(10);x(20);'
    ];
    var expected = [10000, 3,200];
    var e = Evaluator();
    for (var i = 0; i < input.length; i++) {
      var p = Parser(input[i]);
      expect(p.errors.isEmpty, true,
          reason: 'Parsing on $i has error(s):\n${p.errors}');
      var program = p.parseProgram();
      var s = System();
      var entity = e.eval(program, s);
      expect(entity is Number, true, reason: 'Entity should be number');
      expect(((entity as Number).data), expected[i],
          reason: 'Value on $i is not ${expected[i]}');
    }
  });
}
