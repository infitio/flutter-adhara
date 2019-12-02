import 'dart:async';

import 'package:adhara/configurator.dart';

abstract class DataProvider {
  Configurator config;

  DataProvider(this.config);

  load() async {
    /*Can do something if required*/
  }

  dynamic formatResponse(dynamic data) => data;

  dynamic extractResponse(dynamic response) => response;

  formatURL(String url, {String method});

  Future<dynamic> get(String url, {Map headers});

  Future<dynamic> post(String url, Map data, {Map headers});

  Future<dynamic> put(String url, Map data, {Map headers});

  Future<dynamic> delete(String url, {Map headers});
}
