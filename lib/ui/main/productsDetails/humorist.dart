import 'dart:math' as math;
import 'package:flutter/widgets.dart';

class Humorist extends StatefulWidget {
  final Widget child;
  const Humorist({Key key, this.child}) : super(key: key);
  @override
  _HumoristState createState() => _HumoristState();
}

class _HumoristState extends State<Humorist> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _myAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _myAnimation = Tween(begin: 0.98, end: 1.02).animate(_controller)
      ..addListener(() {
        setState(() {});
      })..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          _controller.reverse();
        else
        if (status == AnimationStatus.dismissed)
          _controller.forward();
      });
    _controller.forward();
    // _controller.repeat();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      child: widget.child,
      transform: Matrix4.rotationZ((_myAnimation.value) * math.pi * 2),
      alignment: Alignment.topCenter,
    );
  }
}