import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';
import '../datainterface/bean/item.dart';

class PreviewImage extends AdharaStatefulWidget {

  @override
  _PreviewImageState createState() => _PreviewImageState();

}

class _PreviewImageState extends AdharaState<PreviewImage> {

  String get tag => "Preview";
  Item item;

  @override
  Map<String, EventHandlerCallback> get eventHandlers => {
    "update-preview": (dynamic data, AdharaEvent event) => setState((){item = data;})
  };

  @override
  Widget build(BuildContext context){
    return (item==null)?Container(
      child: Text("No image selected"),
    ):Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(item.url),
                fit: BoxFit.cover
            )
        ),
      );
  }

}