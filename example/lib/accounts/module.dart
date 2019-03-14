import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import './views/login.dart';
import 'datainterface/e.dart';


class AccountsModule extends AdharaModule{

  String name = "demo-accounts";

  List<URL> get urls => [
    URL("/login", widget: LoginPage())
  ];

  Map<String, String> languageResources = {
    '': 'assets/resources.properties',
    'en': 'assets/resources_en.properties',
    'te': 'assets/resources_te.properties'
  };

  DataInterface get dataInterface => AccountsDataInterface(this);

}
