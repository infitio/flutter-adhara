import 'dart:async';

import 'package:adhara/resources/ar.dart';
import 'package:adhara/resources/r.dart';
import 'package:flutter/material.dart';


// Inherited widget for managing resources...
class AppResourcesInheritedWidget extends InheritedWidget {
  const AppResourcesInheritedWidget({Key key, this.resources, Widget child})
      : super(key: key, child: child);

  final AppResources resources;

  @override
  bool updateShouldNotify(AppResourcesInheritedWidget old) {
    return resources.language != old.resources.language;
  }

  static Future<AppResources> ofFuture(BuildContext context) async {
    return new Future.delayed(Duration.zero, () {
      return AppResourcesInheritedWidget.of(context);
    });
  }

  static AppResources of(BuildContext context) {
    AppResourcesInheritedWidget riw =
    context.inheritFromWidgetOfExactType(AppResourcesInheritedWidget);
    return riw.resources;
  }
}


// Inherited widget for managing resources...
class ResourcesInheritedWidget extends InheritedWidget {
  const ResourcesInheritedWidget({Key key, this.resources, Widget child})
      : super(key: key, child: child);

  final Resources resources;

  @override
  bool updateShouldNotify(ResourcesInheritedWidget old) {
    return resources.language != old.resources.language;
  }

  static Future<Resources> ofFuture(BuildContext context) async {
    return new Future.delayed(Duration.zero, () {
      return ResourcesInheritedWidget.of(context);
    });
  }

  static Resources of(BuildContext context) {
    ResourcesInheritedWidget riw =
        context.inheritFromWidgetOfExactType(ResourcesInheritedWidget);
    return riw.resources;
  }
}
