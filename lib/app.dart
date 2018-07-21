import 'package:flutter/material.dart';
import 'package:adhara/resources/r.dart';
import 'package:adhara/resources/ri.dart';
import 'package:adhara/config.dart';

// Stateful widget for managing resource data
class AdharaApp extends StatefulWidget {
  final Config appConfig;
  final Widget splashContainer;

  AdharaApp(this.appConfig, {Key key, this.splashContainer}) : super(key: key);

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
