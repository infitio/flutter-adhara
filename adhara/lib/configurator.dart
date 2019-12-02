import 'package:adhara/constants.dart';
import 'package:adhara/datainterface/data/network_provider.dart';
import 'package:adhara/datainterface/data/offline_provider.dart';
import 'package:adhara/datainterface/data_interface.dart';
import 'package:adhara/utils.dart';
import 'package:flutter/material.dart' show Widget;
import 'package:adhara/resources/url.dart';
import 'package:chopper/chopper.dart';


abstract class Configurator{

  String get name;

  Map<String, dynamic> _config = {};

  ///Get data config loaded from config file
  Map<String, dynamic> get fromFile => _config;

  ///Container class for the app
  Widget container;

  ///Base network URL. For example: https://myexample.com/fluttter_api_base/
  String baseURL;

  ///SQLite Database name
  String dbName;

  ///SQLite Database version
  int dbVersion = 1;

  ///Config file to load the JSON configuration from
  String configFile;

  ///Offline provider class for the application
  OfflineProvider get offlineProvider => OfflineProvider(this);

  ///Network provider class for the application
  NetworkProvider get networkProvider => NetworkProvider(this);

  ///Chopper based network provider class for the application
  ChopperService get chopperService => null;

  ///DataInterface class for the application
  DataInterface get dataInterface => DataInterface(this);

  ///Return a map of language vs language properties file
  ///Ex: {
  ///   'en': 'assets/languages/en.properties',
  ///   'pt': 'assets/languages/pt.properties'
  /// }
  @deprecated
  Map<String, String> languageResources = {};

  /// Return internationalization resources bundle path. Default path is `assets/i18n`
  /// Create files like:
  ///   - assets/i18n/resources.properties  //=> for default language unless overridden by `String defaultLanguage = "<SOME LANGUAGE CODE>";`
  ///   - assets/i18n/resources_en.properties
  ///   - assets/i18n/resources_en_GB.properties
  ///   - assets/i18n/resources_en_US.properties
  ///   - assets/i18n/resources_te.properties
  ///   - assets/i18n/resources_hi.properties
  ///   - assets/i18n/resources_ta.properties
  ///
  /// module level keys will overrides app level keys
  String i18nResourceBundle = 'assets/i18n';

  ///Data provider state offline/online. Must be one of
  /// [ConfigValues.DATA_PROVIDER_STATE_OFFLINE] and
  /// [ConfigValues.DATA_PROVIDER_STATE_ONLINE]
  String dataProviderState = ConfigValues.DATA_PROVIDER_STATE_ONLINE;

  loadConfig() async {
    if(configFile!=null) {
      _config = await ConfigFileLoader.load(configFile);
    }
    baseURL = fromFile[ConfigKeys.BASE_URL] ?? baseURL;
    dbName = fromFile[ConfigKeys.DB_NAME] ?? dbName ?? "adhara-app${this.name}.db";
    dbVersion = fromFile[ConfigKeys.DB_VERSION] ?? dbVersion;
    dataProviderState =
        fromFile[ConfigKeys.DATA_PROVIDER_STATE] ?? dataProviderState;
  }

  validateConfig(){
    assert(baseURL != null, "require base URL");
  }

  ///Enables strict checking of configurations etc in few cases and
  /// throws errors accordingly in development mode
  /// Example: when in strict mode, errors will be thrown
  /// if a resource key is not present for string resources.
  bool get strictMode => false;

  List<URL> get urls;

  String defaultLanguage = "";

}