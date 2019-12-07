import 'dart:async';
import 'dart:io';

import 'package:adhara/configurator.dart';
import 'package:adhara/exceptions.dart';
import 'package:adhara/utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhara/resources/app_state.dart';
import 'package:sqflite/sqflite.dart' show openDatabase/*, Database*/;

abstract class BaseResources {
  String _language;
  Map<String, Map<String, String>> _stringResources = {};
  SharedPreferences preferences;
  AppState appState;

  Configurator get config;

  String get language => _language;

  Future loadOne(language) async {
    String resourceBundle = config.i18nResourceBundle;
    _stringResources[language] = await ConfigFileLoader.load(
        '$resourceBundle/resources${(language == '') ? '' : '_'}$language.properties');
//    String resourceFilePath = config.languageResources[language];
//    if (resourceFilePath == null) {
//      throw ResourceNotFound("Invalid language requested $language");
//    }
  }

  Future loadLanguage(language) async {
    _language = language;
    await this.loadOne(config.defaultLanguage); //Load default language
    if (language != config.defaultLanguage) {
      await this
          .loadOne(language); //Load selected language if it is not default
    }
  }

  Future initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, config.dbName);
    return await openDatabase(path, version: config.dbVersion);
  }

  String getString(key, {String defaultValue, bool suppressErrors: false}) {
    if (language == null)
      throw new AdharaResourceNotFound(
          "languageResources not configured for this module or app");
    String res = _stringResources[language][key];
    if (res == null) {
      res = _stringResources[config.defaultLanguage][key];
    }
    if (res == null) {
      suppressErrors = suppressErrors || defaultValue != null;
      if (!suppressErrors && isDebugMode() && config.strictMode) {
        throw new AdharaResourceNotFound("Resource not found: $key");
      }
      return key;
    }
    return res;
  }

  /// Convenience signature for [getString]
  String s(key, {String defaultValue, bool suppressErrors: false}) {
    return this.getString(key,
        defaultValue: defaultValue, suppressErrors: suppressErrors);
  }
}
