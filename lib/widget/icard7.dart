import 'package:flutter/material.dart';

class ICard7 extends StatelessWidget {
  final Color color;
  final String title;
  final String body;

  final TextStyle titleStyle;
  final TextStyle bodyStyle;
  ICard7({this.title, this.body, this.color, this.titleStyle, this.bodyStyle});

  @override
  Widget build(BuildContext context) {
    Color _color = Colors.grey;
    if (color != null)
      _color = color;
    var _titleStyle = TextStyle(fontSize: 16);
    if (titleStyle != null)
      _titleStyle = titleStyle;
    var _bodyStyle = TextStyle(fontSize: 16);
    if (bodyStyle != null)
      _bodyStyle = bodyStyle;


    String _title = "";
    if (title != null)
      _title = title;
    String _body = "";
    if (body != null)
      _body = body;

    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
        decoration: BoxDecoration(
          color: _color.withAlpha(30),
          borderRadius: new BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(3, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(_title,
                  overflow: TextOverflow.clip,
                  style: _titleStyle,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.all(10),
              child: Text(_body,
                overflow: TextOverflow.clip,
                style: _bodyStyle,
              ),
            ),

          ],
        )
    );
  }
}