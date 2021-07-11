import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/homescreenModel.dart';

class WidgetDetails extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final String price;
  final String image;

  WidgetDetails({this.price = "", this.title = "",
    this.height = 120,  this.width, this.image,
  });

  @override
  WidgetDetailsState createState() {
    return WidgetDetailsState();
  }
}

class WidgetDetailsState extends State<WidgetDetails>{

  Widget _image = Container();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.image != null)
      _image = ClipRRect(
          borderRadius: BorderRadius.circular(appSettings.radius),
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
      ));

    return Container(
      child: _item2(),
    );
  }

  _item2(){
    return Container(
        child: Row(
          children: <Widget>[
            UnconstrainedBox(
              child: Container(
                height: widget.height,
                width: widget.width*0.30,
                child: _image)
            ),
            SizedBox(width: 10,),
            Expanded(child: Container(
                // height: widget.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.title, style: theme.text14bold, maxLines: 3,),                          // title,
                    SizedBox(height: 10,),
                    Text(widget.price, style: theme.text16Companyon,),    // price
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}