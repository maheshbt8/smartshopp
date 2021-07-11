import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/widget/istars.dart';

class ICard13FileCaching extends StatefulWidget {
  final Color color;
  final double width;
  final Color colorProgressBar;
  final double height;
  final String text;
  final String image;
  final String id;
  final TextStyle textStyle;
  final Function(String id, String heroId) callback;
  final int stars;
  final Color colorStars;
  ICard13FileCaching({this.color = Colors.white, this.width = 100, this.height = 100,
    this.text = "", this.image = "", this.stars = 0, this.colorStars = Colors.black,
    this.id = "", this.textStyle, this.callback, this.colorProgressBar = Colors.black,
  });

  @override
  _ICard13FileCachingState createState() => _ICard13FileCachingState();
}

class _ICard13FileCachingState extends State<ICard13FileCaching>{

  var _textStyle = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    var _id = UniqueKey().toString();
    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
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
                  height: widget.height*0.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    child:Container(
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        imageUrl: widget.image,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        errorWidget: (context,url,error) => new Icon(Icons.error),
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
                  height: widget.height*0.4,
                  margin: EdgeInsets.only(left: 5, right: 5, top: widget.height*0.6+5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(widget.text, style: _textStyle, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,),
                      IStars(stars: widget.stars, color: widget.colorStars, mainAxisAlignment: MainAxisAlignment.start),
                    ],
                  ),
                  )),

            ],
          ),
    ));
  }
}