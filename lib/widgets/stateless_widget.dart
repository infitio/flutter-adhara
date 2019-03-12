import 'package:adhara/resources/r.dart';
import 'package:adhara/resources/ri.dart';
import 'package:flutter/material.dart';

///Enhanced version of a StatelessWidget required to work with adhara widgets
abstract class AdharaStatelessWidget extends StatelessWidget {
  /// Initializes [key] for subclasses.
  const AdharaStatelessWidget({Key key}) : super(key: key);

  @protected
  Widget build(BuildContext context) {
    return buildWithResources(context, ResourcesInheritedWidget.of(context));
  }

  @protected
  Widget buildWithResources(BuildContext context, Resources r);
}
