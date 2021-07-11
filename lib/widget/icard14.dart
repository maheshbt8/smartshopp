import 'package:flutter/material.dart';

class ICard14 extends StatefulWidget {
  final Color color;
  final double width;
  final double height;
  final String image;
  final String id;
  final Function(String id, String hero) callback;
  final String text;
  final TextStyle textStyle;
  final String text2;
  final TextStyle textStyle2;
  final String text3;
  final TextStyle textStyle3;
  final String text4;
  final TextStyle textStyle4;
  final String heroId;
  ICard14({this.color = Colors.white, this.width = 100, this.height = 100,
    this.id = "", this.callback, this.image = "",
    this.text = "",this.textStyle,
    this.text2 = "", this.textStyle2,
    this.text3 = "", this.textStyle3,
    this.text4 = "", this.textStyle4,
    this.heroId
  });

  @override
  _ICard14State createState() => _ICard14State();
}

class _ICard14State extends State<ICard14>{

  var _textStyle = TextStyle(fontSize: 16);
  var _textStyle2 = TextStyle(fontSize: 16);
  var _textStyle3 = TextStyle(fontSize: 16);
  var _textStyle4 = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    var _id = widget.heroId == null ? UniqueKey().toString() : widget.heroId;
    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
    if (widget.textStyle2 != null)
      _textStyle2 = widget.textStyle2;
    if (widget.textStyle3 != null)
      _textStyle3 = widget.textStyle3;
    if (widget.textStyle4 != null)
      _textStyle4 = widget.textStyle4;
    return InkWell(
        onTap: () {
          if (widget.callback != null)
            widget.callback(widget.id, _id);
        }, // needed
        child: Container(
          margin: EdgeInsets.only(left: 0, top: 10, bottom: 10),
          width: widget.width-10,
          height: widget.height-20,
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: new BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(40),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ]
          ),
          child: Stack(
            children: <Widget>[
              Hero(
                  tag: _id,
                  child: Container(
                      width: widget.width*0.3,
                      height: widget.height,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                        child:Container(
                          child: Image.asset(widget.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                  )),

              InkWell(
                  onTap: () {
                    if (widget.callback != null)
                      widget.callback(widget.id, _id);
                  }, // needed
                  child: Container(
                    width: widget.width,
                    height: widget.height,
                    margin: EdgeInsets.only(top: 5, left: widget.width*0.3+5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(height: 5,),
                        Text(widget.text, style: _textStyle, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,),
                        Text(widget.text2, style: _textStyle2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,),
                        Text(widget.text3, style: _textStyle3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Text(widget.text4, style: _textStyle4, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right,),
                            )
                        ),
                        SizedBox(height: 5,)
                      ],
                    ),
                  )),

            ],
          ),
        ));
  }
}