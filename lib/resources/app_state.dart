class Scope {
  Map<dynamic, dynamic> _ = {};

  setValue(dynamic key, dynamic value) {
    _[key] = value;
  }

  getValue(dynamic key, [dynamic defaultValue]) {
    return _[key] ?? defaultValue;
  }

  remove(dynamic key) {
    return _.remove(key);
  }

  containsKey(dynamic key) {
    return _.containsKey(key);
  }

  containsValue(dynamic value) {
    return _.containsValue(value);
  }
}

class AppState {
  Map<String, Scope> _ = {};

  createScope(String scopeName) {
    _[scopeName] = Scope();
    return _[scopeName];
  }

  Scope getScope(String scopeName) {
    return _[scopeName] ?? createScope(scopeName);
  }
}
