import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ICard31FileCaching extends StatefulWidget {
  final int id;
  final Color colorRight;
  final Color colorLeft;
  final String text;
  final TextStyle textStyle;
  final String date;
  final TextStyle dateStyle;
  final Color balloonColor;
  final bool positionLeft;
  final bool delivered;
  final bool read;

  ICard31FileCaching({Key key, this.id = 0, this.colorRight = Colors.grey, this.text = "", this.textStyle,
    this.balloonColor = Colors.black, this.date = "", this.dateStyle, this.colorLeft = Colors.white12,
    this.positionLeft = true, this.delivered = false, this.read = false
  }) : super(key: key);

  @override
  _ICard31FileCachingState createState() {
    return _ICard31FileCachingState();
  }
}

class _ICard31FileCachingState extends State<ICard31FileCaching>{

  @override
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;

    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;
    var position = widget.positionLeft;
    if (isRTL)
      position = !position;

    if (position){      // left
      return Container(
        alignment: Alignment.centerLeft,
        width: windowWidth*0.7,
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            color: widget.colorLeft,
            border: Border.all(color: Colors.grey),
            borderRadius: new BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                width: windowWidth*0.7,
                child: Text(widget.text, style: widget.textStyle, textAlign: TextAlign.start),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                width: windowWidth*0.7,
                child: Text(widget.date, style: widget.dateStyle, textAlign: TextAlign.end,),
              ),
            ],
          ),
        ),
      );
    }else{            // right
      return Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        width: windowWidth*0.7,
        alignment: Alignment.centerRight,
        child: Container(
            decoration: BoxDecoration(
              color: widget.colorRight,
              border: Border.all(color: Colors.grey),
              borderRadius: new BorderRadius.circular(10),
            ),
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              width: windowWidth*0.7,
              child: Text(widget.text, style: widget.textStyle, textAlign: TextAlign.start),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              width: windowWidth*0.7,
              child: Text(widget.date, style: widget.dateStyle, textAlign: TextAlign.end,),
            ),
          ],
        )),
      );
    }
  }
}