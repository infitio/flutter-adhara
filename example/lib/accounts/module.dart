import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import './views/login.dart';
import 'datainterface/e.dart';


class AccountsModule extends AdharaModule{

  String name = "demo-accounts";

  Widget container = Container();

  List<URL> get urls => [
    URL("/login", widget: LoginPage())
  ];

  DataInterface get dataInterface => AccountsDataInterface(this);

}
