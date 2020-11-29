enum EntityType { NUMBER, BOOLEAN, NULL }

class Entity {
  Entity(this.type);

  final EntityType type;
}

class Number extends Entity {
  Number(this.value) : super(EntityType.NUMBER);
  int value;

  @override
  String toString() {
    return value.toString();
  }

  @override
  bool operator ==(Object other) {
    return other is Number && other.value == value;
  }
}

class Boolean extends Entity {
  static final Boolean _true = Boolean._internal(true);
  static final Boolean _false = Boolean._internal(false);

  factory Boolean(bool value) => value ? _true : _false;

  Boolean._internal(this.value) : super(EntityType.BOOLEAN);
  bool value;

  @override
  String toString() {
    return value.toString();
  }

  @override
  bool operator ==(Object other) {
    return other is Boolean && other.value == value;
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
