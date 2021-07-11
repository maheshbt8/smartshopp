import 'package:flutter/material.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/widget/cacheImageWidget.dart';
import 'package:fooddelivery/widget/iList6.dart';
import 'package:fooddelivery/widget/iboxCircle.dart';
import 'package:fooddelivery/widget/iinkwell.dart';
import 'package:fooddelivery/widget/ilist1.dart';

import '../mainscreen.dart';

_extrasImage(String image){
  return Container(
      width: 40,
      height: 40,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: cacheImageWidgetCover(image, theme.colorPrimary)
      )
  );
}

restaurantExtras(List<Widget> list, List<Extras> extras, Function(String id, bool value) _extrasClick) {
  if (extras == null || extras.isEmpty)
    return;

  list.add(Container(
    margin: EdgeInsets.only(left: 20, right: 20),
    child: ListWithIcon(imageAsset: "assets/add.png",
        text: strings.get(89),                // Extras
        imageColor: theme.colorDefaultText),
  ));
  list.add(SizedBox(height: 20,));

  for (var item in extras) {
    list.add(IList6(initState: false,
      leading: _extrasImage("$serverImages${item.image}"),
      title: item.name,
      titleStyle: theme.text18bold,
      subtitle: item.desc,
      text: basket.makePriceString(item.price),
      textStyle: theme.text18boldPrimary,
      id: item.id, callback: _extrasClick,
    ));
  }

  list.add(SizedBox(height: 20,));
}

phone(String restaurantPhone, Function() _callMe){
  if (restaurantPhone.isEmpty)
    return Container();
  return Container(
    margin: EdgeInsets.only(left: 20, right: 20),
    child: Row(
      children: <Widget>[
        Expanded(
            child: Text("${strings.get(106)}: $restaurantPhone", style: theme.text14)
        ),
        IInkWell(child: IBoxCircle(child: _icon()), onPress: _callMe,)
      ],
    ),
  );
}

_icon(){
  String icon = "assets/call.png";
  return Container(
      padding: EdgeInsets.all(5),
      child: UnconstrainedBox(
          child: Container(
              height: 30,
              width: 30,
              child: Image.asset(icon,
                fit: BoxFit.contain, color: Colors.black,
              )
          ))
  );
}

phoneMobile(String restaurantMobilePhone, Function _callMeMobile){
  if (restaurantMobilePhone.isEmpty)
    return Container();

  return Container(
    margin: EdgeInsets.only(left: 20, right: 20),
    child: Row(
      children: <Widget>[
        Expanded(
            child: Text("${strings.get(81)}: $restaurantMobilePhone", style: theme.text14) // "Mobile Phone",
        ),
        IInkWell(child: IBoxCircle(child: _icon()), onPress: _callMeMobile,)
      ],
    ),
  );
}
