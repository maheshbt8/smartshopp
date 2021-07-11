import 'package:flutter/material.dart';

class IList2 extends StatelessWidget {
  final String imageAsset;
  final String text;
  final TextStyle textStyle;
  final Color imageColor;
  final Widget child1;
  final Widget child2;
  IList2({this.imageAsset, this.text, this.textStyle, this.imageColor, this.child1, this.child2});

  @override
  Widget build(BuildContext context) {
    Widget _child1 = Container();
    if (child1 != null)
      _child1 = child1;
    Widget _child2 = Container();
    if (child2 != null)
      _child2 = child2;
    Widget _imageAsset = Container();
    if (imageAsset != null)
      _imageAsset = Image.asset(imageAsset,
          fit: BoxFit.contain, color: imageColor,);
    String _text = "";
    if (text != null)
      _text = text;
    TextStyle _textStyle = TextStyle();
    if (textStyle != null)
      _textStyle = textStyle;

    return Row(children: <Widget>[
      UnconstrainedBox(
          child: Container(
              height: 25,
              width: 25,
              child: _imageAsset
          )),
      SizedBox(width: 10,),
      Expanded(
        child: Text(_text, style: _textStyle,),
      ),
      _child1,
      SizedBox(width: 10,),
      _child2,
    ],
    );
  }
}