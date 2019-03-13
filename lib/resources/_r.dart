import 'dart:async';
import 'dart:io';

import 'package:adhara/configurator.dart';
import 'package:adhara/utils.dart';
import 'package:adhara/exceptions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' show openDatabase, Database;


abstract class BaseResources {

  String _language;
  Map<String, Map<String, String>> _stringResources = {};
  SharedPreferences preferences;

  Configurator get config;

  Future loadOne(language) async {
    String resourceFilePath = config.languageResources[language];
    if (resourceFilePath == null) {
      throw ResourceNotFound("Invalid language requested $language");
    }
    _stringResources[language] = await ConfigFileLoader.load(resourceFilePath);
  }

  Future loadLanguage(language) async {
    if(config.languageResources.length > 0){
      _language = language;
      await this.loadOne(config.defaultLanguage); //Load default language
      if (language != config.defaultLanguage) {
        await this.loadOne(language); //Load selected language if it is not default
      }
    }
  }

  Future initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, config.dbName);
    return await openDatabase(path, version: config.dbVersion);
  }

  getString(key, {String defaultValue, bool suppressErrors: false}) {
    if(language==null) throw new ResourceNotFound("languageResources not configured for this module or app");
    var res = _stringResources[language][key];
    if (res == null) {
      res = _stringResources["en"][key];
    }
    if (res == null) {
      suppressErrors = suppressErrors || defaultValue != null;
      if (!suppressErrors && isDebugMode() && config.strictMode) {
        throw new ResourceNotFound("Resource not found: $key");
      }
      return key;
    }
    return res;
  }

  String get language {
    return _language;
  }

}
