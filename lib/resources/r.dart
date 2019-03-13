import 'dart:async';
import 'dart:io';

import 'package:adhara/configurator.dart';
import 'package:adhara/datainterface/data_interface.dart';
import 'package:adhara/module.dart';
import 'package:adhara/resources/_r.dart';
import 'package:adhara/resources/app_state.dart';
import 'package:adhara/resources/ar.dart';
import 'package:adhara/resources/event_handler.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' show openDatabase, Database;

class Resources extends BaseResources {

  AppResources appResources;
  AdharaModule module;
  DataInterface dataInterface;
  AppState appState;
  EventHandler eventHandler;
  bool loaded = false;
  SharedPreferences preferences;

  Resources(this.module, this.appResources) {
    dataInterface = module.dataInterface;
    dataInterface.r = this;
    appState = AppState();
    eventHandler = EventHandler();
  }

  Configurator get config => module;

  Future initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, module.dbName);
    return await openDatabase(path, version: module.dbVersion);
  }

  Future load(String language) async {
    if (!loaded) {
      //Loading language
      await loadLanguage(language);
      //Loading database
      Database db = await initDatabase();
      await dataInterface.load(db);
      //Loading shared preferences
      preferences = await SharedPreferences.getInstance();
      loaded = true;
      return this;
    }
  }

  clearResources({removeAppState: true, clearDataInterface: true}) async {
    if (removeAppState) {
      //Setting new app state...
      appState = AppState();
    }
    if (clearDataInterface) {
      //Clearing database data stores...
      await dataInterface.clearDataStores();
    }
  }
}
