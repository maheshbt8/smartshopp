import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/ibuttonCount.dart';

bSkinProductDetailsAddToCartButtons(double windowWidth, String price, Function() _tapAddToCart, Function(int count) _onPress) {
  return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          color: theme.colorPrimary,
          width: windowWidth,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(child: IButton3(text: strings.get(90),                           // Add to cart
                color: theme.colorPrimary, pressButton: _tapAddToCart,
                textStyle: theme.text14boldWhite,
              )),
              Flexible(
                  child: FittedBox(child: Text(price,
                    style: theme.text20boldWhite,),
                  )),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: IButtonCount(textStyle: theme.text20boldWhite, color: Colors.white, count: 1, pressButton: _onPress,),
              )
            ],
          )
      )
  );
}