import 'package:flutter/material.dart';

class IBox extends StatelessWidget {
  @required final Function() press;
  final Widget child;
  final Color color;
  final double radius;
  final double blur;
  IBox({this.color = Colors.white, this.press, this.child, this.radius = 6, this.blur = 6});

  @override
  Widget build(BuildContext context) {
    Widget _child = Container();
    if (child != null)
      _child = child;
    return
      Container(
        margin: EdgeInsets.all(5),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
                color: color,
                child: _child
            )),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(40),
              spreadRadius: radius,
              blurRadius: blur,
              offset: Offset(2, 2), // changes position of shadow
            ),
          ],
        ),

      );
  }
}