import 'package:hung_lang2/ast.dart';
import 'package:hung_lang2/entity.dart';
import 'package:hung_lang2/system.dart';
import 'package:hung_lang2/token.dart';

class Evaluator {
  Entity eval(Node node, System s) {
    switch (node.runtimeType) {
      case CallExpression:
        var args = _evalExpression((node as CallExpression).args, s);
        if (args.length == 1 && args[0] is ErrorEntity) return args[0];
        var builtinRes = _doBuiltInFunction(node, args, s);
        if (builtinRes != null && builtinRes is Entity) {
          if (builtinRes is ErrorEntity) {
            return builtinRes;
          } else {
            if ((builtinRes).type != EntityType.NULL) {
              return builtinRes;
            }
            break;
          }
        }
        var func = eval((node as CallExpression).funcName, s);
        if (func is ErrorEntity) return func;
        return _doFunction(func, args, s);
      case FunctionLiteral:
        var fl = node as FunctionLiteral;
        var params = fl.params;
        var body = fl.body;
        return FunctionEntity(params, body);
      case VarStatement:
        var value = eval((node as VarStatement).value, s);
        if (value is ErrorEntity) return value;
        s.setVariable((node as VarStatement).name.token.content, value);
        break;
      case ReturnStatement:
        var result = eval((node as ReturnStatement).returnValue, s);
        return result is ErrorEntity ? result : ReturnEntity(result);
      case Program:
        return _evalProgram((node as Program).statements, s);
      case MultilineStatement:
        return _evalMultilineStatements(
            (node as MultilineStatement).statements, s);
      case ExpressionStatement:
        return eval((node as ExpressionStatement).expression, s);
      case NumberLiteral:
        return Number((node as NumberLiteral).value);
      case BooleanLiteral:
        return Boolean((node as BooleanLiteral).data);
      case PrefixExpression:
        var data = eval((node as PrefixExpression).data, s);
        return data is ErrorEntity
            ? data
            : _evalPrefixExpression((node as PrefixExpression).operator, data);
      case InfixExpression:
        var leftData = eval((node as InfixExpression).left, s);
        if (leftData is ErrorEntity) return leftData;
        var rightData = eval((node as InfixExpression).right, s);
        if (rightData is ErrorEntity) return rightData;
        return _evalInfixExpression(
            (node as InfixExpression).operator, leftData, rightData);
      case IfExpression:
        return _evalIfExpression(node as IfExpression, s);
      // WARNING: DO NOT PUT CASES BELOW EXPRESSION, EVALUATOR MAY BREAK.
      case Expression:
        if ((node as Expression).token.tokenType == TType.IDENTIFIER) {
          return _evalIdentifier(node as Expression, s);
        }
    }

    return null;
  }

  Entity _doFunction(Entity func, List<Entity> args, System s) {
    if (!(func is FunctionEntity)) {
      return ErrorEntity(
          'NOT A FUNCTION', 'Unable to invoke from ${func.type}');
    }
    var newSystem = System.closedSystem(s);
    for (var i = 0; i < (func as FunctionEntity).params.length; i++) {
      newSystem.setVariable(
          (func as FunctionEntity).params[i].token.content, args[i]);
      i = i;
    }
    var result = eval((func as FunctionEntity).body, newSystem);
    if (result is ReturnEntity) return (result).data;
    return result;
  }

  List<Entity> _evalExpression(List<Expression> datas, System s) {
    var result = <Entity>[];
    for (var data in datas) {
      var evaluated = eval(data, s);
      if (evaluated is ErrorEntity) return [evaluated];
      result.add(evaluated);
    }
    return result;
  }

  Entity _evalIdentifier(Expression data, System s) {
    var varContent = s.getVariable(data.token.content);
    if (varContent == null) {
      return ErrorEntity(
          'UNDEFINED VARIABLE', 'Variable ${data.token.content} is undefined');
    }
    return varContent;
  }

