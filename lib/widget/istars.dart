import 'package:flutter/material.dart';

class IStars extends StatelessWidget {
  final int stars;
  final Color color;
  final MainAxisAlignment mainAxisAlignment;
  IStars({this.stars, this.mainAxisAlignment, this.color});

  @override
  Widget build(BuildContext context) {

    var _mainAxisAlignment = MainAxisAlignment.center;
    if (mainAxisAlignment != null)
      _mainAxisAlignment = mainAxisAlignment;
    var _color = Colors.black;
    if (color != null)
      _color = color;

    List<Widget> list = [];

    var good = Icon(Icons.star, color: _color, size: 15);
    var bad = Icon(Icons.star_border, color: _color, size: 15);

    if (stars != null) {
      if (stars >= 1)
        list.add(good);
      else
        list.add(bad);
      if (stars >= 2)
        list.add(good);
      else
        list.add(bad);
      if (stars >= 3)
        list.add(good);
      else
        list.add(bad);
      if (stars >= 4)
        list.add(good);
      else
        list.add(bad);
      if (stars >= 5)
        list.add(good);
      else
        list.add(bad);
    }

    return Row(
        mainAxisAlignment: _mainAxisAlignment,
        children: list);
  }
}