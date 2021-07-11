import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ICard27 extends StatelessWidget {
  final Color colorActive;
  final Color colorInactive;
  final int stage;
  final List<IconData> icons;
  ICard27({this.colorActive = Colors.black, this.colorInactive = Colors.grey, this.stage = 1, this.icons});

  var width = 3.0;
  var radius = 4.0;

  _dot(int count){
    return Container(
      margin: EdgeInsets.only(left: width, right: width),
      width: radius,
      child: Container(
        decoration: BoxDecoration(
          color: (stage >= count+1) ? colorActive : colorInactive,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    int count = 1;
    for (var item in icons){
      list.add(Icon(
        item,
        color: (stage >= count) ? colorActive : colorInactive,
        size: 25,
      ),);
      if (count < icons.length) {
        list.add(SizedBox(width: 5,));
        list.add(_dot(count));
        list.add(_dot(count));
        list.add(_dot(count));
        list.add(SizedBox(width: 5,));
      }
      count++;
    }
    return Container(
        height: 100,
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list)
    );
  }
}