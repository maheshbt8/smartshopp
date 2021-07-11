import 'package:flutter/material.dart';

class ILine extends StatelessWidget {
  final double margin;
  ILine({this.margin});

  @override
  Widget build(BuildContext context) {
    var _margin = 0.0;
    if (margin != null)
      _margin = margin;

    return Container(
      margin: EdgeInsets.only(left: _margin, right: _margin, top: 10, bottom: 10),
      height: 0.5,
      color: Colors.grey,
    );
  }
}