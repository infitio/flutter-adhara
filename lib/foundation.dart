import 'dart:async';

import 'package:adhara/app.dart';
import 'package:adhara/resources/ar.dart';
import 'package:adhara/resources/ri.dart';
import 'package:adhara/utils.dart';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';

/// Stateful widget for managing resource data
/// Base container for creating adhara based flutter application.
/// This can be considered as a supreme widget for the complete application.
class Adhara extends StatefulWidget {
  final AdharaApp app;
  final Widget splashContainer;

  ///[app] - app config for the app
  ///[splashContainer] - splash container will be rendered
  /// until all required components for adhara are loaded
  ///
  /// NOTE: NO NOT USE THIS TO INITIALIZE THE APPLICATION.
  /// USE [Adhara.init]
  Adhara(this.app, {
    Key key,
    this.splashContainer
  }) : assert(false,
            "Run using `AdharaApp.init(yourAppConfig());` instead of `runApp(AdharaApp(moduleConfig()));`"),
        super(key: key);

  Adhara.init(this.app, {
    Key key,
    this.splashContainer
  }) {
    Function _errorReporter;
    runZoned<Future<Null>>(() async {
      await app.load();
      _errorReporter = getErrorReporter();
      runApp(this);
    }, onError: (error, stackTrace) {
      if (_errorReporter != null) {
        _errorReporter(error, stackTrace);
      } else {
        print(error);
        print(stackTrace);
      }
    });
  }

  Function getErrorReporter() {
    SentryClient _sentry;
    if (app.sentryDSN != null) {
      _sentry = SentryClient(dsn: app.sentryDSN);
      FlutterError.onError = (FlutterErrorDetails details) {
        if (isDebugMode()) {
          // In development mode simply print to console.
          FlutterError.dumpErrorToConsole(details);
        } else {
          // In production mode report to the application zone to report to
          // Sentry.
          Zone.current.handleUncaughtError(details.exception, details.stack);
        }
      };
    }

    // Whenever an error occurs, call the `_reportError` function. This will send
    // Dart errors to our dev console or Sentry depending on the environment.
    Future<Null> reportError(dynamic error, dynamic stackTrace) async {
      // Print the exception to the console
      print('Caught error: $error');
      bool sendToSentry = true;
      app.sentryIgnoreStrings.forEach((ignoreErrorString) {
        try {
          if (error.toString().indexOf(ignoreErrorString) != -1) {
            sendToSentry = false;
          }
        } catch (e) {
          /*DO NOTHING. TRY CATCH USED SINCE error IS dynamic*/
        }
      });
      if (isDebugMode() || _sentry == null || !sendToSentry) {
        // Print the full stacktrace in debug mode
        print(stackTrace);
        return;
      } else {
        // Send the Exception and Stacktrace to Sentry in Production mode
        _sentry.captureException(
          exception: error,
          stackTrace: stackTrace,
        );
      }
    }

    return reportError;
  }

  @override
  _AdharaState createState() => new _AdharaState();
}

// State for managing loading resource data
class _AdharaState extends State<Adhara> {
  ///Resources will be assigned once resources are loaded using [loadResources]
  AppResources _appResources;

  @override
  void initState() {
    super.initState();
    this.loadResources();
  }

  ///Load string resources from properties files
  loadResources() async {
    _appResources = AppResources(widget.app);
    await _appResources.load("en");
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    if (_appResources == null) {
      return widget.splashContainer ?? Container();
    }
    return AppResourcesInheritedWidget(
        resources: _appResources,
        child: widget.app.container
    );
  }

}
