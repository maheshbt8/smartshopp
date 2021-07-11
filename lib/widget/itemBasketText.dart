import 'package:flutter/material.dart';

import '../main.dart';

itemBasketText(String leftText, String rightText, bool bold){
  var _style = theme.text14;
  if (bold)
    _style = theme.text14bold;
  return Container(
    margin: EdgeInsets.only(left: 20, right: 20),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Text(leftText, style: _style,),
        ),
        Text(rightText, style: _style,),
      ],
    ),
  );
}