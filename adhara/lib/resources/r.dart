import 'dart:async';

import 'package:adhara/configurator.dart';
import 'package:adhara/datainterface/data_interface.dart';
import 'package:adhara/module.dart';
import 'package:adhara/resources/_dbr.dart';
import 'package:adhara/resources/_r.dart';
import 'package:adhara/resources/app_state.dart';
import 'package:adhara/resources/ar.dart';
import 'package:adhara/resources/event_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'u.dart';


class Resources extends BaseResources {
  AppResources appResources;
  AdharaModule module;
  DataInterface dataInterface;
  EventHandler eventHandler;
  bool loaded = false;
  DBResources dbResources;
  AdharaModuleUtils utils;

  Resources(this.module, this.appResources) {
    dataInterface = module.dataInterface;
    dataInterface.r = this;
    appState = AppState();
    eventHandler = EventHandler();
    utils = this.module.utils;
  }

  Configurator get config => module;

  SharedPreferences get preferences => this.appResources.preferences;

  Future load(/*String language*/) async {
    if (!loaded) {
      //Loading language
      //await loadLanguage(language);
      //Loading database
      dbResources = DBResources(this);
      dbResources.load();
      //Load utils
      this.utils.initialize(this);
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

  String getString(key, {String defaultValue, bool suppressErrors: false}) {
    return appResources.getString(key, defaultValue: defaultValue, suppressErrors: suppressErrors);
  }

  String s(key, {String defaultValue, bool suppressErrors: false}) {
    return appResources.s(key, defaultValue: defaultValue, suppressErrors: suppressErrors);
  }

}
