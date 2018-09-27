import 'dart:async';

import 'package:adhara/config.dart';
import 'package:adhara/resources/r.dart';
import 'package:adhara/resources/ri.dart';
import 'package:adhara/utils.dart';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';

// Stateful widget for managing resource data
class AdharaApp extends StatefulWidget {
  final Config appConfig;
  final Widget splashContainer;

  AdharaApp(this.appConfig, {Key key, this.splashContainer}) :
      assert(false, "Run using `AdharaApp.initWithConfig(YourAppConfig());` instead of `runApp(AdharaApp(AppConfig()));`"),
      super(key: key);

  AdharaApp.initWithConfig(this.appConfig, {Key key, this.splashContainer}) {
    SentryClient _sentry;
    if (appConfig.sentryDSN != null) {
      _sentry = SentryClient(dsn: appConfig.sentryDSN);
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
      bool sendToSentry = true;
      appConfig.sentryIgnoreStrings.forEach((ignoreErrorString) {
        try {
          if (error.toString().indexOf(ignoreErrorString) != -1) {
            sendToSentry = false;
          }
        } catch (e) {/*DO NOTHING. TRY CATCH USED SINCE error IS dynamic*/}
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

    runZoned<Future<Null>>(() async {
      appConfig.load();
      runApp(this);
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
