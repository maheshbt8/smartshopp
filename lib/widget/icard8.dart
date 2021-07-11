import 'package:flutter/material.dart';

class ICard8 extends StatelessWidget {
  final Color color;
  final Color colorBackground;
  final Widget child;
  final Widget child2;


  ICard8({this.color, this.colorBackground,
    this.child, this.child2});

  @override
  Widget build(BuildContext context) {
    Widget _child = Container();
    if (child != null)
      _child = child;
    Widget _child2 = Container();
    if (child2 != null)
      _child2 = child2;
    Color _color = Colors.grey;
    if (color != null)
      _color = color;
    Color _colorBackground = Colors.grey;
    if (colorBackground != null)
      _colorBackground = colorBackground;

    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Stack(
          children: <Widget>[

            Positioned.fill(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        margin: EdgeInsets.only(left: 30, right: 30, bottom: 10),
                        decoration: BoxDecoration(
                          color: _colorBackground,
                          border: Border.all(color: _colorBackground),
                          borderRadius: new BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                            ),
                            _child2,
                          ],
                        )
                    ))),

            Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 35),
              decoration: BoxDecoration(
                color: _color,
                borderRadius: new BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: Stack(
                children: <Widget>[
                  _child
              ],)
              ),

          ],
        )
    );
  }
}
