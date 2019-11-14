import 'dart:async';

import 'package:adhara/configurator.dart';
import 'package:adhara/datainterface/data_interface.dart';
import 'package:adhara/module.dart';
import 'package:adhara/resources/_r.dart';
import 'package:adhara/resources/_dbr.dart';
import 'package:adhara/resources/app_state.dart';
import 'package:adhara/resources/ar.dart';
import 'package:adhara/resources/event_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Resources extends BaseResources {

  AppResources appResources;
  AdharaModule module;
  DataInterface dataInterface;
  AppState appState;
  EventHandler eventHandler;
  bool loaded = false;
  SharedPreferences preferences;
  DBResources dbResources;

  Resources(this.module, this.appResources) {
    dataInterface = module.dataInterface;
    dataInterface.r = this;
    appState = AppState();
    eventHandler = EventHandler();
  }

  Configurator get config => module;

  Future load(String language) async {
    if (!loaded) {
      //Loading language
      await loadLanguage(language);
      //Loading database
      dbResources = DBResources(this);
      dbResources.load();

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
