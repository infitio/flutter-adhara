import 'dart:async';
import 'dart:convert';
import 'package:adhara/config.dart';

import 'package:http/http.dart' as http;

abstract class NetworkProvider {
  Config config;

  NetworkProvider(this.config) {
    assert(this.baseURL.endsWith("/"));
  }

  String get baseURL => this.config.baseURL;

  dynamic formatResponse(Map data) {
    return data;
  }

  dynamic extractResponse(http.Response response) {
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

  formatURL(String url) {
    assert(!url.startsWith("/"));
    return baseURL + url;
  }

  preFlightIntercept(String method, String url, dynamic data){
    return;
  }

  postResponseIntercept(String method, String url, http.Response response) async {
    return;
  }

  Future<dynamic> get(String url, {Map headers}) async {
    url = this.formatURL(url);
    preFlightIntercept("GET", url, null);
    http.Response r = await http.get(url,
      headers: headers ?? this.defaultHeaders);
    await postResponseIntercept("GET", url, null);
    return this.extractResponse(r);
  }

  Future<dynamic> post(String url, Map data, {Map headers}) async {
    url = this.formatURL(url);
    preFlightIntercept("POST", url, data);
    http.Response r = await http.post(url, body: json.encode(data),
      headers: headers ?? this.defaultHeaders);
    await postResponseIntercept("POST", url, null);
    return this.extractResponse(r);
  }

  Future<dynamic> put(String url, Map data, {Map headers}) async {
    url = this.formatURL(url);
    preFlightIntercept("PUT", url, data);
    http.Response r = await http.put(url,
      body: json.encode(data), headers: headers ?? this.defaultHeaders);
    await postResponseIntercept("PUT", url, null);
    return this.extractResponse(r);
  }

  Future<dynamic> delete(String url, {Map headers}) async {
    url = this.formatURL(url);
    preFlightIntercept("DELETE", url, null);
    http.Response r = await http.delete(url,
      headers: headers ?? this.defaultHeaders);
    await postResponseIntercept("DELETE", url, null);
    return this.extractResponse(r);
  }
}
