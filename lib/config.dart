import 'package:flutter/material.dart' show Widget;
import 'package:adhara/datainterface/network/network_provider.dart';
import 'package:adhara/datainterface/data_interface.dart';
import 'package:adhara/utils.dart';

abstract class Config {
  Map<String, dynamic> _config = {};
  Map<String, dynamic> get fromFile => _config;

  load() async {
    assert(baseURL != null || configFile != null);
    if (configFile == null) return;
    _config = await AssetFileLoader.load(configFile);
    baseURL = fromFile['baseURL'];
    dbName = fromFile['dbName'] ?? dbName;
    dbVersion = fromFile['dbVersion'] ?? dbVersion;
    sentryDSN = fromFile['sentryDSN'] ?? sentryDSN;
  }

  Widget get container;

  String baseURL;

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
