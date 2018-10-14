import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart' show openDatabase, Database;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:adhara/datainterface/data_interface.dart';
import 'package:adhara/config.dart';
import 'package:adhara/resources/app_state.dart';
import 'package:adhara/resources/event_handler.dart';
import 'package:adhara/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResourceNotFound implements Exception {
  String cause;
  ResourceNotFound(this.cause);
}

class Resources {
  Config config;
  DataInterface dataInterface;
  String _language;
  Map<String, Map<String, String>> _stringResources = {};
  AppState appState;
  EventHandler eventHandler;
  bool loaded = false;
  SharedPreferences preferences;

  Resources(this.config) {
    dataInterface = this.config.dataInterface;
    dataInterface.r = this;
    appState = AppState();
    eventHandler = EventHandler();
  }

  Future loadOne(language) async {
    String resourceFilePath = this.config.languageResources[language];
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
    String path = join(documentsDirectory.path, config.dbName);
    return await openDatabase(path, version: config.dbVersion);
  }

  Future load(language) async {
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

  getString(key) {
    var res = _stringResources[_language][key];
    if (res == null) {
      res = _stringResources["en"][key];
    }
    if (res == null) {
      print("Resource not found: $key");
      return key;
//      throw new ResourceNotFound("Resource not found: $key");
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
