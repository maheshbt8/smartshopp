import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/homescreenModel.dart';

import '../cacheImageWidget.dart';

bOrderCard(String id, Function(String id, String hero) callback,
  double width, double height, String image,
  String text, String text2, String text3, String text4, String text5, String text6,)
{
  var _id = UniqueKey().toString();
  return InkWell(
      onTap: () {
          callback(id, _id);
      }, // needed
      child: Container(
        width: width-10,
        height: height-20,
        decoration: BoxDecoration(
            color: theme.colorBackground,
            borderRadius: new BorderRadius.circular(appSettings.radius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(appSettings.shadow),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(2, 2), // changes position of shadow
              ),
            ]
        ),
        child: Row(
          children: <Widget>[
            Hero(
                tag: _id,
                child: Container(
                  width: width*0.3,
                  height: height,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(appSettings.radius), bottomLeft: Radius.circular(appSettings.radius)),
                      child: cacheImageWidgetCover(image, theme.colorPrimary)
                  ),
                )
            ),
            SizedBox(width: 10,),
            InkWell(
                onTap: () {
                    callback(id, _id);
                }, // needed
                child: Container(
                  width: width*0.6,
                  height: height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: 5,),
                      Row(children: [
                        Expanded(child: Text(text, style: theme.text16bold, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)),  // name
                        Text(text5, style: theme.text16bold, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)
                      ],),
                      Text(text2, style: theme.text14, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,),
                      Text(text3, style: theme.text14, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,),
                      Row(children: [
                        Expanded(child: Text(text6, style: theme.text16Companyon, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)),  // name
                        Text(text4, style: theme.text18boldPrimary, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,),
                      ],),
                      SizedBox(height: 5,)
                    ],
                  ),
                )),

          ],
        ),
      ));
}
