
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';

bAccountHeader1(List<Widget> list, double windowWidth, BuildContext context){
  list.add(Container(
    width: windowWidth,
    height: MediaQuery.of(context).padding.top + 40,
    color: theme.colorBackground,
  ));
}

bAccountHeader2(double windowWidth, double windowHeight){
  return Container(
        width: windowWidth,
        height: windowHeight*0.3,
      );
}

