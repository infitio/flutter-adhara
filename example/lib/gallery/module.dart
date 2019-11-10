import 'package:adhara/adhara.dart';

import './views/home.dart';
import 'datainterface/i.dart';


class GalleryModule extends AdharaModule{

  String name = "gallery";

  List<URL> get urls => [
    URL("/home", widget: HomeView()),
  ];

  String i18nResourceBundle = 'assets/i18n';

  /*Map<String, String> languageResources = {
    '': 'assets/i18n/resources.properties',
    'en': 'assets/i18n/resources_hi.properties',
    'te': 'assets/i18n/resources_te.properties'
  };*/

  DataInterface get dataInterface => AccountsDataInterface(this);

}
