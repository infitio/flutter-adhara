import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';
import '../datainterface/datainterface.dart';
import '../datainterface/bean/item.dart';


class FirstView extends AdharaStatefulWidget {

  @override
  _FirstViewState createState() => _FirstViewState();

}

class _FirstViewState extends AdharaState<FirstView> {

  String get tag => "FirstView";
  List<Item> items;

  @override
  fetchData(Resources r) async {
    // TODO: implement fetchData
    items = await (r.dataInterface as AccountsDataInterface).getGalleryImages();
    setState((){});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Tiles!!"),
      ),
      backgroundColor: Colors.white,
      body: (items==null)?Container(
        child: Center(
          child: Text("Loading..."),
        ),
      ):new GridView.builder(
          itemCount: items.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2
          ),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(items[index].url),
                  fit: BoxFit.cover
                )
              ),
            );
          }
      ),
    );
  }

}