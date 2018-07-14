import 'dart:async';

import 'package:adhara/config.dart';
import 'package:adhara/datainterface/bean.dart';
import 'package:adhara/datainterface/storage/storage_provider.dart';
import 'package:sqflite/sqflite.dart';


abstract class BeanStorageProvider extends StorageProvider{

  BeanStorageProvider([Config config]) : super(config);

  getOperatorClassFromMap(Map map){
    return StorageOperator.fromMap(map);
  }

  Future<Bean> save(Bean bean) async {
    Database db = await this.db;
    try {
      int pk = await db.insert(this.tableName, bean.toSerializableMap());
      print("post insesrt");
      print("PK $pk");
      bean.setLocalId(pk);
      return bean;
    }catch(e){
      await this.close();
      throw new Exception(e);
    }
  }

  Future<List<Bean>> saveAll(List<Bean> beans) async {
    Database db = await this.db;
    try {
      Batch batch = db.batch();
      beans.forEach((Bean bean){
        batch.insert(this.tableName, bean.toSerializableMap());
      });
      List<dynamic> results = await batch.commit();
      for(int i=0; i<results.length; i++){
        beans[i].setLocalId(results[i]);
      }
      return beans;
    }catch(e){
      await this.close();
      throw new Exception(e);
    }
  }

  Future<int> edit(Bean bean) async {
    Database db = await this.db;
    int id;
    try {
      Map<String, dynamic> sdMap = bean.toSerializableMap();
      id = await db.update(this.tableName, sdMap,
        where: "_id=?", whereArgs: [bean.identifier]);
    }catch(e){
      await this.close();
      throw new Exception(e);
    }
    return id;
  }

  Future deleteOne(Bean bean) async {
    Database db = await this.db;
    try {
      return await db.delete(
        this.tableName, where: "_id=?", whereArgs: [bean.identifier]);
    }catch(e){
      await this.close();
      throw new Exception(e);
    }
  }

  Future close() async => (await this.db).close();

}