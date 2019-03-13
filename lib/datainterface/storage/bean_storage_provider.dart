import 'dart:async';

import 'package:adhara/configurator.dart';
import 'package:adhara/datainterface/bean.dart';
import 'package:adhara/datainterface/storage/storage_classes.dart';
import 'package:adhara/datainterface/storage/storage_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class BeanStorageProvider extends StorageProvider {
  BeanStorageProvider([Configurator config]) : super(config);

  List<StorageClass> get defaultFields {
    List<StorageClass> _df = super.defaultFields;
    _df.addAll([
      NumericColumn(Bean.CREATED_TIME, nullable: true),
      NumericColumn(Bean.LAST_UPDATED_TIME, nullable: true)
    ]);
    return _df;
  }

  Future<Bean> insertBean(Bean bean) async {
    if (bean.createdTime == null) {
      bean.setCreatedTime();
    }
    int pk = await this.rawInsert(bean.toSerializableMap());
    bean.setLocalId(pk);
    return bean;
  }

  Future<List<Bean>> insertBeans(List<Bean> beans) async {
    List<Map<String, dynamic>> entries = [];
    beans.forEach((Bean bean) {
      if (bean.createdTime == null) {
        bean.setCreatedTime();
      }
      entries.add(bean.toSerializableMap());
    });
    List<dynamic> results = await rawBulkInsert(entries);
    for (int i = 0; i < results.length; i++) {
      beans[i].setLocalId(results[i]);
    }
    return beans;
  }

  Future<int> updateBean(Bean bean) async {
    bean.setUpdatedTime();
    Map<String, dynamic> sdMap = bean.toSerializableMap();
    return await this.update(sdMap, "$idFieldName=?", [bean.identifier]);
  }

  Future<List<int>> updateBeans(List<Bean> beans) async {
    //TODO try to fit this method in storage_provider
    Batch batch = db.batch();
    beans.forEach((Bean bean) {
      bean.setUpdatedTime();
      Map<String, dynamic> sdMap = bean.toSerializableMap();
      batch.update(this.tableName, serialize(sdMap),
          where: "$idFieldName=?", whereArgs: [bean.identifier]);
      batch.update(this.tableName, bean.toSerializableMap());
    });
    List<dynamic> results = await batch.commit();
    for (int i = 0; i < results.length; i++) {
      beans[i].setLocalId(results[i]);
    }
    return results;
  }

  Future deleteBean(Bean bean) async {
    return await db.delete(this.tableName,
        where: "$idFieldName=?", whereArgs: [bean.identifier]);
  }
}
