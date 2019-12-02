import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';

class MyHomePage extends AdharaStatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends AdharaState<MyHomePage> {
  String get tag => "";

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
            Text(ar.getString("description")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/accounts/login");
        },
        tooltip: r.getString("open_module"),
        child: Icon(Icons.input),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
