import 'dart:async';
import 'dart:convert';

import 'package:adhara/config.dart';
import 'package:adhara/datainterface/data/data_provider.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:http/http.dart' as default_http;


class NetworkProvider extends DataProvider {

  IOClient _http;
  NetworkProvider(Config config)
      : assert(config.baseURL.endsWith("/")),
        super(config);

  String get baseURL => this.config.baseURL;

  dynamic formatResponse(dynamic data) {
    return data;
  }

  bool badCertCallback(X509Certificate cert, String host, int port) {
    print("---------------------CERTIFICATE_VERIFY_FAILED---------------------\n"
        "SSL Certificate seems to invalid/self signed.\n"
        " to suppress these logs, override\n"
        "\t`bool badCertCallback(X509Certificate cert, String host, int port)`\n"
        "in your NetworkProvider class and `return true`\n"
        "-------------------------------------------------------------------");
    return true;
  }

  IOClient get http {
    if(_http==null) {
      HttpClient client = new HttpClient();
      client.badCertificateCallback = badCertCallback;
      _http = IOClient(client);
    }
    return _http;
  }

  dynamic extractResponse(dynamic response) {
    response = response as default_http.Response;
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
    response = response as default_http.Response;
    return;
  }

  _postResponseIntercept(
      String method, String url, dynamic data, dynamic response) async {
    response = response as default_http.Response;
    print(
        "http: $method $url with data: ${data ?? data.toString()} response: ${response.statusCode} \n ${response.body}");
    postResponseIntercept(method, url, data, response);
  }

  Future<dynamic> get(String url, {Map headers}) async {
    url = this.formatURL(url);
    _preFlightIntercept("GET", url, null);
    default_http.Response r = await http.get(url, headers: headers ?? this.defaultHeaders);
    await _postResponseIntercept("GET", url, null, r);
    return this.extractResponse(r);
  }

  Future<dynamic> post(String url, Map data, {Map headers}) async {
    url = this.formatURL(url);
    _preFlightIntercept("POST", url, data);
    default_http.Response r = await http.post(url,
        body: json.encode(data), headers: headers ?? this.defaultHeaders);
    await _postResponseIntercept("POST", url, data, r);
    return this.extractResponse(r);
  }

  Future<dynamic> put(String url, Map data, {Map headers}) async {
    url = this.formatURL(url);
    _preFlightIntercept("PUT", url, data);
    default_http.Response r = await http.put(url,
        body: json.encode(data), headers: headers ?? this.defaultHeaders);
    await _postResponseIntercept("PUT", url, data, r);
    return this.extractResponse(r);
  }

  Future<dynamic> delete(String url, {Map headers}) async {
    url = this.formatURL(url);
    _preFlightIntercept("DELETE", url, null);
    default_http.Response r = await http.delete(url, headers: headers ?? this.defaultHeaders);
    await _postResponseIntercept("DELETE", url, null, r);
    return this.extractResponse(r);
  }

}
