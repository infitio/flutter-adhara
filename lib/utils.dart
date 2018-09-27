import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' show json;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:adhara/resources/r.dart';
import 'package:adhara/resources/ri.dart';

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

Resources getResourcesFromContext(BuildContext context) {
  return ResInheritedWidget.of(context);
}

/*URL launcher*/
void openURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

/*Mode checker's*/
String getMode() {
  if (const bool.fromEnvironment("dart.vm.product")) {
    return "release";
  }
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode ? "debug" : "profile";
}

bool isDebugMode() {
  return getMode() == "debug";
}

bool isReleaseMode() {
  return getMode() == "release";
}

bool isProfileMode() {
  return getMode() == "profile";
}

class AssetFileLoader{

  static Future<Map<String, dynamic>> load(String filePath) async {
    if(filePath.endsWith(".json")) return await loadJson(filePath);
    else return await loadProperties(filePath);
  }

  static Future<Map<String, String>> loadProperties(String filePath) async {
    String properties = await rootBundle.loadString(filePath);
    Map<String, String> _map = {};
    properties.split("\n").forEach((i) {
      i = i.trim();
      if (i.startsWith("#") || i == "") {
        return;
      }
      _map[i.split('=')[0].trim()] =
        i.split('=')[1].trim();
    });
    return _map;
  }

  static Future<Map<String, dynamic>> loadJson(String filePath) async {
    return json.decode(await rootBundle.loadString(filePath));
  }

}