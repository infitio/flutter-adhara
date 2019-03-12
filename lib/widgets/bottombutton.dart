import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {

  final double height;
  final Function onPressed;
  final String text;
  final Color color;
  final Color disabledColor;
  final TextStyle style;

  const BottomButton(this.text, {
    Key key,
    this.height: 56.0,
    this.color,
    this.disabledColor,
    this.style,
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          new Expanded(
              child: Material(
                child: MaterialButton(
                  height: this.height, onPressed: this.onPressed??(){}, color: (this.onPressed==null)?this.disabledColor:this.color,
                  child: new Text( this.text.toUpperCase(), style: this.style ),
                ),
              )
          ),
        ]
    );

  }
}