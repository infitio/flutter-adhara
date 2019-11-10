import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';
import '../datainterface/datainterface.dart';
import '../datainterface/bean/item.dart';

class FilmStrip extends AdharaStatefulWidget {

  @override
  _FilmStripState createState() => _FilmStripState();

}

class _FilmStripState extends AdharaState<FilmStrip> {

  String get tag => "FilmStrip";
  List<Item> items;

  @override
  fetchData(Resources r) async {
    items = await (r.dataInterface as GalleryDataInterface).getGalleryImages();
    setState((){});
  }

  @override
  Widget build(BuildContext context){
    return (items==null)?Container():ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index){
          return InkWell(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(items[index].url),
                      fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12.0))
              ),
              margin: EdgeInsets.only(left: 12.0, top: 12.0, bottom: 12.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width/2.5,
            ),
            onTap: (){
              r.eventHandler.trigger(
                  "update-preview",
                  items[index],
                  "film-strip"
              );
            },
          );
        }
    );
  }

}