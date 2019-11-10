import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';
import '../datainterface/datainterface.dart';
import '../datainterface/bean/item.dart';
import 'tiles.dart';
import 'filmstrip.dart';
import 'preview.dart';


class HomeView extends AdharaStatefulWidget {

  @override
  _HomeViewState createState() => _HomeViewState();

}

enum Mode{
  TILES, FILM_STRIP
}

class _HomeViewState extends AdharaState<HomeView> {

  String get tag => "Home";
  List<Item> items;
  Mode mode = Mode.TILES;

  @override
  fetchData(Resources r) async {
    items = await (r.dataInterface as AccountsDataInterface).getGalleryImages();
    setState((){});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Tiles!!"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.switch_camera),
            onPressed: (){
              if(mode == Mode.FILM_STRIP){
                mode = Mode.TILES;
              }else{
                mode = Mode.FILM_STRIP;
              }
              setState((){});
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: (items==null)?Container(
        child: Center(
          child: Text("Loading..."),
        ),
      ):_buildContent(),
    );
  }

  _buildContent(){
    if(mode==Mode.TILES) return _buildTiles();
    else if(mode==Mode.FILM_STRIP) return _buildFilmStrip();
  }

  _buildTiles(){
    return TilesView();
  }

  _buildFilmStrip(){
    return Container(
      height: double.maxFinite,
      child: Column(
        children: <Widget>[
          Expanded(
            child: PreviewImage(),
          ),
          Container(
            height: MediaQuery.of(context).size.height/5,
            child: FilmStrip(),
          )
        ],
      ),
    );
  }

}