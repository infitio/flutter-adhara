import 'package:flutter/material.dart';

import '../resources/r.dart';
import '../styles/text_styles.dart';
import 'stateless_widget.dart';


class NoData extends AdharaStatelessWidget{

  final String displayText;
  final TextStyle textStyle;

  NoData({
    Key key,
    this.displayText: "No Data Availalbe",
    this.textStyle: AdharaStyles.textMuted
  }) : super(key: key);

  @override
  Widget buildWithResources(BuildContext context, Resources r){
    return Center(
      child: Text(displayText, style: textStyle)
    );
  }

}