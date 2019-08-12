import 'package:adhara/datainterface/storage/storage_classes.dart';
import 'package:adhara/datainterface/models/migrator.dart';
import 'package:adhara/resources/r.dart';
import 'package:sqflite/sqflite.dart';


class ModelMeta{

}

class ModelManager{

  Future<int> save(Database db, Model model) async {
    Map<String, dynamic> rawData;
    for(StorageClass field in model.fields){
      rawData[field.name] = model.getFieldValue(field.name);
    }
    return await db.insert(model.tableName, rawData);
  }

}

abstract class BaseModel{

  Map<String, dynamic> mapData;
  String get tableName;
  List<StorageClass> get fields;
  ModelMeta meta;
  MigrationManager _migrationManager = MigrationManager();

}

abstract class Model extends BaseModel{

  Resources r;
  Model(this.r);

  Future migrate() async {
    if(!r.dbResources.isMigratedAlready(tableName)){
      await this._migrationManager.createTable(r.dbResources.db, this);
      r.dbResources.addToMigratedTables(this.tableName);
    }
  }

  getFieldValue(fieldName){
    //TODO implement this!
  }

  Model.fromMap(Map<String, dynamic> map){
    this.mapData = map;
  }

}
