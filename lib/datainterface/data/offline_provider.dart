import 'dart:async';

import 'package:adhara/config.dart';
import 'package:adhara/datainterface/data/data_provider.dart';
import 'package:adhara/utils.dart';

///Offline provider can be helpful for data mocking in development
///Data mock can be stored in assets/data/<API_URL_AS_PATH>/<METHOD>.json file
///Say for example:
/// Network Provider(Online) calls GET '/api/v1/items',
/// Using Offline provider one can mock the data by creating '/assets/data/api/v1/items/get.json'
///
/// (or)
/// Network Provider(Online) calls DELETE '/api/v1/items/1',
/// Using Offline provider one can mock the data by creating '/assets/data/api/v1/items/1/delete.json'
///
///Note that method name must be lowercase
///
/// Offline provider greatly helps in integrated testing with data
class OfflineProvider extends DataProvider {
  OfflineProvider(Config config) : super(config);

  dynamic formatResponse(dynamic data) => data;

  dynamic extractResponse(dynamic response) => response;

  formatURL(String url, {String method}) => 'assets/data/$url/$method.json';

  Future<dynamic> get(String url, {Map headers}) async {
    url = this.formatURL(url, method: 'get');
    Map r = await AssetFileLoader.load(url);
    return this.extractResponse(r);
  }

  Future<dynamic> post(String url, Map data, {Map headers}) async {
    url = this.formatURL(url, method: 'post');
    Map r = await AssetFileLoader.load(url);
    return this.extractResponse(r);
  }

  Future<dynamic> put(String url, Map data, {Map headers}) async {
    url = this.formatURL(url, method: 'put');
    Map r = await AssetFileLoader.load(url);
    return this.extractResponse(r);
  }

  Future<dynamic> delete(String url, {Map headers}) async {
    url = this.formatURL(url, method: 'delete');
    Map r = await AssetFileLoader.load(url);
    return this.extractResponse(r);
  }
}
