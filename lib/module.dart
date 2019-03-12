import 'package:adhara/constants.dart';
import 'package:adhara/datainterface/data/network_provider.dart';
import 'package:adhara/datainterface/data/offline_provider.dart';
import 'package:adhara/datainterface/data_interface.dart';
import 'package:adhara/utils.dart';
import 'package:flutter/material.dart' show Widget;
import 'package:adhara/resources/url.dart';

abstract class AdharaModule {

  String get name;

  Map<String, dynamic> _config = {};

  ///Get data config loaded from config file
  Map<String, dynamic> get fromFile => _config;

  ///Container class for the app
  Widget get container;

  ///Base network URL. For example: https://myexample.com/fluttter_api_base/
  String baseURL;

  ///Config file to load the JSON configuration from
  String configFile;

  ///SQLite Database name
  String dbName = "adhara-app.db";

  ///SQLite Database version
  int dbVersion = 1;

  ///Data provider state offline/online. Must be one of
  /// [ConfigValues.DATA_PROVIDER_STATE_OFFLINE] and
  /// [ConfigValues.DATA_PROVIDER_STATE_ONLINE]
  String dataProviderState = ConfigValues.DATA_PROVIDER_STATE_ONLINE;

  ///Offline provider class for the application
  OfflineProvider get offlineProvider => OfflineProvider(this);

  ///Network provider class for the application
  NetworkProvider get networkProvider => NetworkProvider(this);

  ///DataInterface class for the application
  DataInterface get dataInterface => DataInterface(this);

  ///Return a map of language vs language properties file
  ///Ex: {
  ///   'en': 'assets/languages/en.properties',
  ///   'pt': 'assets/languages/pt.properties'
  /// }
  Map<String, String> get languageResources => {};

  ///Load application configuration
  load() async {
    assert(baseURL != null || configFile != null);
    if (configFile == null) return;
    _config = await AssetFileLoader.load(configFile);
    baseURL = fromFile[ConfigKeys.BASE_URL];
    dbName = fromFile[ConfigKeys.DB_NAME] ?? dbName;
    dbVersion = fromFile[ConfigKeys.DB_VERSION] ?? dbVersion;
    dataProviderState =
        fromFile[ConfigKeys.DATA_PROVIDER_STATE] ?? dataProviderState;

  }

  ///Enables strict checking of configurations etc in few cases and
  /// throws errors accordingly in development mode
  /// Example: when in strict mode, errors will be thrown
  /// if a resource key is not present for string resources.
  bool get strictMode => false;

  List<URL> get urls;

}
