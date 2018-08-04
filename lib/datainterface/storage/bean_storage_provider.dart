import 'dart:async';

import 'package:adhara/config.dart';
import 'package:adhara/datainterface/bean.dart';
import 'package:adhara/datainterface/storage/storage_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class BeanStorageProvider extends StorageProvider {
  BeanStorageProvider([Config config]) : super(config);

  String get fieldsStringSchema {
    String schema = super.fieldsStringSchema;
    schema += ", ${Bean.CREATED_TIME} integer non null";
    schema += ", ${Bean.LAST_UPDATED_TIME} integer non null";
    return schema;
  }

  List<String> get selectColumns {
    List<String> columns = super.selectColumns;
    columns.add(Bean.CREATED_TIME);
    columns.add(Bean.LAST_UPDATED_TIME);
    return columns;
  }

  Future<Bean> insertBean(Bean bean) async {
    if (bean.createdTime == null) {
      bean.setCreatedTime();
    }
    try {
      int pk = await db.insert(this.tableName, bean.toSerializableMap());
      print("post insesrt");
      print("PK $pk");
      bean.setLocalId(pk);
      return bean;
    } catch (e) {
      throw new Exception(e);
    }
  }

  Future<List<Bean>> insertBeans(List<Bean> beans) async {
    try {
      Batch batch = db.batch();
      beans.forEach((Bean bean) {
        if (bean.createdTime == null) {
          bean.setCreatedTime();
        }
        batch.insert(this.tableName, bean.toSerializableMap());
      });
      List<dynamic> results = await batch.commit();
      for (int i = 0; i < results.length; i++) {
        beans[i].setLocalId(results[i]);
      }
      return beans;
    } catch (e) {
      throw new Exception(e);
    }
  }

  Future<int> updateBean(Bean bean) async {
    int id;
    bean.setUpdatedTime();
    try {
      Map<String, dynamic> sdMap = bean.toSerializableMap();
      id = await db.update(this.tableName, sdMap,
          where: "_id=?", whereArgs: [bean.identifier]);
    } catch (e) {
      throw new Exception(e);
    }
    return id;
  }

  Future<List<int>> updateBeans(List<Bean> beans) async {
    try {
      Batch batch = db.batch();
      beans.forEach((Bean bean) {
        bean.setUpdatedTime();
        Map<String, dynamic> sdMap = bean.toSerializableMap();
        batch.update(this.tableName, sdMap,
            where: "_id=?", whereArgs: [bean.identifier]);
        batch.update(this.tableName, bean.toSerializableMap());
      });
      List<dynamic> results = await batch.commit();
      for (int i = 0; i < results.length; i++) {
        beans[i].setLocalId(results[i]);
      }
      return results;
    } catch (e) {
      throw new Exception(e);
    }
  }

  Future deleteBean(Bean bean) async {
    try {
      return await db
          .delete(this.tableName, where: "_id=?", whereArgs: [bean.identifier]);
    } catch (e) {
      throw new Exception(e);
    }
  }
}
