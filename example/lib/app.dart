import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import 'package:adhara_example/accounts/module.dart';
import 'package:adhara_example/gallery/module.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed("/accounts/login");
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
