import 'package:flutter/material.dart';
import 'package:fooddelivery/widget/ilabel2.dart';

class ICard11 extends StatefulWidget {
  final Color color;
  final Color colorLabel;
  final double width;
  final double height;
  final String text;
  final String text2;
  final String image;
  final String id;
  final String textInLabel;
  final TextStyle title;
  final TextStyle body;
  final Function(String id, String hero) callback;

  ICard11({this.color = Colors.white, this.width = 100, this.height = 100,
    this.text = "", this.text2 = "", this.image = "", this.textInLabel = "", this.colorLabel = Colors.black,
    this.id = "", this.title, this.body, this.callback,
  });

  @override
  _ICard11State createState() => _ICard11State();
}

class _ICard11State extends State<ICard11>{

  var _titleStyle = TextStyle(fontSize: 16);
  var _bodyStyle = TextStyle(fontSize: 14);

  @override
  Widget build(BuildContext context) {
    var _id = UniqueKey().toString();
    if (widget.title != null)
      _titleStyle = widget.title;
    if (widget.body != null)
      _bodyStyle = widget.body;
    return InkWell(
        onTap: () {
          if (widget.callback != null)
            widget.callback(widget.id, _id);
        }, // needed
        child: Container(
          margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          width: widget.width-10,
          height: widget.height-20,
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: new BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(100),
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
                      width: widget.width-10,
                      height: widget.height*0.7,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        child:Container(
                          child: Image.asset(widget.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
              ),

              InkWell(
                  onTap: () {
                    if (widget.callback != null)
                      widget.callback(widget.id, _id);
                  }, // needed
                  child: Container(
                      width: widget.width,
                      height: widget.height*0.4,
                      margin: EdgeInsets.only(left: 5, right: 5, top: widget.height*0.6+10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.text, style: _titleStyle, overflow: TextOverflow.ellipsis,),
                          Text(widget.text2, style: _bodyStyle, overflow: TextOverflow.ellipsis,),
                        ],
                      ))),

              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(right: 5, top: 5),
                  child: ILabel2(text: "${widget.textInLabel}", color: Colors.white, colorBackgroud: widget.colorLabel),
                ),
              )

            ],
          ),
        ));
  }
}