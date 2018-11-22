import 'dart:async';

import 'package:adhara/config.dart';
import 'package:adhara/datainterface/bean.dart';
import 'package:adhara/constants.dart';
import 'package:adhara/datainterface/data/data_provider.dart';
import 'package:adhara/datainterface/data/offline_provider.dart';
import 'package:adhara/datainterface/data/network_provider.dart';
import 'package:adhara/datainterface/storage/bean_storage_provider.dart';
import 'package:adhara/datainterface/storage/key_value_storage_provider.dart';
import 'package:adhara/datainterface/storage/storage_provider.dart';
import 'package:adhara/resources/r.dart';
import 'package:sqflite/sqflite.dart' show Database;

class DataInterface {
  Config config;
  OfflineProvider offlineProvider;
  NetworkProvider networkProvider;
  Resources r;
  List<StorageProvider> get dataStores => [];
  KeyValueStorageProvider keyValueStorageProvider;

  DataInterface(this.config) {
    if (isOffline) {
      offlineProvider = config.offlineProvider;
    } else {
      networkProvider = config.networkProvider;
    }
  }

  get isOffline =>
    config.dataProviderState == ConfigValues.DATA_PROVIDER_STATE_OFFLINE
      && config.offlineProvider != null;

  DataProvider get dataProvider => isOffline?offlineProvider:networkProvider;

  Future load(Database db) async {
    await dataProvider.load();
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
      whereArgs ??= [];
      List<String> whereKeys = [];
      filter.forEach((k, v) {
        whereKeys.add("$k == ?");
        whereArgs.add(v);
      });
      if (whereKeys.length > 0) {
        if (where == null) {
          where = " " + whereKeys.join(" and ");
        } else {
          where += " and " + whereKeys.join(" and ");
        }
      }
    }
    if (exclude != null) {
      whereArgs ??= [];
      List<String> excludeKeys = [];
      exclude.forEach((k, v) {
        excludeKeys.add("$k != ?");
        whereArgs.add(v);
      });
      if (excludeKeys.length > 0) {
        if (where == null) {
          where = " " + excludeKeys.join(" and ");
        } else {
          where += " and " + excludeKeys.join(" and ");
        }
      }
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
