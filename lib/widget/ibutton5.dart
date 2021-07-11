import 'package:flutter/material.dart';

class IButton5 extends StatelessWidget {
  final Color color;
  final String text;
  final String icon;
  final double height;
  final TextStyle textStyle;
  final bool onlyBorder;
  IButton5({this.text = "", this.color = Colors.grey, this.textStyle, this.height = 45,
    this.onlyBorder = false, this.icon = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: (onlyBorder) ? Colors.transparent : color,
          border: (onlyBorder) ? Border.all(color: color) : null,
          borderRadius: new BorderRadius.circular(5),
        ),
        child: Container(
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(100),
            border: (onlyBorder) ? Border.all(color: color) : null,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
          ),
          child: UnconstrainedBox(
          child: Container(
              height: 20,
              width: 20,
              child: Image.asset(icon,
                  fit: BoxFit.contain
              )
          ))),
    );
  }
}