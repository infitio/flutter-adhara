import "dart:convert" show json;

abstract class Bean {
  static const String _ID = "_id";
  static const String CREATED_TIME = "_created_time";
  static const String LAST_UPDATED_TIME = "_updated_time";

  dynamic data;

  Bean([mapData]) {
    data = mapData ?? {};
  }

  Bean.fromJson(jsonObject) {
    data = json.decode(jsonObject);
  }

  Bean.fromSerializedMap(Map<String, dynamic> serializedMap) {
    data = serializedMap;
  }

  Bean.fromNetworkSerializedMap(Map<String, dynamic> serializedMap) {
    data = serializedMap;
  }

  setLocalId(int id) => data[_ID] = id;

  int get identifier => data[_ID];

  int get createdTime => data[CREATED_TIME];

  int get lastUpdatedTime => data[LAST_UPDATED_TIME];

  setCreatedTime() {
    int millis = DateTime.now().millisecondsSinceEpoch;
    data[CREATED_TIME] = millis;
    data[LAST_UPDATED_TIME] = millis;
  }

  setUpdatedTime() {
    data[LAST_UPDATED_TIME] = DateTime.now().millisecondsSinceEpoch;
  }

  toJson() {
    return json.encode(data);
  }

  toMap() => data;

  Map<String, dynamic> toSerializableMap() => Map<String, dynamic>.from(data);

  Map<String, dynamic> toNetworkSerializableMap() =>
      Map<String, dynamic>.from(data);
}