  Entity _doBuiltInFunction(Node node, List<Entity> args, System s) {
    var name = (node as CallExpression).funcName.token.content;
    if (name == 'write') {
      if (args.isEmpty) {
        return ErrorEntity('Empty print', 'Print was called with empty args');
      }
      var result = '';
      for (var i = 0; i < args.length; i++) {
        result += args[i].toString();
        if (i != args.length - 1) result += ' ';
      }
      print(result);
      return Entity(EntityType.NULL);
    } else if (name == 'mod') {
      if (args.length != 2) {
        return ErrorEntity(
            'Incorrect Params', 'Mod was not called with 2 args');
      }
      if (!(args[0] is Number && args[1] is Number)) {
        return ErrorEntity(
            'Incompatible types', 'Mod was not called with number types');
      }
      var left = (args[0] as Number).data;
      var right = (args[1] as Number).data;
      var res = left % right;
      return Number(res);
    } else if (name == 'for') {
      // for(start,end,increment,function)
      // f(index,end){ //do your stuff }
      if (args.length != 4) {
        return ErrorEntity(
            'Incorrect params', 'For was not called with 4 args');
      }
      if (args[0].type != EntityType.NUMBER ||
          args[1].type != EntityType.NUMBER ||
          args[2].type != EntityType.NUMBER) {
        return ErrorEntity(
            'Incompatible types', 'While was called with incompatible types');
      }
      for (var i = (args[0] as Number).data;
          (args[1] as Number).data > (args[0] as Number).data
              ? i <= (args[1] as Number).data
              : i >= (args[1] as Number).data;
          i += (args[2] as Number).data) {
        (args[0] as Number).data = i;
        _doFunction(args[3] as FunctionEntity, [args[0], args[1], args[2]], s);
      }
      return Entity(EntityType.NULL);
    } else if (name == 'and'){
      // and(10>5,20>3) -> true
      if(args.length !=2){
        return ErrorEntity('Incorrect params', 'And was not called with 2 args');
      }
      if(!(args[0] is Boolean && args[1] is Boolean)){
        return ErrorEntity('Incompatible types', 'And was called with incompatible types');
      }
      return Boolean((args[0] as Boolean).data && (args[1] as Boolean).data);
    }
    else if (name == 'or'){
      // and(10>5,20>3) -> true
      if(args.length !=2){
        return ErrorEntity('Incorrect params', 'And was not called with 2 args');
      }
      if(!(args[0] is Boolean && args[1] is Boolean)){
        return ErrorEntity('Incompatible types', 'And was called with incompatible types');
      }
      return Boolean((args[0] as Boolean).data || (args[1] as Boolean).data);
    }

    return null;
  }

  Entity _evalProgram(List<Statement> statements, System s) {
    Entity result;
    for (var statement in statements) {
      result = eval(statement, s);
      if (result is ReturnEntity) {
        return result.data;
      } else if (result is ErrorEntity) return result;
    }
    return result;
  }

  Entity _evalMultilineStatements(List<Statement> statements, System s) {
    Entity result;
    for (var statement in statements) {
      result = eval(statement, s);
      if (result != null && (result is ReturnEntity || result is ErrorEntity)) {
        return result;
      }
    }
    return result;
  }

  Entity _evalIfExpression(IfExpression expression, System s) {
    var condition = eval(expression.condition, s);
    if (condition is ErrorEntity) return condition;
    if ((condition is Boolean && condition.data == true) ||
        (!(condition is Null) &&
            !(condition is Boolean && condition.data == false))) {
      var r = eval(expression.result, s);
      return r;
    } else if (expression.alternative?.statements?.isNotEmpty ?? false) {
      return eval(expression.alternative, s);
    } else {
      return Null();
    }
  }

  Entity _evalInfixExpression(String operator, Entity left, Entity right) {
    if (left.type == EntityType.NUMBER && right.type == EntityType.NUMBER) {
      return _evalNumberInfixExpression(operator, left, right);
    } else if (operator == '==') {
      return Boolean(left == right);
    } else if (operator == '!=') {
      return Boolean(!(left == right));
    } else if (left.type != right.type) {
      return ErrorEntity('Incompatible Type',
          'Unable to complete binary operation between incompatible types ${left.type} and ${right.type}');
    } else {
      return ErrorEntity('Unknown operator',
          'Unable to complete binary operation between ${left.type}, ${right.type} with $operator');
    }
  }

  Entity _evalNumberInfixExpression(
      String operator, Entity left, Entity right) {
    var valLeft = (left as Number).data;
    var valRight = (right as Number).data;

    switch (operator) {
      case '+':
        return Number(valLeft + valRight);
      case '-':
        return Number(valLeft - valRight);
      case '*':
        return Number(valLeft * valRight);
      case '/':
        return Number(valLeft ~/ valRight);
      case '<':
        return Boolean(valLeft < valRight);
      case '>':
        return Boolean(valLeft > valRight);
      case '==':
        return Boolean(valLeft == valRight);
      case '!=':
        return Boolean(valLeft != valRight);
      default:
        return ErrorEntity('Unknown Operator',
            'Unable to do number binary operation with $operator');
    }
  }

  Entity _evalPrefixExpression(String operator, Entity data) {
    switch (operator) {
      case '!':
        return _evalNotOperatorExpression(data);
      case '-':
        return _evalMinOperatorExpression(data);
      default:
        return ErrorEntity('Unknown operator',
            'Unable to complete unary operation between $operator and ${data.type}');
    }
  }

  Entity _evalNotOperatorExpression(Entity data) {
    switch (data.toString()) {
      case 'true':
        return Boolean(false);
      case 'false':
        return Boolean(true);
      case 'null':
        return Boolean(true);
      default:
        return Boolean(false);
    }
  }

  Entity _evalMinOperatorExpression(Entity data) =>
      data.type != EntityType.NUMBER
          ? ErrorEntity('Not A Number',
              'Cannot do negation operation on non number type ${data.type}')
          : Number(-(data as Number).data);
}
