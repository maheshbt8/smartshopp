import 'package:flutter/material.dart';

//
// 03.10.2020 v2
// 11.10.2020 radius
//

class ILabelIcon extends StatelessWidget {
  final Color color;
  final String text;
  final TextStyle textStyle;
  final Color colorBackgroud;
  final double height;
  final Icon icon;
  final double radius;

  ILabelIcon({this.text = "", this.color = Colors.grey, this.textStyle, this.colorBackgroud = Colors.transparent, this.height = 20,
    this.icon, this.radius});

  @override
  Widget build(BuildContext context) {
    var _textStyle = TextStyle(fontSize: 16, color: color);
    if (textStyle != null)
      _textStyle = textStyle;

    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
          decoration: BoxDecoration(
            color: colorBackgroud,
            borderRadius: new BorderRadius.circular(radius),
          ),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                    Text(text, style: _textStyle),
                        icon,
                      ],
                    ),
                  ),
      ],
    );
  }
}