import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';
import '../datainterface/e.dart';

class SecondView extends AdharaStatefulWidget {

  @override
  _SecondViewState createState() => _SecondViewState();

}

class _SecondViewState extends AdharaState<SecondView> {

  String get tag => "SecondView";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("View two!"),
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Text("Second View!")
      ),
    );
  }

}