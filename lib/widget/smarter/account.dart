
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';

sAccountHeader1(List<Widget> list, double windowWidth, BuildContext context){
  list.add(Container(
    width: windowWidth,
    height: MediaQuery.of(context).padding.top + 40,
    color: theme.colorPrimary,
  ));
}

sAccountHeader2(double windowWidth, double windowHeight) {
  return ClipPath(
      clipper: ClipPathClass90(),
      child: Container(
        width: windowWidth,
        height: windowHeight * 0.3,
        color: theme.colorPrimary,
      ));
}

class ClipPathClass90 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var t = 30.0;
    var path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height-t);
    path.quadraticBezierTo(size.width, size.height, size.width-t, size.height);
    path.lineTo(t, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height-t);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
