import 'package:flutter/material.dart';

class IList4 extends StatelessWidget {
  final String text;
  final String text2;
  final TextStyle textStyle;
  final TextStyle textStyle2;
  final Function press;
  IList4({this.text = "", this.textStyle, this.text2 = "", this.textStyle2,
      this.press});

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle();
    TextStyle _textStyle2 = TextStyle();
    if (textStyle != null)
      _textStyle = textStyle;
    if (textStyle2 != null)
      _textStyle2 = textStyle2;
    return Stack(
      children: <Widget>[
        _child(_textStyle, _textStyle2),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  if (press != null)
                    press();
                }, // needed
              )),
        )
      ],
    );
  }

  _child(TextStyle _textStyle, TextStyle _textStyle2){
    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Text(text, style: _textStyle,),
        ),
        SizedBox(width: 10,),
        Text(text2, style: _textStyle2,),
      ],
    ));
  }
}