import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/widget/basic/account.dart';
import 'package:fooddelivery/widget/basic/header.dart';
import 'package:fooddelivery/widget/basic/menu.dart';
import 'package:fooddelivery/widget/basic/productDetails.dart';
import 'package:fooddelivery/widget/basic/wait.dart';
import 'package:fooddelivery/widget/smarter/account.dart';
import 'package:fooddelivery/widget/smarter/category.dart';
import 'package:fooddelivery/widget/smarter/header.dart';
import 'package:fooddelivery/widget/smarter/menu.dart';
import 'package:fooddelivery/widget/smarter/order.dart';
import 'package:fooddelivery/widget/smarter/productDetails.dart';
import 'package:fooddelivery/widget/smarter/restaurants.dart';
import 'package:fooddelivery/widget/smarter/rproducts.dart';
import 'package:fooddelivery/widget/smarter/search.dart';
import 'package:fooddelivery/widget/smarter/wait.dart';
import 'basic/category.dart';
import 'basic/order.dart';
import 'basic/restaurants.dart';
import 'basic/search.dart';

//////////////////////////////////////
//
// MENU
// HEADER
// ORDERS CARD
// WAIT
// HOME SCREEN - SEARCH
// HOME SCREEN - CATEGORY
// HOME SCREEN - TOP RESTAURANTS
// HOME SCREEN - NEAR YOU RESTAURANTS
// ACCOUNT
//
//////////////////////////////////////

//
//  MENU
//
skinMenuItem(int id, String name, BuildContext context, Function(int) _onMenuClickItem){
  if (theme.appSkin == "basic") {
    var imageAsset = "";
    switch(id){
      case 1: imageAsset = "assets/home.png"; break;
      case 3: imageAsset = "assets/prod.png"; break;
      case 4: imageAsset = "assets/heart.png"; break;
      case 13: imageAsset = "assets/wallet.png"; break;
      case 2: imageAsset = "assets/notifyicon.png"; break;
      case 12: imageAsset = "assets/chat.png"; break;
      case 8: imageAsset = "assets/settings.png"; break;
      case 9: imageAsset = "assets/language.png"; break;
      case 7: imageAsset = "assets/help.png"; break;
      case 11: imageAsset = "assets/signout.png"; break;
      case 30: imageAsset = "assets/share.png"; break;
      case 31: imageAsset = "assets/city.png"; break;
      default: imageAsset = "assets/doc.png";
    }
    return bMenuItem(id, name, imageAsset, context, _onMenuClickItem);
  }
  if (theme.appSkin == "smarter") {
    IconData iconData;
    switch(id){
      case 1: iconData = Icons.home_filled; break;
      case 3: iconData = Icons.add_shopping_cart; break;
      case 4: iconData = Icons.favorite; break;
      case 13: iconData = Icons.wallet_membership; break;
      case 2: iconData = Icons.notifications; break;
      case 12: iconData = Icons.chat; break;
      case 8: iconData = Icons.settings; break;
      case 9: iconData = Icons.language; break;
      case 7: iconData = Icons.help; break;
      case 11: iconData = Icons.exit_to_app; break;
      case 30: iconData = Icons.share; break;
      case 31: iconData = Icons.location_city; break;
      default: iconData = Icons.list_alt;
    }
    return sMenuItem(id, name, iconData, context, _onMenuClickItem);
  }
}

skinMenuTitle(BuildContext context){
  if (theme.appSkin == "basic")
    return bMenuTitle(context);
  if (theme.appSkin == "smarter")
    return sMenuTitle(context);
}
//
////////////////////////////////////////////////////////////////////////////////

//
// HEADER
//
skinHeader(var context, Function(String) callback, String title){
  if (theme.appSkin == "basic")
    return bHeaderWidget(context, callback, theme.colorDefaultText, title);
  if (theme.appSkin == "smarter")
    return sHeaderWidget(context, callback, theme.sDarkBlueColor, title);
}

// only main screen
skinHeaderMenu(var context, Function(String) callback, String title){
  if (theme.appSkin == "basic")
    return bHeaderMenuWidget(context, callback, theme.colorDefaultText, title);
  if (theme.appSkin == "smarter")
    return sHeaderMenuWidget(context, callback, theme.sDarkBlueColor, title);
}

// only product details screen
skinHeaderBackButtonWithBasket(var context, Function(String) callback, Color _color){
  if (theme.appSkin == "basic")
    return bHeaderBackButtonWithBasket(context, callback, _color);
  if (theme.appSkin == "smarter")
    return sHeaderBackButtonWithBasket(context, callback, _color);
}

skinHeaderBackButton(var context, Color _color) {
  if (theme.appSkin == "basic")
    return bHeaderBackButton(context, _color);
  if (theme.appSkin == "smarter")
    return sHeaderBackButton(context, _color);
}
//
////////////////////////////////////////////////////////////////////////////////

//
// ORDERS CARD
//
skinOrderCard(String id, Function(String id, String hero) callback,
    double width, double height, String image,
    String text, String text2, String text3, String text4, String text5, String text6,){
  if (theme.appSkin == "basic")
    return bOrderCard(id, callback, width, height, image, text, text2, text3, text4, text5, text6,);
  if (theme.appSkin == "smarter")
    return sOrderCard(id, callback, width, height, image, text, text2, text3, text4, text5, text6,);
}
//
////////////////////////////////////////////////////////////////////////////////


