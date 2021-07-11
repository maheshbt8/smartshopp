import 'package:flutter/material.dart';

class IBoxCircle extends StatelessWidget {
  @required final Function() press;
  final Widget child;
  final Color color;
  IBoxCircle({this.color = Colors.white, this.press, this.child});

  @override
  Widget build(BuildContext context) {
    Widget _child = Container();
    if (child != null)
      _child = child;
    return
      Container(
        margin: EdgeInsets.all(5),
        child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(40),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ],
            ),
            child: Container(
//              margin: EdgeInsets.only(left: 10),
                child: _child)
        ),
      );
  }
}