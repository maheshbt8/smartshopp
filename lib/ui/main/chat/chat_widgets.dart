import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'iinputField2a.dart';

buttonBackUp(Function callback, double top){
  return Container(
      margin: EdgeInsets.only(left: 15, right: 5, top: top),
      alignment: Alignment.topLeft,
      child: Stack(
        children: <Widget>[
          buttonBack2(),
          Positioned.fill(
            child: Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.black.withAlpha(80),
                  onTap: (){
                    callback();
                  }, // needed
                )),
          )
        ],
      ));
}

buttonBack2(){
  return Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
        color: theme.colorBackground,
        border: Border.all(color: Colors.black.withAlpha(100)),
        borderRadius: new BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(120),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(2, 2), // changes position of shadow
          ),
        ]
    ),
    child: Container(
      margin: (strings.direction == TextDirection.ltr) ? EdgeInsets.only(left: 10) : EdgeInsets.only(right: 10),
      child: Icon(Icons.arrow_back_ios, size: 30, color: Colors.black,),),
  );
}

buttonBack(Function callback){
  return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      alignment: Alignment.bottomLeft,
      child: Stack(
        children: <Widget>[
          buttonBack2(),
          Positioned.fill(
            child: Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.black.withAlpha(80),
                  onTap: (){
                    callback();
                  }, // needed
                )),
          )
        ],
      ));
}

formSearch(Function(String) callback){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      //Container(height: 0.5, color: Colors.black.withAlpha(100),),
      Container(
          height: 40,
          child: IInputField2(
            maxLenght: 30,
            hint: strings.get(34),                                                   // Search
            type: TextInputType.text,
            colorDefaultText: theme.colorDefaultText,
            colorBackground: theme.colorBackground,
            onChangeText: callback,
          )),
      Container(height: 0.5, color: Colors.black.withAlpha(100),),
      SizedBox(height: 3,),
    ],
  );
}
