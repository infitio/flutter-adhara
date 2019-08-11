import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';
import '../datainterface/e.dart';

class FirstView extends AdharaStatefulWidget {

  @override
  _FirstViewState createState() => _FirstViewState();

}

class _FirstViewState extends AdharaState<FirstView> {

  String get tag => "FirstView";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("View one!"),
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Text("First View!")
      ),
    );
  }

}