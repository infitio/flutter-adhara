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
String getMode(){
  if(const bool.fromEnvironment("dart.vm.product")){
    return "release";
  }
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode? "debug" : "profile";
}

bool isDebugMode(){
  return getMode() == "debug";
}

bool isReleaseMode(){
  return getMode() == "release";
}

bool isProfileMode(){
  return getMode() == "profile";
}