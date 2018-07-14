import 'dart:async';
import 'dart:convert';
import 'package:adhara/config.dart';

import 'package:http/http.dart' as http;


abstract class NetworkProvider{

  Config config;

  NetworkProvider(this.config){
    assert(this.baseURL.endsWith("/"));
  }

  String get baseURL => this.config.baseURL;

  dynamic formatResponse(Map data){
    return data;
  }

  dynamic extractResponse(http.Response response){
    try{
      return this.formatResponse(json.decode(response.body));
    }catch(e){
      return response.body;
    }
  }

  get defaultHeaders{
    return { "Content-Type": "application/json" };
  }

  formatURL(String url){
    assert(!url.startsWith("/"));
    return baseURL+url;
  }

  Future<dynamic> get(String url, {Map headers}) async {
    return this.extractResponse(await http.get(this.formatURL(url),
      headers: headers ?? this.defaultHeaders));
  }

  Future<dynamic> post(String url, Map data, {Map headers}) async {
    return this.extractResponse(await http.post(this.formatURL(url),
      body: json.encode(data),
      headers: headers ?? this.defaultHeaders));
  }

  Future<dynamic> put(String url, Map data, {Map headers}) async {
    return this.extractResponse(await http.put(this.formatURL(url),
      body: json.encode(data),
      headers: headers ?? this.defaultHeaders));
  }

  Future<dynamic> delete(String url) async {
    return this.extractResponse(await http.get(this.formatURL(url)));
  }

}