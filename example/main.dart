/// appconfig.dart

//import "app.dart";  TODO uncomment
import "package:adhara/adhara.dart";
import 'package:flutter/material.dart';

//TODO declare in a separate file and implement required methods
class AppNetworkProvider extends NetworkProvider{ AppNetworkProvider(Config config):super(config); }

//TODO declare in a separate file and implement required methods
class AppDataInterface extends DataInterface{ AppDataInterface(Config config):super(config); }

class AppConfig extends Config{

  ///Return App Container Widget
  get container => App();

  ///Return Network URL
  String get baseURL{
    return isReleaseMode()
      ?"http://mysite.com/"         //TODO set production URL
      :"http://192.168.0.1:8000/";  //TODO set development URL
  }

  ///Return App Network Provider
  NetworkProvider get networkProvider => AppNetworkProvider(this);

  ///Return App Data Interface
  DataInterface get dataInterface => AppDataInterface(this);

  ///return SQLite DB Name
  String get dbName{
    return isReleaseMode()
      ?"production.db"
      :"development.db";
  }

  ///return SQLite DB Version -  to increment on new releases if required...
  int get dbVersion{
    return isReleaseMode()?1:1;
  }

  ///  Language file map will be used to display the text content where ever r.getString(RESOURCE_KEY) is used
  ///    Language file is a .properties file
  ///    Pattern: RESOURCE_KEY=RESOURCE_VALUE
  ///-----------------------------------------
  ///    key1=Value 1
  ///    key2=Value 2
  ///    ....
  ///-----------------------------------------
  Map<String, String> get languageResources => {
//  TODO create language files, refer them in pubspec assets and map it here.
    "en": "assets/languages/en.properties",
    "fr": "assets/languages/fr.properties",
    "ka": "assets/languages/te.properties",
    "hi": "assets/languages/hi.properties",
  };

}


/// app.dart
//import 'package:flutter/material.dart'; //TODO uncomment
//import 'package:adhara/adhara.dart'; //TODO uncomment

class App extends AdharaStatefulWidget {

  @override
  _AppState createState() => _AppState();

}

/*App code Starts here*/
class _AppState extends AdharaState<App> {

  @override
  void initState(){
    super.initState();
  }

  @override
  firstLoad() async {
    //    This will be called only when this widget is called for the very first time of app lifecycle
  }

  String get tag => "App";  //Unique identifier for this widget

  bool isLoggedIn;
//  Widget home = SplashScreen();

  @override
  fetchData(Resources r) async {
//    TODO perform any database queries from AppDataInterface
//  This function will be called whenever widget's init state is called. For the first time, this will be called only after firstLoad.

//    isLoggedIn = await (r.dataInterface as AppDataInterface).isLoggedIn();
//    home = isLoggedIn?HomePage():LoginPage();
//    home = HomePage();

    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: r.getString("app_title"),  //Query String resource from properties files... ( i18n )
      debugShowCheckedModeBanner: false,
//      home:  home,
//      onGenerateRoute: routeGenerator,
    );
  }
}

/// main.dart
//import 'package:flutter/material.dart'; //TODO uncomment
//import 'appconfig.dart'; //TODO uncomment
//import 'package:adhara/adhara.dart'; //TODO uncomment


void main() => AdharaApp.initWithConfig(AppConfig());