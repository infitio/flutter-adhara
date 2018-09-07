import "app.dart";
import "package:adhara/adhara.dart";

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
