import 'dart:async';
import 'dart:io';

import 'package:adhara/app.dart';
import 'package:adhara/module.dart';
import 'package:adhara/resources/r.dart';
import 'package:adhara/datainterface/data_interface.dart';
import 'package:adhara/resources/app_state.dart';
import 'package:adhara/resources/event_handler.dart';
import 'package:adhara/utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' show openDatabase, Database;

class ResourceNotFound implements Exception {
  String cause;

  ResourceNotFound(this.cause);
}

class AppResources {
  AdharaApp app;
  Map<String, Resources> _moduleResources;
  DataInterface dataInterface;
  String _language;
  Map<String, Map<String, String>> _stringResources = {};
  AppState appState;
  EventHandler eventHandler;
  bool loaded = false;
  SharedPreferences preferences;

  AppResources(this.app) {
    dataInterface = this.app.dataInterface;
    appState = AppState();
    eventHandler = EventHandler();
  }

  Future loadOne(language) async {
    String resourceFilePath = this.app.languageResources[language];
    if (resourceFilePath == null) {
      throw ResourceNotFound("Invalid language requested $language");
    }
    _stringResources[language] = await AssetFileLoader.load(resourceFilePath);
  }

  Future loadLanguage(language) async {
    _language = language;
    await this.loadOne("en");
    if (language != "en") {
      await this.loadOne(language);
    }
  }

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
    return _moduleResources[moduleName];
  }

  getString(key, {String defaultValue, bool suppressErrors: false}) {
    var res = _stringResources[_language][key];
    if (res == null) {
      res = _stringResources["en"][key];
    }
    if (res == null) {
      suppressErrors = suppressErrors || defaultValue != null;
      if (!suppressErrors && isDebugMode() && app.strictMode) {
        throw new ResourceNotFound("Resource not found: $key");
      }
      return key;
    }
    return res;
  }

  String get language {
    return _language;
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
