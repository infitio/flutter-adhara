import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;
import 'package:adhara/datainterface/data_interface.dart';
import 'package:adhara/config.dart';
import 'package:adhara/resources/app_state.dart';

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

  Resources(this.config) {
    dataInterface = this.config.dataInterface;
    appState = AppState();
  }

  Future loadOne(language) async {
    String resourceFilePath = this.config.languageResources[language];
    if (resourceFilePath == null) {
      throw ResourceNotFound("Invalid language requested $language");
    }
    var strings = await rootBundle.loadString(resourceFilePath);
    _stringResources[language] = {};
    strings.split("\n").forEach((i) {
      i = i.trim();
      if (i.startsWith("#") || i == "") {
        return;
      }
      _stringResources[language][i.split('=')[0].trim()] =
        i.split('=')[1].trim();
    });
  }

  Future load(language) async {
    _language = language;
    await this.loadOne("en");
    if (language != "en") {
      await this.loadOne(language);
    }
    await dataInterface.createDataStores();
    return this;
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

  clearResources({
    removeAppState: true,
    clearDataInterface: true
  }) async {
    if(removeAppState) {
      //Setting new app state...
      appState = AppState();
    }
    if(clearDataInterface) {
      //Clearing database data stores...
      await dataInterface.clearDataStores();
    }
  }

}
