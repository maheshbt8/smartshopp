import 'package:flutter/material.dart';

class IButton4 extends StatelessWidget {
  @required final Function() pressButton;
  final Color color;
  final String text;
  final String icon;
  final double height;
  final TextStyle textStyle;
  final bool onlyBorder;
  IButton4({this.pressButton, this.text = "", this.color = Colors.grey, this.textStyle, this.height = 45,
    this.onlyBorder = false, this.icon = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: (onlyBorder) ? Colors.transparent : color,
          border: (onlyBorder) ? Border.all(color: color) : null,
          borderRadius: new BorderRadius.circular(5),
        ),
        child: Stack(children: [
            Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Container(
                  width: 60,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(100),
                      border: (onlyBorder) ? Border.all(color: color) : null,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                    ),
                    child: UnconstrainedBox(
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset(icon,
                            fit: BoxFit.contain
                        )
                    ))),
                Expanded(
                child: Text(text, style: textStyle, textAlign: TextAlign.center,),
                ),
            ],
          )),

          Positioned.fill(
            child: Material(
                color: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.0) ),
                child: InkWell(
                  splashColor: Colors.grey[400],
                  onTap: (){
                    if (pressButton != null)
                      pressButton();
                  }, // needed
                )),
          )
        ],)
    );
  }
}