import 'package:flutter/material.dart';

class ILabel extends StatelessWidget {
  final Color color;
  final String text;
  final TextStyle textStyle;
  final Color colorBackgroud;
  final bool border;
  ILabel({this.text, this.color, this.textStyle, this.colorBackgroud, this.border});

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

    Color _colorBorder = _color;
    if (border != null && !border)
      _colorBorder = Colors.transparent;

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: _colorBackgroud,
            border: Border.all(color: _colorBorder),
            borderRadius: new BorderRadius.circular(30),
          ),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
          Container(
                  height: 25,
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  child: Align(
                    alignment : Alignment.center,
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