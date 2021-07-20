import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping/widget/istars.dart';

class ICard10FileCaching extends StatefulWidget {
  final Color color;
  final Color colorProgressBar;
  final double width;
  final double height;
  final String text;
  final String text2;
  final String image;
  final int stars;
  final Color colorStars;
  final String id;
  final int starsCount;
  final TextStyle title;
  final TextStyle body;
  final Function(String id, String hero) callback;
  final Function(String id) callbackNavigateIcon;

  ICard10FileCaching({this.color = Colors.white, this.width = 100, this.height = 100, this.colorProgressBar = Colors.black,
    this.text = "", this.text2 = "", this.image = "", this.stars = 0, this.colorStars = Colors.black,
    this.id = "", this.starsCount = 0, this.title, this.body, this.callback, this.callbackNavigateIcon,
  });

  @override
  _ICard10FileCachingState createState() => _ICard10FileCachingState();
}

class _ICard10FileCachingState extends State<ICard10FileCaching>{

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
              InkWell(
              onTap: () {
                if (widget.callback != null)
                  widget.callback(widget.id, _id);
              }, // needed
                child: Hero(
                    tag: _id,
                    child: Container(
                      width: widget.width-10,
                      height: widget.height*0.6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        child: Container(
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
                        ),
                      )
                )),

                InkWell(
                onTap: () {
                  if (widget.callback != null)
                    widget.callback(widget.id, _id);
                }, // needed
                child: Container(
                  width: widget.width-80,
                  height: widget.height*0.4-5,
                  margin: EdgeInsets.only(left: 5, right: 5, top: widget.height*0.6+5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.text, style: _titleStyle, overflow: TextOverflow.ellipsis,),
                      Text(widget.text2, style: _bodyStyle, overflow: TextOverflow.ellipsis,),
                      Row(
                        children: <Widget>[
                          IStars(stars: widget.stars, color: widget.colorStars),
                          SizedBox(width: 10,),
                          Text("(${widget.starsCount})", style: _bodyStyle,),
                        ],
                      ),
                    ],
                  ))),

              UnconstrainedBox(
                  child: Container(
                      margin: EdgeInsets.only(left: widget.width-70, top: widget.height-55),
                      height: 40,
                      width: 40,
                      child: _route()
                  )),


            ],
          ),


    );
  }

  _route(){
    return Stack(
      children: <Widget>[
        Image.asset("assets/route.png",
          fit: BoxFit.cover, color: widget.colorStars,
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