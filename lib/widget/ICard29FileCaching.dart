import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ICard29FileCaching extends StatefulWidget {
  final String id;
  final Color color;
  final String title;
  final Color colorProgressBar;
  final TextStyle titleStyle;
  final String text;
  final TextStyle textStyle;
  final String userAvatar;
  final String date;
  final TextStyle dateStyle;
  final Color balloonColor;
  final Function(String) callback;

  ICard29FileCaching({Key key, this.id, this.color = Colors.grey, this.text = "", this.textStyle, this.title = "", this.titleStyle,  this.colorProgressBar = Colors.black,
    this.userAvatar, this.balloonColor = Colors.black,
    this.callback, this.date, this.dateStyle
  }) : super(key: key);

  @override
  _ICard29FileCachingState createState() {
    return _ICard29FileCachingState();
  }
}

class _ICard29FileCachingState extends State<ICard29FileCaching>{

  var _progress = false;
  @override
  Widget build(BuildContext context) {
    var _titleStyle = TextStyle(fontSize: 16);
    if (widget.titleStyle != null)
      _titleStyle = widget.titleStyle;
    var _textStyle = TextStyle(fontSize: 16);
    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
    var _dateStyle = TextStyle(fontSize: 16);
    if (widget.dateStyle != null)
      _dateStyle = widget.dateStyle;

    var _avatar = Container();
    try {
      _avatar = Container(
        width: 40,
        height: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
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
              imageUrl: widget.userAvatar,
              imageBuilder: (context, imageProvider) =>
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
        ),
      );
    } catch(_){

    }

    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;
    var _margin = EdgeInsets.only(right: 60);
    var _align = Alignment.topRight;
    if (isRTL) {
      _margin = EdgeInsets.only(left: 60);
      _align = Alignment.topLeft;
    }

    return Stack(
      children: [
        Container(
            margin: EdgeInsets.only(bottom: 10),
            color: widget.color,
            child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _avatar,
                      SizedBox(width: 20,),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: _margin,
                                child: Row (
                                  children: [
                                    Expanded(child: Text(widget.title, style: _titleStyle, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,)),
                                    Text(widget.date, style: _dateStyle,),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(widget.text, style: _textStyle, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,),
                            ]
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            )),


        Positioned.fill(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
                alignment: _align,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: widget.balloonColor.withOpacity(0.2),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.only(right: 10, top: 10),
                      padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                      child: Stack(
                      children: [
                        Icon(Icons.delete, size: 25, color: widget.balloonColor.withOpacity(0.8)),
                        if (_progress)
                        UnconstrainedBox(child:
                        Container(
                          margin: EdgeInsets.only(top: 3, left: 3),
                          alignment: Alignment.center,
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(backgroundColor: widget.colorProgressBar, ),
                        )),
                      ],
                      ),
                    ),
                    Container(
                        width: 50,
                        height: 50,
                        child: Container(
                          child: Material(
                              color: Colors.transparent,
                              shape: CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                splashColor: Colors.grey[400],
                                onTap: (){
                                  if (widget.callback != null && !_progress) {
                                    setState(() {
                                      _progress = true;
                                    });
                                    widget.callback(widget.id);
                                  }
                                }, // needed
                              )),)
                    )
                  ],
                )
            )),

      ],
    );
  }
}