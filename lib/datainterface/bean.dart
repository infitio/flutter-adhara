import "dart:convert" show json;


abstract class Bean{

  int _id;
  dynamic data;

  Bean([mapData]){
      data = mapData ?? {};
  }

  Bean.fromJson(jsonObject){
    data = json.decode(jsonObject);
  }

  setLocalId(id) => data["_id"]= id;

  get identifier => data["_id"];

  toJson(){
    return json.encode(data);
  }

  toMap() => data;

  Map<String, dynamic> toSerializableMap() => Map<String, dynamic>.from(data);

}