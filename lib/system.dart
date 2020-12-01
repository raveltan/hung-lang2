class System {
  System _parent;
  final Map<String, dynamic> _data = {};

  dynamic getVariable(String key) => _data.containsKey(key)
      ? _data[key]
      : _parent != null
          ? _parent.getVariable(key)
          : null;
  System();
  void setVariable(String key, dynamic value) =>
      _parent != null && _parent.getVariable(key) != null ? _parent._data[key] = value : _data[key] = value;

  System.closedSystem(System parentSystem) : _parent = parentSystem;
}
