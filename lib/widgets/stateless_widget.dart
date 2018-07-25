import 'package:flutter/material.dart';
import 'package:adhara/resources/ri.dart';
import 'package:adhara/resources/r.dart';

abstract class AdharaStatelessWidget extends StatelessWidget {
  /// Initializes [key] for subclasses.
  const AdharaStatelessWidget({Key key}) : super(key: key);

  @protected
  Widget build(BuildContext context) {
    return buildWithResources(context, ResInheritedWidget.of(context));
  }

  @protected
  Widget buildWithResources(BuildContext context, Resources r);
}
