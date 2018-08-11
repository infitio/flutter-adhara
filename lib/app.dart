import 'package:adhara/utils.dart';
import 'package:sentry/sentry.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhara/resources/r.dart';
import 'package:adhara/resources/ri.dart';
import 'package:adhara/config.dart';
import 'package:adhara/utils.dart';

// Stateful widget for managing resource data
class AdharaApp extends StatefulWidget {
  final Config appConfig;
  final Widget splashContainer;

  AdharaApp(this.appConfig, {Key key, this.splashContainer}) : super(key: key);

  static initWithConfig(Config appConfig){

    SentryClient _sentry;
    if(appConfig.sentryDSN!=null) {
      _sentry = SentryClient(dsn: "https://28f80fb3c74d4a36ac2177c16fda1cac:5aad9c2e91434f48bb613c63920e1672@sentry.io/1260656");
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

    Future<Null> reportError(dynamic error, dynamic stackTrace) async {
      // Print the exception to the console
      print('Caught error: $error');
      if (isDebugMode() || _sentry==null) {
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

    return runZoned<Future<Null>>(() async {
      runApp(AdharaApp(appConfig));
    }, onError: (error, stackTrace) {
      // Whenever an error occurs, call the `_reportError` function. This will send
      // Dart errors to our dev console or Sentry depending on the environment.
      reportError(error, stackTrace);
    });
  }

  @override
  _AdharaAppState createState() => new _AdharaAppState();
}

// State for managing loading resource data
class _AdharaAppState extends State<AdharaApp> {
  Resources _res;

  @override
  void initState() {
    super.initState();
    this.loadResources();
  }

  loadResources() {
    return Resources(widget.appConfig).load("en").then((resources) {
      setState(() {
        _res = resources;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_res == null) {
      return widget.splashContainer ?? Container();
    }
    return new ResInheritedWidget(res: _res, child: widget.appConfig.container);
  }
}
