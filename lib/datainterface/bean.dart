import "dart:convert" show json;


abstract class Bean{

  static const String ID = "_id";
  static const String CREATED_TIME = "_created_time";
  static const String LAST_UPDATED_TIME = "_updated_time";

  int _id;
  dynamic data;

  Bean([mapData]){
      data = mapData ?? {};
  }

  Bean.fromJson(jsonObject){
    data = json.decode(jsonObject);
  }

  setLocalId(id) => data[ID]= id;

  get identifier => data[ID];

  int get createdTime => data[CREATED_TIME];

  int get lastUpdatedTime => data[LAST_UPDATED_TIME];

  setCreatedTime(){
    int millis = DateTime.now().millisecondsSinceEpoch;
    data[CREATED_TIME] = millis;
    data[LAST_UPDATED_TIME] = millis;
  }

  setUpdatedTime(){
    data[LAST_UPDATED_TIME] = DateTime.now().millisecondsSinceEpoch;
  }

  toJson(){
    return json.encode(data);
  }

  toMap() => data;

  Map<String, dynamic> toSerializableMap() =>
    Map<String, dynamic>.from(data);

  Map<String, dynamic> toNetworkSerializableMap() =>
    Map<String, dynamic>.from(data);

}