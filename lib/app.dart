import 'package:adhara/constants.dart';
import 'package:adhara/module.dart';
import 'package:flutter/material.dart';
import 'package:adhara/utils.dart';


abstract class AdharaApp extends AdharaModule{

  /// get list of app modules
  List<AdharaModule> get modules;

  ///Sentry DSN to configure sentry error reporting
  String sentryDSN = "";

  ///Suppress errors to be reported to Sentry
  /// by adding a substring from the error message text
  List<String> get sentryIgnoreStrings => [];

  Widget get container;

  //  Widget configs
  ///fetchingIndicator. Must be one of
  /// [ConfigValues.FETCHING_INDICATOR_CIRCULAR] and
  /// [ConfigValues.FETCHING_INDICATOR_LINEAR]
  String fetchingIndicator = ConfigValues.FETCHING_INDICATOR_LINEAR;

  ///If fetching image is set, indicator [fetchingIndicator] is ignored
  String fetchingImage = ""; //will be set to null on load

  Map<String, dynamic> _config = {};

  load() async {
    assert(baseURL != null || configFile != null);
    if (configFile == null) return;
    _config = await AssetFileLoader.load(configFile);
    for(AdharaModule module in modules){
      await module.load();
    }
    sentryDSN = fromFile[ConfigKeys.SENTRY_DSN] ?? sentryDSN;
//    widget configs
    fetchingImage = fetchingImage ??
        ((fetchingImage != "")
            ? fetchingImage
            : fromFile[ConfigKeys.FETCHING_IMAGE]) ??
        null;
    fetchingIndicator = fromFile[ConfigKeys.FETCHING_INDICATOR];
  }

}