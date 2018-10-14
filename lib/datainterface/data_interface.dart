import 'dart:async';

import 'package:adhara/config.dart';
import 'package:adhara/datainterface/bean.dart';
import 'package:adhara/datainterface/network/network_provider.dart';
import 'package:adhara/datainterface/storage/bean_storage_provider.dart';
import 'package:adhara/datainterface/storage/key_value_storage_provider.dart';
import 'package:adhara/datainterface/storage/storage_provider.dart';
import 'package:adhara/resources/r.dart';
import 'package:sqflite/sqflite.dart' show Database;

class DataInterface {
  Config config;
  NetworkProvider networkProvider;

  KeyValueStorageProvider keyValueStorageProvider;

  DataInterface(this.config) {
    networkProvider = config.networkProvider;
  }

  Resources r;

  List<StorageProvider> get dataStores => [];

  Future load(Database db) async {
    await networkProvider.load();
    await createDataStores(db);
  }

  Future createDataStores(Database db) async {
    keyValueStorageProvider = KeyValueStorageProvider(config);
    await keyValueStorageProvider.initialize(db);
    for (int i = 0; i < dataStores.length; i++) {
      await dataStores[i].initialize(db);
    }
  }

  Future clearDataStores() async {
    await keyValueStorageProvider.delete();
    for (int i = 0; i < dataStores.length; i++) {
      await dataStores[i].delete();
    }
  }

  bool get canStore => true;

  Future<Map> queryOne(BeanStorageProvider storageProvider, int id) async {
    return storageProvider.getByIdRaw(id);
  }

  Future<List<Map>> query(BeanStorageProvider storageProvider,
      {Map<String, dynamic> filter,
      Map<String, dynamic> exclude,
      bool distinct,
      String where,
      List whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit,
      int offset}) async {
    if (filter != null) {
      where ??= "";
      whereArgs ??= [];
      List<String> whereKeys = [];
      filter.forEach((k, v) {
        whereKeys.add("$k == ?");
        whereArgs.add(v);
      });
      where += " " + whereKeys.join(" and ");
    }
    if (exclude != null) {
      where ??= "";
      whereArgs ??= [];
      List<String> excludeKeys = [];
      exclude.forEach((k, v) {
        excludeKeys.add("$k != ?");
        whereArgs.add(v);
      });
      where += " and " + excludeKeys.join(" and ");
    }
    return storageProvider.getRawList(
      distinct: distinct,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<Bean> save(BeanStorageProvider storageProvider, Bean bean) async {
    return storageProvider.insertBean(bean);
  }

  Future<List<Bean>> saveAll(
      BeanStorageProvider storageProvider, List<Bean> beans) async {
    return storageProvider.insertBeans(beans);
  }

  Future<int> update(BeanStorageProvider storageProvider, Bean bean) async {
    return storageProvider.updateBean(bean);
  }

  Future delete(BeanStorageProvider storageProvider, Bean bean) async {
    storageProvider.deleteBean(bean);
  }
}
