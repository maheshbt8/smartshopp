import 'package:flutter/material.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import '../main.dart';

saleSticker(double width, String discount, String discountprice, String price){
  if (discount.isEmpty)
    return Container();
  var size = width*0.3;
  var margin = size*0.05;
  var radius = 5.0;
  var _boxshadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      spreadRadius: 2,
      blurRadius: 2,
      offset: Offset(3, 3),
    ),
  ];
  return Container(
    margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
    // height: size,
    width: size,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(left: margin, right: margin),
          height: size*0.25,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            boxShadow: _boxshadow,
          ),
          child: Center(child: Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              child: FittedBox(
              child: Text(discount, style: theme.text12bold)))),
        ),
        Container(
          height: size*0.5,
          width: size,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: _boxshadow,
          ),
          child: Center(child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: FittedBox(
                  child: Text(discountprice, style: theme.text14boldWhite)))),
        ),
        Container(
          margin: EdgeInsets.only(left: margin, right: margin),
          height: size*0.25,
          width: size,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            boxShadow: _boxshadow,
          ),
          child: Center(child: Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              child: FittedBox(
                  child: Text(price, style: theme.text12Ubold)))),
        )
      ],
    ),
  );
}

copyrightBlock(Function(String) callback){
  List<Widget> list = [];
  list.add(Text(strings.get(69).toUpperCase(), style: theme.text16bold)); // INFORMATION
  list.add(SizedBox(height: 5,));

  if (appSettings.about == "true" && appSettings.aboutTextName != null && appSettings.aboutTextName.isNotEmpty)
    list.add(copyrightItem(appSettings.aboutTextName, 20, callback));
  if (appSettings.delivery == "true" && appSettings.deliveryTextName != null && appSettings.deliveryTextName.isNotEmpty)
    list.add(copyrightItem(appSettings.deliveryTextName, 21, callback));
  if (appSettings.privacy == "true" && appSettings.privacyTextName != null && appSettings.privacyTextName.isNotEmpty)
    list.add(copyrightItem(appSettings.privacyTextName, 22, callback));
  if (appSettings.terms == "true" && appSettings.termsTextName != null && appSettings.termsTextName.isNotEmpty)
    list.add(copyrightItem(appSettings.termsTextName, 23, callback));
  if (appSettings.refund == "true" && appSettings.refundTextName != null && appSettings.refundTextName.isNotEmpty)
    list.add(copyrightItem(appSettings.refundTextName, 24, callback));

  list.add(SizedBox(height: 10,));
  if (appSettings.copyright == "true" && appSettings.copyrightText != null && appSettings.copyrightText.isNotEmpty)
    list.add(Text(appSettings.copyrightText, style: theme.text14, textAlign: TextAlign.center,));

  return Container(
    margin: EdgeInsets.only(left: 15, right: 15, top: 30),
    child: Column(
      children: list
    )
  );
}

copyrightItem(String text, int id, Function(String) callback){
  return InkWell(
      onTap: () {
        switch(id){
          case 20:   // about
            callback("about");
            break;
          case 21:   // delivery
            callback("delivery");
            break;
          case 22:   // privacy
            callback("privacy");
            break;
          case 23:   // terms
            callback("terms");
            break;
          case 24:   // refund
            callback("refund");
            break;
        }
  },
  child: Container(
    margin: EdgeInsets.only(bottom: 5),
    child: Text(text, style: theme.text14link, textAlign: TextAlign.center)
  ));
}

