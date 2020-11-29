import 'package:hung_lang2/entity.dart';
import 'package:hung_lang2/evaluator.dart';
import 'package:hung_lang2/parser.dart';
import 'package:test/test.dart';

void main() {
  test('Test Number Evaluation', () {
    var input = ['5', '-10', '10', '-20'];
    var expected = [5, -10, 10, -20];
    var e = Evaluator();
    for (var i = 0; i < input.length; i++) {
      var p = Parser(input[i]);
      expect(p.errors.length, 0,
          reason: 'Parser on $i has error(s):\n${p.errors}');
      var entity = e.eval(p.parseProgram());
      expect(entity is Number, true, reason: 'Entity on $i should be number');
      var num = entity as Number;
      expect(num.value == expected[i], true,
          reason: 'Value on $i is unexpected');
    }
  });
  test('Test Boolean Evaluation', () {
    var input = 'true';
    var expected = true;
    var p = Parser(input);
    expect(p.errors.length, 0, reason: 'Parser has error(s):\n${p.errors}');
    var entity = Evaluator().eval(p.parseProgram());
    expect(entity is Boolean, true, reason: 'Entity should be boolean entity');
    var bool = entity as Boolean;
    expect(bool.value == expected, true, reason: 'Value is unexpected');
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
      var entity = e.eval(program);
      expect(entity is Boolean, true, reason: 'Entity $i should be boolean');
      var bool = entity as Boolean;
      expect(bool.value, expected[i], reason: 'Value on $i is unexpected');
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
      var entity = e.eval(program);
      expect(entity is Number, true, reason: 'Entity $i should be number');
      var num = entity as Number;
      expect(num.value, expected[i], reason: 'Value on $i is unexpected');
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
      var entity = e.eval(program);
      expect(entity is Boolean, true, reason: 'Entity $i should be boolean');
      var bool = entity as Boolean;
      expect(bool.value, expected[i], reason: 'Value on $i is unexpected');
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
      var entity = e.eval(program);
      expect(entity is Boolean, true, reason: 'Entity $i should be boolean');
      var bool = entity as Boolean;
      expect(bool.value, expected[i], reason: 'Value on $i is unexpected');
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
      var entity = e.eval(program);
      expect(entity is Number || entity == null, true,
          reason: 'Entity $i should be number or null');
      var data = entity is Number ? entity : null;
      expect(data is Number ? data.value : data, expected[i],
          reason: 'Value on $i is unexpected');
    }
  });
}
