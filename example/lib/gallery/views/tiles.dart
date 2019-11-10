import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';
import '../datainterface/datainterface.dart';
import '../datainterface/bean/item.dart';

class TilesView extends AdharaStatefulWidget {

  @override
  _TilesViewState createState() => _TilesViewState();

}

class _TilesViewState extends AdharaState<TilesView> {

  String get tag => "TilesView";
  List<Item> items;

  @override
  fetchData(Resources r) async {
    items = await (r.dataInterface as GalleryDataInterface).getGalleryImages();
    setState((){});
  }

  @override
  Widget build(BuildContext context){
    return (items==null)?Container():GridView.builder(
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
    );
  }

}