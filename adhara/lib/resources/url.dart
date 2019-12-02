import 'package:adhara/module.dart';
import 'package:flutter/material.dart' show Widget;

typedef Widget CallableRouter();

class URL {
  String pattern;
  Widget widget;
  List<URL> urls;
  String name;
  CallableRouter router;
  AdharaModule module;
  Map<String, dynamic> kwArgs;

  URL(this.pattern,
      {this.router,
      this.widget,
      this.urls,
      this.name,
      this.module,
      this.kwArgs})
      : assert(!(widget == null && router == null && module == null),
            "Invalid URL configuration. Provide a widget, router fn or urls list");

  CallableRouter getRouter() {
    if (router != null) {
      return router;
    }
    return () => widget;
  }

  String getPattern(URL parentURL) {
    return ((parentURL == null) ? "" : parentURL.pattern) + pattern;
  }

  get routableURL {
    return RoutableURL(pattern,
        router: getRouter(), module: module, kwArgs: kwArgs);
  }
}

class RoutableURL {
  String pattern;
  CallableRouter router;
  AdharaModule module;
  Map<String, dynamic> kwArgs;

  RoutableURL(this.pattern, {this.router, this.module, this.kwArgs});
}
