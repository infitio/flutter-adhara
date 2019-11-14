import 'dart:async';
import 'dart:io';

import 'package:adhara/app.dart';
import 'package:adhara/configurator.dart';
import 'package:adhara/datainterface/data_interface.dart';
import 'package:adhara/module.dart';
import 'package:adhara/exceptions.dart';
import 'package:adhara/resources/_r.dart';
import 'package:adhara/resources/app_state.dart';
import 'package:adhara/resources/event_handler.dart';
import 'package:adhara/resources/r.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' show openDatabase, Database;

class AppResources extends BaseResources{

  AdharaApp app;
  Map<String, Resources> _moduleResources = {};
  DataInterface dataInterface;
  AppState appState;
  EventHandler eventHandler;
  bool loaded = false;
  SharedPreferences preferences;

  AppResources(this.app) {
    dataInterface = this.app.dataInterface;
    appState = AppState();
    eventHandler = EventHandler();
  }

  Configurator get config => app;

  Future initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, app.dbName);
    return await openDatabase(path, version: app.dbVersion);
  }

  Future load(String language) async {
    await loadModuleResources(language);
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

  Future loadModuleResources(String language) async {
    for(AdharaModule module in this.app.modules){
      Resources _r = Resources(module, this);
      await _r.load(language);
      _moduleResources[module.name] = _r;
    }
  }

  getModuleResource(String moduleName){
    if(_moduleResources[moduleName]==null){
      throw AdharaAppModuleNotFound("App module '$moduleName' is not listed in application modules");
    }
    return _moduleResources[moduleName];
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
