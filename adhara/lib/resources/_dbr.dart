import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:adhara/resources/r.dart';

import 'package:sqflite/sqflite.dart' show openDatabase, Database;


class DBResources{

  Database db;
  List<String> migratedTableNames = [];
  Resources r;

  DBResources(this.r);

  Future initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, r.module.dbName);
    return await openDatabase(path, version: r.module.dbVersion);
  }

  Future load() async {
    db = await initDatabase();
    await r.dataInterface.load(db);
  }

  addToMigratedTables(String tableName){
    if(migratedTableNames.indexOf(tableName)==-1){
      migratedTableNames.add(tableName);
    }
  }

  ///This method will return false always when opening the app, once the migration code is run, then it returns false
  ///TODO Enhance this area?
  isMigratedAlready(String tableName){
    return migratedTableNames.indexOf(tableName)!=-1;
  }

}