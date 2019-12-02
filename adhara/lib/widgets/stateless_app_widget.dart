import 'package:adhara/resources/ar.dart';
import 'package:adhara/resources/ri.dart';
import 'package:flutter/material.dart';

///Enhanced version of a StatelessWidget required to work with adhara widgets
abstract class AdharaStatelessAppWidget extends StatelessWidget {
  /// Initializes [key] for subclasses.
  const AdharaStatelessAppWidget({Key key}) : super(key: key);

  @protected
  Widget build(BuildContext context) {
    return buildWithResources(context, AppResourcesInheritedWidget.of(context));
  }

  @protected
  Widget buildWithResources(BuildContext context, AppResources r);
}
