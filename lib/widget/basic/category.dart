import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping/config/api.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/categories.dart';
import 'package:shopping/model/foods.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/ui/main/mainscreen.dart';
import 'package:shopping/widget/basic/restaurants.dart';
import 'package:shopping/widget/basic/search.dart';
import 'package:shopping/widget/ilist1.dart';
import 'package:shopping/widget/wproducts.dart';
import '../ProductsTileListV2.dart';

bSkinHomeCategory(List<Widget> list, double windowWidth, Function(String id, String heroId, String image) _onCategoriesClick){
  list.add(Container(
    color: appSettings.categoriesTitleColor,
    padding: EdgeInsets.all(10),
    child: ListWithIcon(imageAsset: "assets/categories.png", text: strings.get(268),   // "Food categories",
        imageColor: appSettings.getIconColorByMode(theme.darkMode)),
  ));
  if (appSettings.categoryCardCircle == "true")
    list.add(horizontalCategoriesCircle(windowWidth, _onCategoriesClick));
  else
    list.add(horizontalCategories(windowWidth, _onCategoriesClick));
}

bCategoryDetails(List<Widget> list, double windowWidth, Function (String id, String heroId) callback, Function _onAddToCartClick){
  for (var item in categories) {
    if (item.parent != "0" && item.parent != "-1")
      continue;
    if (categoriesSearchValue != "0" && item.id != categoriesSearchValue)
      continue;
    if (theme.vendor && item.vendor != '0')
      continue;
    var t = categoryDetailsHorizontal(item.id, windowWidth, callback, _onAddToCartClick);
    if (t == null) {
      for (var item2 in categories) {
        if (item2.parent == item.id){
          t = categoryDetailsHorizontal(item2.id, windowWidth, callback, _onAddToCartClick);
          if (t != null)
            break;
        }
      }
      if (t == null)
        continue;
    }

    list.add(Container(
        margin: EdgeInsets.all(10),
        width: windowWidth,
        height: 40,
        child: Row(children: [
          Container(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        UnconstrainedBox(child:
                        Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(),
                        )),
                    imageUrl: item.image,
                    imageBuilder: (context, imageProvider) =>
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    errorWidget: (context, url, error) =>
                    new Icon(Icons.error),
                  ),
                ),
              )),
          SizedBox(width: 10,),
          Text(item.name, style: theme.text14)
        ],)));

    list.add(t);
    //
  }
  list.add(SizedBox(height: 20,));
}

categoryDetailsHorizontal(String categoryId, double windowWidth, Function (String id, String heroId) callback,
    Function _onAddToCartClick){
  List<Widget> list = [];
  list.add(SizedBox(width: 10,));
  var height = windowWidth*appSettings.restaurantCardHeight/100;
  for (var item in foodsAll) {
    if (!isInCityProduct(item,))
      continue;
    if (item.category != categoryId)
      continue;
    if (restaurantSearchValue != "0" && item.restaurant != restaurantSearchValue)
      continue;
    if (categoriesSearchValue != "0" && item.category != categoriesSearchValue)
      continue;
    list.add(ProductsTileListV2(
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
    list.add(SizedBox(width: 10,));
  }
  if (list.length == 1)
    return null;
  return Container(
    color: appSettings.restaurantBackgroundColor,
    height: height+10,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list,
    ),
  );
}