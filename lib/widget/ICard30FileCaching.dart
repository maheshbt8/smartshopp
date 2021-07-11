import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// 11.10.2020 radius and shadow

class ICard30FileCaching extends StatefulWidget {
  final Color color;
  final Color colorProgressBar;
  final double width;
  final double height;
  final String text;
  final String image;
  final String id;
  final TextStyle textStyle;
  final Function(String id, String hero, String image) callback;
  final double radius;
  final int shadow;

  ICard30FileCaching({this.color = Colors.white, this.width = 100, this.height = 100,
    this.text = "", this.image = "", this.colorProgressBar = Colors.black,
    this.id = "", this.textStyle, this.callback,
    this.radius, this.shadow,
  });

  @override
  _ICard30FileCachingState createState() => _ICard30FileCachingState();
}

class _ICard30FileCachingState extends State<ICard30FileCaching>{

  var _textStyle = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    var _id = UniqueKey().toString();
    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
    return InkWell(
        onTap: () {
      if (widget.callback != null)
        widget.callback(widget.id, _id, widget.image);
    }, // needed
    child: Container(
          padding: EdgeInsets.all(5),
          width: widget.width-10,
          height: widget.height-10,
          child: Column(
            children: <Widget>[
              Expanded(child: Hero(
              tag: _id,
                child: OverflowBox(
                    minWidth: widget.width-20,
                    minHeight: widget.width-20,
                    maxWidth: widget.width-20,
                    maxHeight: widget.width-20,
                    child: Container(
                    width: widget.width-20,
                    height: widget.width-20,
                    decoration: BoxDecoration(
                        //shape: BoxShape.circle,
                        color: widget.color,
                        border: Border.all(color: Colors.black.withAlpha(100)),
                        borderRadius: new BorderRadius.circular(widget.width/2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(widget.shadow),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(2, 2), // changes position of shadow
                          ),
                        ]
                    ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.width/2),
                    child: Container(

                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            UnconstrainedBox(child:
                            Container(
                              alignment: Alignment.center,
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(),
                            )),
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
                    ),                  )
                )))),

                InkWell(
                onTap: () {
                  if (widget.callback != null)
                    widget.callback(widget.id, _id, widget.image);
                }, // needed
                child: Container(
                  width: widget.width,
                  padding: EdgeInsets.all(3),
                  //height: widget.height*0.2,
                  //margin: EdgeInsets.only(left: 5, right: 5, top: widget.height*0.8+5),
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(widget.text, style: _textStyle, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, maxLines: 2,)),
                  )),

            ],
          ),
    ));
  }
}