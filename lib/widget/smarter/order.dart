import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/homescreenModel.dart';

sOrderCard(String id, Function(String id, String hero) callback,
  double width, double height, String image,
  String text, String text2, String text3, String text4, String text5, String text6,)
{
  var _id = UniqueKey().toString();
  return InkWell(
      onTap: () {
          callback(id, _id);
      }, // needed
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(top: 30, bottom: 15),
            width: width-10,
            decoration: BoxDecoration(
                color: theme.colorBackground,
                border: Border.all(color: Color(0xfffafafa)),
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
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(children: [
                      Expanded(child: Text(text, style: theme.text16bold, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)),  // name
                      Text(text4, style: theme.text16bold, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)
                    ],),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text(text2, style: theme.text14, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,),
                        Expanded(child: Text(text3, style: theme.text14, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,)),
                        Text(text5, style: theme.text18boldPrimary, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,),
                      ],
                    ),
                  ],
                ),
              ),
          ),
          Container(
              child: Text(text6, style: theme.text14boldWhite, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
              margin: EdgeInsets.only(left: 10),
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            decoration: BoxDecoration(
              color: theme.colorPrimary,
              borderRadius: BorderRadius.circular(100),
            ),

          ),
        ],
      ));
}
