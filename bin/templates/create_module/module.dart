import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import './views/firstview.dart';
import './views/secondview.dart';
import 'datainterface/e.dart';


class AccountsModule extends AdharaModule{

  String name = "{{moduleName}}";

  List<URL> get urls => [
    URL("/view1", widget: FirstView()),
    URL("/view2", widget: SecondView())
  ];

  Map<String, String> languageResources = {
    '': 'assets/resources.properties',
    'en': 'assets/resources_hi.properties',
    'te': 'assets/resources_te.properties'
  };

  DataInterface get dataInterface => AccountsDataInterface(this);

}
