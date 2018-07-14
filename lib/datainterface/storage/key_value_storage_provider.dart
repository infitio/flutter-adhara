import 'dart:async';
import 'dart:convert' show json;

import 'package:adhara/config.dart';
import 'package:adhara/datainterface/storage/storage_provider.dart';


class KeyValueStorageProvider extends StorageProvider{

  KeyValueStorageProvider(Config config) : super(config);

  static String get keyColumn{
    return "key";
  }

  static String get valueColumn{
    return "value";
  }

  get tableName{
    return "KeyValue_STORAGE";
  }

  List<Map> get schema{
    return [
      {
        "name": keyColumn,
        "type": "string",
        "constraints": "UNIQUE NOT NULL"
      },
      {
        "name": valueColumn,
        "type": "blob"
      }
    ];
  }

  getOperatorClassFromMap(Map map){
    return _KeyValueStorageOperator.fromMap(map);
  }

  Future<StorageOperator> setData(String key, dynamic response) async {
    try{
      await super.delete("$keyColumn=?", [key]);
    }catch(e){ /*DO NOTHING*/ }
    return super.insert(_KeyValueStorageOperator.fromResponse(key, response));
  }

  Future<dynamic> getData(String key) async {
    _KeyValueStorageOperator data = await super.get(where: "$keyColumn = '$key'");
    if( data!=null ){
      return data.response;
    }
    return null;
  }

}

class _KeyValueStorageOperator extends StorageOperator{

  dynamic get response{
    return json.decode(this.data[KeyValueStorageProvider.valueColumn]);
  }

  _KeyValueStorageOperator.fromResponse(String key, dynamic value):
      super.fromMap({
      KeyValueStorageProvider.keyColumn: key,
      KeyValueStorageProvider.valueColumn: json.encode(value)
    });

  _KeyValueStorageOperator.fromMap(Map map): super.fromMap(map);

}