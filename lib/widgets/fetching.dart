import 'package:adhara/constants.dart';
import 'package:adhara/resources/r.dart';
import 'package:adhara/styles/text_styles.dart';
import 'package:adhara/widgets/no_data.dart';
import 'package:flutter/material.dart';

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

  String getAssetPath(Resources r) => assetPath ?? r.appResources.app.fetchingImage;

  Widget getTop(r) {
    String _assetPath = getAssetPath(r);
    if (_assetPath == null) return Container();
    return Container(
      width: 120.0,
      child: Center(child: Image.asset(_assetPath)),
    );
  }

  Widget getCenter() {
    if (text == null) return Container();
    return Text(
      text,
      style: textStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget getBottom(Resources r) {
    if (getAssetPath(r) != null) return Container();
    return SizedBox(
      width: 100.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: r.appResources.app.fetchingIndicator ==
                ConfigValues.FETCHING_INDICATOR_CIRCULAR
            ? CircularProgressIndicator()
            : LinearProgressIndicator(),
      ),
    );
  }

  @override
  Widget buildWithResources(BuildContext context, Resources r) {
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [getTop(r), getCenter(), getBottom(r)]));
  }
}
