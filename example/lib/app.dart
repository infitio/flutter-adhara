import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import 'package:adhara_example/accounts/module.dart';
import 'package:adhara_example/gallery/module.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


class App extends AdharaApp{

  String get configFile{
    return isReleaseMode()
        ?"assets/config/production.json"
        :"assets/config/dev.json";
  }

  Widget get container => MyApp();

  AdharaModule accountsModule = AccountsModule();
  AdharaModule galleryModule = GalleryModule();

  List<AdharaModule> get modules => [
    accountsModule,
  ];

  List<URL> get urls => [
    URL('/accounts', module: accountsModule),
    URL('/gallery', module: galleryModule),
  ];

}

class MyApp extends AdharaStatelessAppWidget {

  // This widget is the root of your application.
  @override
  Widget buildWithResources(BuildContext context, AppResources ar) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      onGenerateRoute: Router.getAppRouteGenerator(ar),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _dialVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Highly modular out of the box features support for flutter apps',
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        curve: Curves.ease,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.account_circle),
              backgroundColor: Colors.redAccent,
              label: 'Accounts',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => Navigator.of(context).pushNamed("/accounts/login")
          ),
          SpeedDialChild(
            child: Icon(Icons.photo),
            backgroundColor: Colors.greenAccent,
            label: 'Gallery',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => Navigator.of(context).pushNamed("/gallery/view1")
          ),
        ],
      ),
//      FloatingActionButton.extended(
//        onPressed: (){
//          Navigator.of(context).pushNamed("/accounts/login");
//        },
//        tooltip: 'Increment',
//        label: Text("ASDF"),
//        children: Icon(Icons.add),
//    ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
