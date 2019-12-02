import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

// TODO import all app modules
//import 'package:plugin_module/module.dart';

class App extends AdharaApp {
  String get name => "app";

  String get configFile {
    return isReleaseMode()
        ? "assets/config/production.json"
        : "assets/config/dev.json";
  }

  Widget get container => MyApp();

//  TODO initialize all app modules
//  AdharaModule module1 = Module1();

  List<AdharaModule> get modules => [
//    TODO add all module instances in this list
//    module1,
      ];

  List<URL> get urls => [
//    TODO add all module access URLs
//    URL('/accounts', module: accountsModule)
      ];
}

class MyApp extends AdharaStatelessAppWidget {
  // This widget is the root of your application.
  @override
  Widget buildWithResources(BuildContext context, AppResources ar) {
    return MaterialApp(
      title: 'Flutter-Adhara Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter-Adhara Demo Home Page'),
      onGenerateRoute: Router.getAppRouteGenerator(ar),
    );
  }
}
