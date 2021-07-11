import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';

import 'cacheImageWidget.dart';

//
// 02.10.2020 rtl
// 11.10.2020 radius and shadow
// 11.10.2020 callback add string image
//

class ICard20FileCaching extends StatefulWidget {
  final Color color;
  final Color colorProgressBar;
  final TextDirection direction;
  final double width;
  final double height;
  final String text;
  final String text2;
  final String text3;
  final String image;
  final Color colorRoute;
  final String id;
  final TextStyle title;
  final TextStyle body;
  final Function(String id, String hero, String) callback;
  final Function(String id) callbackNavigateIcon;
  final double radius;
  final int shadow;

  ICard20FileCaching({this.color = Colors.white, this.width = 100, this.height = 100, this.colorProgressBar = Colors.black,
    this.text = "", this.text2 = "", this.image = "", this.colorRoute = Colors.black,
    this.id = "", this.title, this.body, this.callback, this.callbackNavigateIcon,
    this.text3 = "", this.direction,
    this.radius, this.shadow,
  });

  @override
  _ICard20FileCachingState createState() => _ICard20FileCachingState();
}

class _ICard20FileCachingState extends State<ICard20FileCaching>{

  var _titleStyle = TextStyle(fontSize: 16);
  var _bodyStyle = TextStyle(fontSize: 14);

  @override
  Widget build(BuildContext context) {
    var _id = UniqueKey().toString();
    if (widget.title != null)
      _titleStyle = widget.title;
    if (widget.body != null)
      _bodyStyle = widget.body;
    return Container(
          margin: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
          width: widget.width-10+2,
          height: widget.height-20,
          decoration: BoxDecoration(
              color: widget.color,
              border: Border.all(color: Colors.black.withAlpha(100)),
              borderRadius: new BorderRadius.circular(widget.radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(widget.shadow),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ]
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Expanded( child: InkWell(
                      onTap: () {
                        if (widget.callback != null)
                          widget.callback(widget.id, _id, widget.image);
                      }, // needed
                      child: Hero(
                          tag: _id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(widget.radius), topRight: Radius.circular(widget.radius)),
                            child: Container(
                            width: widget.width-10,
                            height: widget.height-20,
                              child: cacheImageWidgetCover(widget.image, theme.colorPrimary)
                            ),
                          )))),

                  InkWell(
                      onTap: () {
                        if (widget.callback != null)
                          widget.callback(widget.id, _id, widget.image);
                      }, // needed
                      child: Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.text, style: _titleStyle, overflow: TextOverflow.ellipsis,),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                Container(
                                width: widget.width-50,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                    Text(widget.text2, maxLines: 1, style: _bodyStyle, overflow: TextOverflow.ellipsis,),
                                    Text(widget.text3, style: _bodyStyle, overflow: TextOverflow.ellipsis,),
                                  ],)),
                                  Container(
                                      height: 30,
                                      width: 30,
                                      child: _route()
                                  ),

                                ],
                      ),
                              SizedBox(height: 5,)
                            ],
                          ))),

                ],
              ),

            ],
          )

    );
  }

  _route(){
    return Stack(
      children: <Widget>[
        Image.asset("assets/route.png",
          fit: BoxFit.cover, color: widget.colorRoute,
        ),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  if (widget.callbackNavigateIcon != null)
                    widget.callbackNavigateIcon(widget.id);
                }, // needed
              )),
        )
      ],
    );
  }
}