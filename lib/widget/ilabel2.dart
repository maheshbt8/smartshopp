import 'package:flutter/material.dart';

class ILabel2 extends StatelessWidget {
  final Color color;
  final String text;
  final TextStyle textStyle;
  final Color colorBackgroud;
  final double height;
  ILabel2({this.text, this.color, this.textStyle, this.colorBackgroud, this.height});

  @override
  Widget build(BuildContext context) {
    Color _colorBackgroud = Colors.transparent;
    if (colorBackgroud != null)
      _colorBackgroud = colorBackgroud;
    Color _color = Colors.grey;
    if (color != null)
      _color = color;
    var _textStyle = TextStyle(fontSize: 16, color: _color);
    if (textStyle != null)
      _textStyle = textStyle;
    double _height = 20;
    if (height != null)
      _height = height;

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: _colorBackgroud,
            borderRadius: new BorderRadius.circular(30),
          ),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
          Container(
                  height: _height,
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(text,
                        style: _textStyle
                    )),
                  ),
          ]),

        ),

      ],
    )
      ;
  }
}