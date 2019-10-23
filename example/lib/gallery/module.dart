import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import './views/firstview.dart';
import './views/secondview.dart';
import 'datainterface/i.dart';


class GalleryModule extends AdharaModule{

  String name = "gallery";

  List<URL> get urls => [
    URL("/view1", widget: FirstView()),
    URL("/view2", widget: SecondView())
  ];

  String i18nResourceBundle = 'assets/i18n';

  /*Map<String, String> languageResources = {
    '': 'assets/i18n/resources.properties',
    'en': 'assets/i18n/resources_hi.properties',
    'te': 'assets/i18n/resources_te.properties'
  };*/

  DataInterface get dataInterface => AccountsDataInterface(this);

}
