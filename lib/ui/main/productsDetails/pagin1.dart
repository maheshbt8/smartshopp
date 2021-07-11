import 'package:flutter/material.dart';

pagination1(var pages, var select, Color color){
  List<Widget> list = [];
  for (var i = 0; i < pages; i++) {
    if (i == select){
      list.add(AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.only(right: 4),
        width: 25,
        height: 10,
        decoration: BoxDecoration(
            color: color,
          // border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
        ),
      ),);
    }else {
      list.add(AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.only(right: 4),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
      ),);
    }
  }
  return Container(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: list,
    )
  );
}