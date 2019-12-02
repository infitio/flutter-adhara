import 'dart:async';
import 'dart:convert';

import 'package:adhara/configurator.dart';
import 'package:adhara/datainterface/data/data_provider.dart';
import 'package:http/http.dart' as http;

class NetworkProvider extends DataProvider {
  NetworkProvider(Configurator config)
      : assert(
            config.baseURL.endsWith("/"), "base url must end with a slash `/`"),
        super(config);

  String get baseURL => this.config.baseURL;

  dynamic formatResponse(dynamic data) {
    return data;
  }

  dynamic extractResponse(dynamic response) {
    response = response as http.Response;
    if (response.statusCode >= 400) {
      throw response;
    }
    try {
      return formatResponse(json.decode(response.body));
    } catch (e) {
      return response.body;
    }
  }

  Map<String, String> get defaultHeaders {
    return {"Content-Type": "application/json"};
  }

  formatURL(String url, {String method: ''}) {
    assert(!url.startsWith("/"));
    return baseURL + url;
  }

  preFlightIntercept(String method, String url, dynamic data) {
    return;
  }

  _preFlightIntercept(String method, String url, dynamic data) {
    preFlightIntercept(method, url, data);
  }

  postResponseIntercept(
      String method, String url, dynamic data, dynamic response) async {
    response = response as http.Response;
    return;
  }

  _postResponseIntercept(
      String method, String url, dynamic data, dynamic response) async {
    response = response as http.Response;
    print(
        "http: $method $url with data: ${data ?? data.toString()} response: ${response.statusCode} \n ${response.body}");
    postResponseIntercept(method, url, data, response);
  }

  Future<dynamic> get(String url, {Map headers}) async {
    url = this.formatURL(url);
    _preFlightIntercept("GET", url, null);
    http.Response r =
        await http.get(url, headers: headers ?? this.defaultHeaders);
    await _postResponseIntercept("GET", url, null, r);
    return this.extractResponse(r);
  }

  Future<dynamic> post(String url, Map data, {Map headers}) async {
    url = this.formatURL(url);
    _preFlightIntercept("POST", url, data);
    http.Response r = await http.post(url,
        body: json.encode(data), headers: headers ?? this.defaultHeaders);
    await _postResponseIntercept("POST", url, data, r);
    return this.extractResponse(r);
  }

  Future<dynamic> put(String url, Map data, {Map headers}) async {
    url = this.formatURL(url);
    _preFlightIntercept("PUT", url, data);
    http.Response r = await http.put(url,
        body: json.encode(data), headers: headers ?? this.defaultHeaders);
    await _postResponseIntercept("PUT", url, data, r);
    return this.extractResponse(r);
  }

  Future<dynamic> delete(String url, {Map headers}) async {
    url = this.formatURL(url);
    _preFlightIntercept("DELETE", url, null);
    http.Response r =
        await http.delete(url, headers: headers ?? this.defaultHeaders);
    await _postResponseIntercept("DELETE", url, null, r);
    return this.extractResponse(r);
  }
}
