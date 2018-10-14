import 'package:flutter/material.dart' show Widget;
import 'package:adhara/datainterface/network/network_provider.dart';
import 'package:adhara/datainterface/data_interface.dart';
import 'package:adhara/utils.dart';

abstract class Config {
  load() async {
    assert(baseURL != null || configFile != null);
    if (configFile == null) return;
    Map<String, dynamic> _config = await AssetFileLoader.load(configFile);
    baseURL = _config['baseURL'];
    dbName = _config['dbName'] ?? dbName;
    dbVersion = _config['dbVersion'] ?? dbVersion;
    sentryDSN = _config['sentryDSN'] ?? sentryDSN;
    webSocketURL = _config['webSocketURL'];
  }

  Widget get container;

  String baseURL;

  String webSocketURL;

  String configFile;

  String dbName = "adhara-app.db";

  int dbVersion = 1;

  String sentryDSN;

  List<String> get sentryIgnoreStrings => [];

  NetworkProvider get networkProvider;

  DataInterface get dataInterface;

  ///Return a map of language vs language properties file
  ///Ex: {
  ///   'en': 'assets/languages/en.properties',
  ///   'pt': 'assets/languages/pt.properties'
  /// }
  Map<String, String> get languageResources => {};
}
