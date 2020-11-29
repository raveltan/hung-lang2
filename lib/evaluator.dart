import 'package:hung_lang2/ast.dart';
import 'package:hung_lang2/entity.dart';
import 'package:hung_lang2/parser.dart';

class Evaluator {
  Entity eval(Node node) {
    switch (node.runtimeType) {
      case Program:
        return _evalStatements((node as Program).statements);
      case MultilineStatement:
        return _evalStatements((node as MultilineStatement).statements);
      case ExpressionStatement:
        return eval((node as ExpressionStatement).expression);
      case NumberLiteral:
        return Number((node as NumberLiteral).value);
      case BooleanLiteral:
        return Boolean((node as BooleanLiteral).data);
      case PrefixExpression:
        var data = eval((node as PrefixExpression).data);
        return _evalPrefixExpression((node as PrefixExpression).operator, data);
      case InfixExpression:
        var leftData = eval((node as InfixExpression).left);
        var rightData = eval((node as InfixExpression).right);
        return _evalInfixExpression(
            (node as InfixExpression).operator, leftData, rightData);
      case IfExpression:
        return _evalIfExpression(node as IfExpression);
    }

    return null;
  }

  Entity _evalIfExpression(IfExpression expression) {
    var condition = eval(expression.condition);
    if ((condition is Boolean && condition.value == true) ||
        (!(condition is Null) &&
            !(condition is Boolean && condition.value == false))) {
      var r =  eval(expression.result);
      return r;
    } else if (expression.alternative?.statements?.isNotEmpty ?? false) {
      return eval(expression.alternative);
    } else {
      return null;
    }
  }

  Entity _evalStatements(List<Statement> data) {
    Entity result;
    for (var s in data) {
      result = eval(s);
    }
    return result;
  }

  Entity _evalInfixExpression(String operator, Entity left, Entity right) {
    if (left.type == EntityType.NUMBER && right.type == EntityType.NUMBER) {
      return _evalNumberInfixExpression(operator, left, right);
    } else if (operator == '==') {
      return Boolean(left == right);
    } else if (operator == '!=') {
      return Boolean(!(left == right));
    } else {
      return null;
    }
  }

  Entity _evalNumberInfixExpression(
      String operator, Entity left, Entity right) {
    var valLeft = (left as Number).value;
    var valRight = (right as Number).value;

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
        return null;
    }
  }

  Entity _evalPrefixExpression(String operator, Entity data) {
    switch (operator) {
      case '!':
        return _evalNotOperatorExpression(data);
      case '-':
        return _evalMinOperatorExpression(data);
      default:
        return null;
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
      data.type != EntityType.NUMBER ? null : Number(-(data as Number).value);
}
