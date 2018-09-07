import 'package:flutter/material.dart' show Widget;
import 'package:adhara/datainterface/network/network_provider.dart';
import 'package:adhara/datainterface/data_interface.dart';

abstract class Config {
  Widget get container;

  String baseURL;

  NetworkProvider get networkProvider;

  DataInterface get dataInterface;

  String get dbName {
    return "app_dev_r12.db";
  }

  int get dbVersion {
    return 1;
  }

  ///Return a map of language vs language properties file
  ///Ex: {
  ///   'en': 'assets/languages/en.properties',
  ///   'pt': 'assets/languages/pt.properties'
  /// }
  Map<String, String> get languageResources => {};

  String get sentryDSN => null;

  List<String> get sentryIgnoreStrings => [];
}
