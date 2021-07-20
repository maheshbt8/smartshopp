import 'package:flutter/material.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/homescreenModel.dart';

class IButton3Cart extends StatelessWidget {
  @required final Function() pressButton;
  final Color color;
  final String text;
  final String text2;
  final double height;
  final TextStyle textStyle;
  final bool onlyBorder;
  final bool enable;
  IButton3Cart({this.pressButton, this.text = "", this.text2 = "", this.color = Colors.grey,
    this.textStyle, this.height = 45, this.onlyBorder = false, this.enable = true});

  @override
  Widget build(BuildContext context) {
    double radius = appSettings.radius;
    if (theme.appSkin == "smarter")
      radius = 100;
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: (onlyBorder) ? Colors.transparent : color,
          border: (onlyBorder) ? Border.all(color: color) : null,
          borderRadius: new BorderRadius.circular(radius),
        ),
        child: Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          height: height,
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(child: Text(text, style: textStyle, textAlign: TextAlign.start,)),
              Text(text2, style: textStyle, textAlign: TextAlign.start,),
            ],
          ),
        ),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(radius) ),
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  if (pressButton != null && enable)
                    pressButton();
                }, // needed
              )),
        )
      ],
    ));
  }
}