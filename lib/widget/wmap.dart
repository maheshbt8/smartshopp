import 'package:flutter/material.dart';

import 'iboxCircle.dart';

buttonMyLocation(Function _getCurrentLocation){
  return Stack(
    children: <Widget>[
      Container(
        height: 60,
        width: 60,
        child: IBoxCircle(child: Icon(Icons.my_location, size: 30, color: Colors.black.withOpacity(0.5),)),
      ),
      Container(
        height: 60,
        width: 60,
        child: Material(
            color: Colors.transparent,
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.grey[400],
              onTap: (){
                _getCurrentLocation();
              }, // needed
            )),
      )
    ],
  );
}

buttonPlus(Function callback){
  return Stack(
    children: <Widget>[
      Container(
        height: 60,
        width: 60,
        child: IBoxCircle(child: Icon(Icons.add, size: 30, color: Colors.black,)),
      ),
      Container(
        height: 60,
        width: 60,
        child: Material(
            color: Colors.transparent,
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.grey[400],
              onTap: callback, // needed
            )),
      )
    ],
  );
}

buttonMinus(Function _onMapMinus){
  return Stack(
    children: <Widget>[
      Container(
        height: 60,
        width: 60,
        child: IBoxCircle(child: Icon(Icons.remove, size: 30, color: Colors.black,)),
      ),
      Container(
        height: 60,
        width: 60,
        child: Material(
            color: Colors.transparent,
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.grey[400],
              onTap: _onMapMinus, // needed
            )),
      )
    ],
  );
}