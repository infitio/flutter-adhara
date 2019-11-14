import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import 'views/login.dart';
import 'views/signup.dart';
import 'datainterface/i.dart';


class AccountsModule extends AdharaModule{

  String name = "demo-accounts";

  List<URL> get urls => [
    URL("/login", widget: LoginPage()),
    URL("/signup", widget: SignupPage()),
  ];

  Map<String, String> languageResources = {
    '': 'assets/resources.properties',
    'en': 'assets/resources_hi.properties',
    'te': 'assets/resources_te.properties'
  };

  DataInterface get dataInterface => AccountsDataInterface(this);

}
