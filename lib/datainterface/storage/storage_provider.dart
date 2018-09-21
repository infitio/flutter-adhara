import 'dart:convert' show json;
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/src/exception.dart'
  show SqfliteDatabaseException; //TODO handle...
import 'package:adhara/config.dart';
import 'package:adhara/datainterface/storage/storage_classes.dart';

abstract class StorageProvider {
  Database _db;
  Config config;

  StorageProvider(this.config);

  @deprecated
  ///user get fields instead
  List<Map> get schema => null;

  @deprecated
  ///user get fields instead
  String get constraints => "";

  final String idFieldName = "_id";

  List<StorageClass> get fields => null;
  List<StorageClass> get defaultFields => [
    IntegerColumn(idFieldName, primaryKey: true, autoIncrement: true)  //ID field
  ];
  List<StorageClass> get allFields{
    if(fields==null) return null;
    List<StorageClass> _f = List<StorageClass>.from(defaultFields);
    _f.addAll(fields);
    return _f;
  }

  String get tableName;

  ///Schematic of a Field schema...
  ///
  ///{
  ///   "name": <String>,
  ///   "type": <String>,
  ///   "autoincrement": <bool>,
  ///   "constraints": <UNIQUE|NOT NULL|CHECK|FOREIGN KEY>
  /// }
  _convertSchemaFieldToSQL(field) {
    String name = field["name"] + " ";
    String type = field["type"] ?? "";
    String constraints = field["constraints"] ?? "";
    var ai = field["autoincrement"];
    String autoincrement = "autoincrement";
    if (ai == null || ai == false) {
      autoincrement = "";
    }
    /*String nonNull = "";
    if(constraints == "primary key") {
      nonNull = "not null";
    }else{
      nonNull = (!field["null"])?"not null":"";
    }*/
    return """$name $type $constraints $autoincrement""".trim();
  }

  @deprecated
  String get fieldsStringSchema {
    String schema =
    this.schema.map(this._convertSchemaFieldToSQL).toList().join(", ");
    schema += ", _id integer primary key autoincrement";
    return schema;
  }

  @deprecated
  String get stringSchema {
    if (this.constraints != "") {
      return fieldsStringSchema + ", " + this.constraints;
    }
    return fieldsStringSchema;
  }

  String get _cq{   //create columns query
    if(allFields == null){
      return stringSchema;
    }
    return allFields.map((_f) => _f.q).join(", ");
  }

  Future initialize([Database _database]) async {
    if (db == null) {
      _db = _database;
    }
    await _createTable();
  }

  Future _createTable() async {
    try {
      await db
        .execute("create table ${this.tableName} ($_cq);");
    } on SqfliteDatabaseException catch (e) {
      if (e.getResultCode() != 1) {
        if (e.toString().indexOf("already exists") == -1) {
          throw e;
        }
      }
    }
  }

  Database get db {
    return _db;
  }

  Future<int> rawInsert(Map<String, dynamic> entry) async {
    return await db.insert(this.tableName, serialize(entry));
  }

  Future<List<dynamic>> rawBulkInsert(List<Map<String, dynamic>> entries) async {
    Batch batch = db.batch();
    entries.forEach((Map<String, dynamic> entry) {
      batch.insert(this.tableName, serialize(entry));
    });
    return await batch.commit();
  }

  Future<Map<String, dynamic>> insert(Map<String, dynamic> entry) async {
    entry[idFieldName] = await rawInsert(entry);
    return entry;
  }

  Future<List<Map<String, dynamic>>> insertAll(
    List<Map<String, dynamic>> entries) async {
    List<int> results = await rawBulkInsert(entries);
    for (int i = 0; i < results.length; i++) {
      entries[i][idFieldName] = results[i];
    }
    return entries;
  }

  @deprecated
  List<String> get selectColumns {
    List<String> columns = [];
    this.schema.forEach((Map field) {
      columns.add(field["name"].toString());
    });
    columns.add("_id");
    return columns;
  }

  List<String> get _colNames{
    if(this.allFields==null){
      return selectColumns;
    }
    return allFields.map((_f)=>_f.name).toList();
  }

  applySerialize(StorageClass field, dynamic value){
    try{
      return field.serialize(value);
    }catch(e){
      print("Unable to serialize field `$tableName.${field.name}` for value `$value`");
      print(e);
      rethrow;
    }
  }

  applyDeserialize(StorageClass field, dynamic value){
    try{
      return field.deserialize(value);
    }catch(e){
      print("Unable to serialize field `$tableName.${field.name}` for value `$value`");
      print(e);
      rethrow;
    }
  }

  Map<String, dynamic> deserialize(entry){
    Map<String, dynamic> deserializedData = new Map<String, dynamic>();
    if(allFields==null) return entry; //TODO remove after new release
    allFields.forEach((f){
      deserializedData[f.name] = applyDeserialize(f, entry[f.name]);
    });
    return deserializedData;
  }

  Map<String, dynamic> serialize(Map<String, dynamic> entry){
    Map<String, dynamic> serializedData = new Map<String, dynamic>();
    if(allFields==null) return entry; //TODO remove after new release
    allFields.forEach((f){
      if(entry.containsKey(f.name)){
        serializedData[f.name] = applySerialize(f, entry[f.name]);
      }
    });
    return serializedData;
  }

  Future<List<Map<String, dynamic>>> getRawList(
    {bool distinct,
      String where,
      List whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit,
      int offset}) async {
    // Querying the database
    List<Map<String, dynamic>> maps = await db.query(
      this.tableName,
      distinct: distinct,
      columns: _colNames,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
    return maps.map(deserialize).toList();
  }

  Future<List<Map<String, dynamic>>> getList(
    {bool distinct,
      String where,
      List whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit,
      int offset}) async {
    List<Map<String, dynamic>> maps = await getRawList(
      distinct: distinct,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
    if (maps != null && maps.length > 0) {
      List<Map<String, dynamic>> soList = [];
      maps.forEach((map) => soList.add(map));
      return soList;
    }
    return null;
  }

  Future<Map<String, dynamic>> getRaw({String where, List<dynamic> whereArgs}) async {
    List<Map<String, dynamic>> maps =
    await this.getRawList(where: where, whereArgs: whereArgs);
    if (maps != null && maps.length > 0) {
      return maps.first;
    }
    return null;
  }

  Future<Map<String, dynamic>> get({String where, List<dynamic> whereArgs}) async {
    Map<String, dynamic> map = await getRaw(where: where, whereArgs: whereArgs);
    return map;
  }

  Future<Map<String, dynamic>> getByIdRaw(int id) async {
    List<Map<String, dynamic>> maps = await getRawList(where: "$idFieldName=${id.toString()}");
    if (maps != null && maps.length > 0) {
      return maps.first;
    }
    return null;
  }

  Future<Map<String, dynamic>> getById(int id) async {
    Map<String, dynamic> map = await getByIdRaw(id);
    return map;
  }

  Future<int> delete({String where, List whereArgs}) async {
    return await db.delete(this.tableName,
      where: where, whereArgs: whereArgs);
  }

  Future<int> update(
    Map entry, String where, List whereArgs) async {
    return await db.update(this.tableName, serialize(entry),
      where: where, whereArgs: whereArgs);
  }

  Future<int> count() async {
    return Sqflite.firstIntValue(
      await db.rawQuery("SELECT COUNT(*) FROM ${this.tableName}"));
  }
}