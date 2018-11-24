import 'package:flutter/material.dart' show Widget;
import 'package:adhara/datainterface/data/offline_provider.dart';
import 'package:adhara/datainterface/data/network_provider.dart';
import 'package:adhara/datainterface/data_interface.dart';
import 'package:adhara/utils.dart';
import 'package:adhara/constants.dart';

abstract class Config {
  Map<String, dynamic> _config = {};
  Map<String, dynamic> get fromFile => _config;
  Widget get container;
  String baseURL;
  String configFile;
  String dbName = "adhara-app.db";
  int dbVersion = 1;
  String sentryDSN;
  String dataProviderState = ConfigValues.DATA_PROVIDER_STATE_ONLINE;
  List<String> get sentryIgnoreStrings => [];
  OfflineProvider get offlineProvider => OfflineProvider(this);
  NetworkProvider get networkProvider => NetworkProvider(this);
  DataInterface get dataInterface;
  ///Return a map of language vs language properties file
  ///Ex: {
  ///   'en': 'assets/languages/en.properties',
  ///   'pt': 'assets/languages/pt.properties'
  /// }
  Map<String, String> get languageResources => {};

//  Widget configs
  String fetchingImage = "";  //will be set to null on load
  String fetchingIndicator = ConfigValues.FETCHING_INDICATOR_LINEAR;

  load() async {
    assert(baseURL != null || configFile != null);
    if (configFile == null) return;
    _config = await AssetFileLoader.load(configFile);
    baseURL = fromFile[ConfigKeys.BASE_URL];
    dbName = fromFile[ConfigKeys.DB_NAME] ?? dbName;
    dbVersion = fromFile[ConfigKeys.DB_VERSION] ?? dbVersion;
    sentryDSN = fromFile[ConfigKeys.SENTRY_DSN] ?? sentryDSN;
    dataProviderState =
      fromFile[ConfigKeys.DATA_PROVIDER_STATE] ?? dataProviderState;
//    widget configs
    fetchingImage = fetchingImage ?? ((fetchingImage!="")?fetchingImage:fromFile[ConfigKeys.FETCHING_IMAGE]) ?? null;
    fetchingIndicator = fromFile[ConfigKeys.FETCHING_INDICATOR];
  }
}
