import 'package:flutter/material.dart';

import 'package:shopping/config/api.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/categories.dart';
import 'package:shopping/model/foods.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/server/mainwindowdata.dart';
import 'package:shopping/ui/main/mainscreen.dart';
import 'package:shopping/widget/ProductsTileList.dart';
import 'package:shopping/widget/ilist1.dart';

bRProducts(DishesData _this, List<Widget> list, double windowWidth,
    Function (String id, String heroId) callback, Function(String id) _onAddToCartClick){

  List<Widget> list2 = [];
  list2.add(SizedBox(width: 10,));
  var height = windowWidth*appSettings.restaurantCardHeight/100;
  for (var product in _this.rproducts) {
    var item = loadFood(product.rp);
    if (item != null){
      list2.add(ProductsTileList(
        needAddToCart: false,
        color: theme.colorBackground,
        text: item.name,
        width: windowWidth*0.6,
        height: height,
        image: "$serverImages${item.image}",
        id: item.id,
        text3: (theme.multiple) ? item.restaurantName : getCategoryName(item.category),
        discount: item.discount,
        discountprice: (item.discountprice != 0) ? basket.makePriceString(item.discountprice) : "",
        price: basket.makePriceString(item.price),
        callback: callback,
        onAddToCartClick: _onAddToCartClick,
      ));
      list2.add(SizedBox(width: 10,));
    }
  }
  if (list2.length == 1)
    return;

  list.add(Container(
    margin: EdgeInsets.only(left: 10, right: 10),
    child: ListWithIcon(imageAsset: "assets/ingredients.png", text: strings.get(296),               // See Also
        imageColor: theme.colorDefaultText),
  ));
  list.add(SizedBox(height: 20,));

  list.add(Container(
    height: height+10,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list2,
    ),
  ));

  list.add(SizedBox(height: 20,));
}
