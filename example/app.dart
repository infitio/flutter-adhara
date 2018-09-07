import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';

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