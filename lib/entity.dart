import 'ast.dart';

enum EntityType { NUMBER, BOOLEAN, NULL,RETURN,ERROR,FUNCTION,ARRAY,STRING }

class Entity {
  Entity(this.type);

  final EntityType type;
}

class Number extends Entity {
  Number(this.data) : super(EntityType.NUMBER);
  int data;

  @override
  String toString() {
    return data.toString();
  }

  @override
  bool operator ==(Object other) {
    return other is Number && other.data == data;
  }
}
class StringEntity extends Entity{
  StringEntity(this.data) : super(EntityType.STRING);
  String data;

  @override
  String toString() {
    return "'$data'";
  }
}

class Array extends Entity{
  Array(this.data) : super(EntityType.ARRAY);
  List<dynamic> data;

  @override
  String toString() {
    return '$data';
  }

  @override
  bool operator ==(Object other) {
    return other is Array && other.data == data;
  }
}

class Boolean extends Entity {
  static final Boolean _true = Boolean._internal(true);
  static final Boolean _false = Boolean._internal(false);

  factory Boolean(bool value) => value ? _true : _false;

  Boolean._internal(this.data) : super(EntityType.BOOLEAN);
  bool data;

  @override
  String toString() {
    return data.toString();
  }

  @override
  bool operator ==(Object other) {
    return other is Boolean && other.data == data;
  }
}

class Null extends Entity {
  factory Null() => _null;
  static final Null _null = Null._internal();

  Null._internal() : super(EntityType.NULL);

  @override
  String toString() {
    return 'null';
  }
}

class ReturnEntity extends Entity{
  ReturnEntity(this.data) : super(EntityType.RETURN);
  Entity data;

  @override
  String toString() {
    return data.toString();
  }
}

class ErrorEntity extends Entity{
  ErrorEntity(this.errorType, this.message) : super(EntityType.ERROR);
  String message;
  String errorType;
  @override
  String toString() {
    return 'Evaluation Error: ($errorType) - $message';
  }
}

class FunctionEntity extends Entity{
  FunctionEntity(this.params,this.body) : super(EntityType.FUNCTION);

  List<Expression> params;
  MultilineStatement body;

  @override
  String toString() {
    return '<Function $hashCode>';
  }
}