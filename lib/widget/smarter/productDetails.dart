import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/widget/ibuttonCount.dart';

import 'ibutton3Cart.dart';

sSkinProductDetailsAddToCartButtons(double windowWidth, String price, Function() _tapAddToCart, Function(int count) _onPress) {
  return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          // color: theme.colorPrimary,
          width: windowWidth,
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorBackground,
            // border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(appSettings.radius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(3, 3),
              ),
            ],
          ),

          child: Column(
            children: [
              SizedBox(height: 20,),
              Container(margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                children: [
                  Expanded(child: Text(strings.get(313), style: theme.text16bold,)),  // Quantity
                  IButtonCount(textStyle: theme.text20bold, color: theme.colorPrimary, count: 1, pressButton: _onPress,),
                ],
              )),
              SizedBox(height: 10,),
              Flexible(child: IButton3Cart(text: strings.get(90), text2: price,                           // Add to cart
                color: theme.colorPrimary, pressButton: _tapAddToCart,
                textStyle: theme.text14boldWhite,
              )),
            ],
          )
      )
  );
}