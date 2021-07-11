import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/widget/ilabelWithIcon.dart';
import 'package:fooddelivery/widget/iline.dart';

import '../main.dart';

//
// 14.03.2021 skins
// 03.10.2020 v2
// 11.10.2020 radius
//

class ReviewsText extends StatelessWidget {
  final Color color;
  final String title;
  final String date;
  final String text;
  final String userAvatar;
  final int rating;
  ReviewsText({this.color = Colors.grey, this.text = "", this.title = "",
    this.date = "", this.userAvatar, this.rating = 5,
  });

  @override
  Widget build(BuildContext context) {
    if (theme.appSkin == "smarter")
      return _smarter();

    var _avatar = Container();
    try {
      _avatar = Container(
        width: 30,
        height: 30,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  CircularProgressIndicator(),
              imageUrl: userAvatar,
              imageBuilder: (context, imageProvider) =>
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              errorWidget: (context, url, error) => new Icon(Icons.error, color: theme.colorPrimary,),
            ),
          ),
        ),
      );
    } catch(_){

    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _avatar,
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: theme.text18bold,),
                  Row(
                    children: <Widget>[
                      UnconstrainedBox(
                          child: Container(
                              height: 20,
                              width: 20,
                              child: Image.asset("assets/date.png",
                                  fit: BoxFit.contain
                              )
                          )),
                      SizedBox(width: 10,),
                      Text(date, style: theme.text14grey, textAlign: TextAlign.start,),
                    ],
                  )
                ],
              ),
            ),

              ILabelIcon(radius: appSettings.radius, text: rating.toStringAsFixed(1), color: Colors.white, colorBackgroud: color,
                icon: Icon(Icons.star_border, color: Colors.white,),),

            ],
          ),
          Text(text, style: theme.text16, textAlign: TextAlign.start,),
          ILine(),
        ],
      ),
    );
  }

  _smarter(){
    var _avatar = Container();
    try {
      _avatar = Container(
        width: 45,
        height: 45,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  CircularProgressIndicator(),
              imageUrl: userAvatar,
              imageBuilder: (context, imageProvider) =>
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              errorWidget: (context, url, error) => new Icon(Icons.error, color: theme.colorPrimary,),
            ),
          ),
        ),
      );
    } catch(_){

    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _avatar,
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: theme.text18bold,),
                    Text(date, style: theme.text14grey, textAlign: TextAlign.start,),
                  ],
                ),
              ),

              ILabelIcon(radius: 100, text: rating.toStringAsFixed(1), color: Colors.white, colorBackgroud: color,
                icon: Icon(Icons.star_border, color: Colors.white,),),

            ],
          ),
          SizedBox(height: 10,),
          Text(text, style: theme.text16, textAlign: TextAlign.start,),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}