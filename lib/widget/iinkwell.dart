import 'package:flutter/material.dart';

class IInkWell extends StatelessWidget {
  @required final Function() onPress;
  @required final Widget child;
  IInkWell({this.onPress, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                    onPress();
                }, // needed
              )),
        )
      ],
    );
  }
}