//
// WAIT
//
skinWait(BuildContext context, bool all){
  if (theme.appSkin == "basic")
    return bSkinWait(context, all);
  if (theme.appSkin == "smarter") {
    var windowWidth = MediaQuery.of(context).size.width;
    var windowHeight = MediaQuery.of(context).size.height;
    if (all)
      return Container(
        color: Color(0x80000000),
        width: windowWidth,
        height: windowHeight,
        child: Center(
          child: Loader34(dotType: DotType2.diamond,),
        ),
      );

    return Loader34(dotType: DotType2.diamond,);
  }
}
//
////////////////////////////////////////////////////////////////////////////////

//
// HOME SCREEN - SEARCH
//
skinHomeScreenSearch(List<Widget> list, TextEditingController _searchController, Function() onPressRightIcon,
    Function(String) _onPressSearch, Function() redraw, double windowWidth){
  if (theme.appSkin == "basic")
    return bHomeScreenSearch(list, _searchController, onPressRightIcon, _onPressSearch, redraw, windowWidth);
  if (theme.appSkin == "smarter")
    return sHomeScreenSearch(list, _searchController, onPressRightIcon, _onPressSearch, redraw, windowWidth);
}
//
////////////////////////////////////////////////////////////////////////////////

//
// HOME SCREEN - CATEGORY
//
skinHomeCategory(List<Widget> list, double windowWidth, Function(String id, String heroId, String image) _onCategoriesClick){
  if (theme.appSkin == "basic")
    return bSkinHomeCategory(list, windowWidth, _onCategoriesClick);
  if (theme.appSkin == "smarter")
    return sSkinHomeCategory(list, windowWidth, _onCategoriesClick);
}
//
////////////////////////////////////////////////////////////////////////////////

//
// HOME SCREEN - TOP RESTAURANTS
//
skinHomeTopRestaurants(List<Widget> list, double windowWidth,
    Function (String id, String heroId, String image) _onRestaurantClick){
  if (theme.appSkin == "basic")
    return bHomeTopRestaurants(list, windowWidth, _onRestaurantClick);
  if (theme.appSkin == "smarter")
    sHomeTopRestaurants(list, windowWidth, _onRestaurantClick);
}
//
////////////////////////////////////////////////////////////////////////////////

//
// HOME SCREEN - NEAR YOU RESTAURANTS
//
skinHomeNearYourRestaurants(List<Widget> list, double windowWidth, int distanceForNearYourFilter,
    Function (String id, String heroId, String image) _onRestaurantClick, Function (String id) _onTopRestaurantNavigateIconClick,
    Function() openFilter){
  if (theme.appSkin == "basic")
    bHorizontalTopRestaurants(list, openFilter, distanceForNearYourFilter, windowWidth, _onRestaurantClick, _onTopRestaurantNavigateIconClick);
  if (theme.appSkin == "smarter")
    sHorizontalTopRestaurants(list, openFilter, distanceForNearYourFilter, windowWidth, _onRestaurantClick, _onTopRestaurantNavigateIconClick);
}
//
////////////////////////////////////////////////////////////////////////////////

//
// RESTAURANTS ON MAP
//
skinMapHorizontalRestaurants(double windowWidth, BuildContext context, Function(String id) _onTopRestaurantNavigateIconClick,
    Function(Restaurants rest) _deleteCircle, Function(Restaurants item) _setCircle) {
  if (theme.appSkin == "basic")
    return bMapHorizontalRestaurants(windowWidth, context, _onTopRestaurantNavigateIconClick, _deleteCircle, _setCircle);
  if (theme.appSkin == "smarter")
    return sMapHorizontalRestaurants(windowWidth, context, _onTopRestaurantNavigateIconClick, _deleteCircle, _setCircle);
}
//
////////////////////////////////////////////////////////////////////////////////

//
// ACCOUNT
//
skinAccountHeader1(List<Widget> list, double windowWidth, BuildContext context){
  if (theme.appSkin == "basic")
    return bAccountHeader1(list, windowWidth, context);
  if (theme.appSkin == "smarter")
    return sAccountHeader1(list, windowWidth, context);
}
skinAccountHeader2(double windowWidth, double windowHeight){
  if (theme.appSkin == "basic")
    return bAccountHeader2(windowWidth, windowHeight);
  if (theme.appSkin == "smarter")
    return sAccountHeader2(windowWidth, windowHeight);
}
//
////////////////////////////////////////////////////////////////////////////////

//
// PRODUCT DETAILS
//
skinProductDetailsAddToCartButtons(double windowWidth, String price, Function() _tapAddToCart, Function(int count) _onPress){
  if (theme.appSkin == "basic")
    return bSkinProductDetailsAddToCartButtons(windowWidth, price, _tapAddToCart, _onPress);
  if (theme.appSkin == "smarter")
    return sSkinProductDetailsAddToCartButtons(windowWidth, price, _tapAddToCart, _onPress);
}
skinRProducts(DishesData _this, List<Widget> list, double windowWidth,
    Function (String id, String heroId) callback, Function(String id) _onAddToCartClick){
  //bRProducts(_this, list, windowWidth, callback, _onAddToCartClick);
  sRProducts(_this, list, windowWidth, callback, _onAddToCartClick);
}
//
////////////////////////////////////////////////////////////////////////////////
