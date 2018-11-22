import 'package:flutter/material.dart';

import '../resources/r.dart';
import '../styles/text_styles.dart';
import 'no_data.dart';

class Fetching extends NoData {
  final String text;
  final Widget bottom;
  final TextStyle textStyle;
  final String assetPath;

  Fetching(
      {Key key,
      this.bottom,
      this.text: "Loading...",
      this.textStyle: AdharaStyles.textMuted,
      this.assetPath})
      : super(key: key);

  @override
  Widget buildWithResources(BuildContext context, Resources r) {
    String _assetPath = assetPath ??
        r.config.fromFile['fetchingImage'] ??
        "assets/animations/fetching.gif";
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Container(
            width: 120.0,
            child: Center(child: Image.asset(_assetPath)),
          ),
          bottom ?? text != null
              ? Text(
                  text,
                  style: textStyle,
                  textAlign: TextAlign.center,
                )
              : Container(),
        ]));
  }
}
