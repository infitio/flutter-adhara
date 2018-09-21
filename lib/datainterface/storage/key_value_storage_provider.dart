import 'dart:async';
import 'package:adhara/config.dart';
import 'package:adhara/datainterface/storage/storage_provider.dart';
import 'package:adhara/datainterface/storage/storage_classes.dart';

class KeyValueStorageProvider extends StorageProvider {
  KeyValueStorageProvider(Config config) : super(config);

  static String get keyColumn => "key";
  static String get valueColumn => "value";

  get tableName => "KeyValue_STORAGE";

  List<StorageClass> get fields {
    return [
      TextColumn(keyColumn, unique: true, nullable: false),
      ProbableJSONColumn(valueColumn, unique: true, nullable: false)
    ];
  }

  Future<Map<String, dynamic>> setData(String key, dynamic response) async {
    try {
      await remove(key);
    } catch (e) {/*DO NOTHING*/}
    return super.insert({
      keyColumn: key,
      valueColumn: response
    });
  }

  Future<dynamic> getData(String key) async {
    Map<String, dynamic> data =
        await super.get(where: "$keyColumn = '$key'");
    if (data != null) {
      return data[valueColumn];
    }
    return null;
  }

  Future<dynamic> remove(String key) async {
    return await super.delete(where: "$keyColumn=?", whereArgs: [key]);
  }
}