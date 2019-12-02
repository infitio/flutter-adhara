import 'dart:async' show Future;
import 'dart:convert' show json, utf8;

import 'package:adhara/resources/ar.dart';
import 'package:adhara/resources/r.dart';
import 'package:adhara/resources/ri.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

///Convert any object to string, int/double/json
convertToString(dynamic value, [String defaultValue]) {
  if (value == null) {
    return defaultValue;
  }

  if ((value is int) || (value is double)) {
    return value.toString();
  }

  if ((value is Map) ?? (value is List)) {
    return json.encode(value);
  }

  return value;
}

///Grab app resources object from build context
AppResources getAppResourcesFromContext(BuildContext context) {
  return AppResourcesInheritedWidget.of(context);
}

///Grab module resources object from build context
Resources getResourcesFromContext(BuildContext context) {
  return ResourcesInheritedWidget.of(context);
}

///Opens a URL
///like https://...
///tel://
///mailto:
void openURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

///Returns whether app is running in release/debug/profile mode
String getMode() {
  if (const bool.fromEnvironment("dart.vm.product")) {
    return "release";
  }
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode ? "debug" : "profile";
}

///whether running in debug mode
bool isDebugMode() {
  return getMode() == "debug";
}

///whether running in release mode
bool isReleaseMode() {
  return getMode() == "release";
}

///whether running in profile mode
bool isProfileMode() {
  return getMode() == "profile";
}

bool isHttpUrl(String uri) {
  return uri.startsWith("http://") || uri.startsWith("https://");
}

bool isPackageUrl(String uri) {
  return uri.startsWith("package:");
}

loadFile(String fileURI) async {
  return await rootBundle.loadString(fileURI);
//  import 'package:resource/resource.dart' show Resource;
//  Resource resource = new Resource(fileURI);
//  if(isHttpUrl(fileURI)){
//    return await resource.openRead()   // Reads as stream of bytes.
//        .transform(utf8.decoder).first;
//  }else if(isPackageUrl(fileURI)){
//    return await resource.readAsString(encoding: utf8);
//  }else{
//    return await rootBundle.loadString(fileURI);
//  }
}

class ConfigFileLoader {
  ///returns Map<String, dynamic> | List<dynamic>
  static Future<dynamic> load(String fileURI) async {
    if (fileURI.endsWith(".json")) {
      return await loadJson(fileURI);
    } else {
      return await loadProperties(fileURI);
    }
  }

  static Future<Map<String, String>> loadProperties(String fileURI) async {
    String properties = await loadFile(fileURI);
    Map<String, String> _map = {};
    properties.split("\n").forEach((i) {
      i = i.trim();
      if (i.startsWith("#") || i == "") {
        return;
      }
      _map[i.split('=')[0].trim()] = i.split('=')[1].trim();
    });
    return _map;
  }

  /// returns Map<String, dynamic> | List<dynamic>
  static Future<dynamic> loadJson(String fileURI) async {
    return json.decode(await loadFile(fileURI));
  }
}
