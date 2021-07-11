import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/pref.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/model/topRestourants.dart';
import 'package:fooddelivery/ui/main/home/home.dart';
import 'package:fooddelivery/widget/ilist1.dart';
import 'package:fooddelivery/widget/ipromotion.dart';
import '../ICard20FileCaching.dart';

bHomeTopRestaurants(List<Widget> list, double windowWidth,
    Function (String id, String heroId, String image) _onRestaurantClick) {
  list.add(Container(
      color: appSettings.categoriesTitleColor,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(Icons.assistant_photo, color: appSettings.getIconColorByMode(theme.darkMode),),
          SizedBox(width: 10,),
          Expanded(child: Text(strings.get(200), style: theme.text16bold,))  // "Top Restaurants this week",
        ],
      )
  ));

  List<Restaurants> topRestaurantsWithCity = [];
  for (var item in topRestaurants) {
    if (!isInCity(item,))
      continue;
    topRestaurantsWithCity.add(item);
  }

  list.add(Container(
      color: appSettings.restaurantTitleColor,
      child: IPromotion(topRestaurantsWithCity,
        height: windowWidth * appSettings.topRestaurantCardHeight / 100,
        width: windowWidth * 0.95,
        colorActivy: theme.colorPrimary,
        colorProgressBar: theme.colorPrimary,
        radius: appSettings.radius,
        shadow: appSettings.shadow,
        style: theme.text16boldWhite,
        callback: _onRestaurantClick,
        seconds: 4,
      ))
  );
}

_bNearYourTextAndIconFilter(Function() openFilter){
  return Container(
      color: appSettings.restaurantTitleColor,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Row(
        children: [
          Expanded(child: ListWithIcon(imageAsset: "assets/top.png", text: strings.get(39),    // Restaurants Near Your
              imageColor: appSettings.getIconColorByMode(theme.darkMode))),
          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: UnconstrainedBox(
                    child: Container(
                        height: 30,
                        width: 30,
                        child: Image.asset("assets/filter.png",
                          fit: BoxFit.contain, color: theme.colorDefaultText,
                        )
                    )),
              ),
              Positioned.fill(
                child: Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.grey[400],
                      onTap: (){
                        openFilter();
                      }, // needed
                    )),
              )
            ],
          ),
        ],
      )
  );
}


isInCityProduct(DishesData product, ){
  for (var item in nearYourRestaurants)
    if (product.restaurant == item.id){
      if (item.city.isEmpty)
        return true;
      var cities = item.city.split(',');
      var currentCity = pref.get(Pref.city);
      if (currentCity.isEmpty)
        return true;
      for (var city in cities)
        if (city == currentCity)
          return true;
    }
  return false;
}


isInCity(Restaurants item, ){
  if (item.city.isEmpty)
    return true;
  var cities = item.city.split(',');
  var currentCity = pref.get(Pref.city);
  if (currentCity.isEmpty)
    return true;
  for (var city in cities)
    if (city == currentCity)
      return true;

    return false;
}

bHorizontalTopRestaurants(List<Widget> listOutput, Function() openFilter, int distanceForNearYourFilter, double windowWidth,
    Function(String id, String heroId, String image) _onRestaurantClick, Function (String id) _onTopRestaurantNavigateIconClick) {

  listOutput.add(_bNearYourTextAndIconFilter(openFilter));

  List<Widget> list = [];
  var height = windowWidth*appSettings.restaurantCardHeight/100;
  for (var item in nearYourRestaurants) {
    if (!isInCity(item,))
      continue;
    var _dist = "";
    if (item.distance != -1) {
      if (appSettings.distanceUnit == "km") {
        if (item.distance <= 1000)
          _dist = "${item.distance.toStringAsFixed(0)} m";
        else
          _dist = "${(item.distance / 1000).toStringAsFixed(0)} km";
        dprint("Distance filter: distanceForNearYourFilter=$distanceForNearYourFilter current=${item.distance}=>${item.distance/1000} name=${item.name}");
        if (distanceForNearYourFilter != 0 && item.distance/1000 > distanceForNearYourFilter)
          continue;
      }else{                // miles
        if (item.distance < 1609.34)
          _dist = "${(item.distance/1609.34).toStringAsFixed(3)} miles";
        else
          _dist = "${(item.distance / 1609.34).toStringAsFixed(0)} miles";
        if (distanceForNearYourFilter != 0 && item.distance/1609.34 > distanceForNearYourFilter)
          continue;
      }
    }
    list.add(ICard20FileCaching(
      shadow: appSettings.shadow,
      radius: appSettings.radius,
      color: theme.colorBackground,
      direction: strings.direction,
      colorProgressBar: theme.colorPrimary,
      text: item.name,
      text2: item.address,
      text3: _dist,
      width: windowWidth * appSettings.restaurantCardWidth/100,
      height: height,
      image: item.image,
      colorRoute: theme.colorPrimary,
      id: item.id,
      title: theme.text18boldPrimaryUI,
      body: theme.text16UI,
      callback: _onRestaurantClick,
      callbackNavigateIcon: _onTopRestaurantNavigateIconClick,
    ));
  }
  listOutput.add(Container(
    color: appSettings.restaurantBackgroundColor,
    height: height+10,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list,
    ),
  ));
}

BuildContext _context;

bMapHorizontalRestaurants(double windowWidth, BuildContext context, Function(String id) _onTopRestaurantNavigateIconClick,
          Function(Restaurants rest) _deleteCircle, Function(Restaurants item) _setCircle) {
  _context = context;
  List<Widget> list = [];
  var height = windowWidth*appSettings.restaurantCardHeight/100;
  for (var item in nearYourRestaurants) {
    var _dist = getDistanceText(item);
    list.add(Stack(
      children: [
        ICard20FileCaching(
          shadow: appSettings.shadow,
          radius: appSettings.radius,
          color: theme.colorBackground,
          text: item.name,
          text2: item.address,
          width: windowWidth * appSettings.restaurantCardWidth/100,
          height: height,
          image: item.image,
          text3: _dist,
          colorRoute: theme.colorPrimary,
          id: item.id,
          title: theme.text18boldPrimaryUI,
          body: theme.text16UI,
          callback: onTopRestaurantClick,
          callbackNavigateIcon: _onTopRestaurantNavigateIconClick,
        ),
        Container(
            height: 40,
            margin: EdgeInsets.only(left: 20, right: 10),
            width: windowWidth * appSettings.restaurantCardWidth/100-30,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black.withAlpha(120)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  child: _route(item.id, _onTopRestaurantNavigateIconClick),
                ),
                Checkbox(
                    value: item.areaShowOnMap,
                    activeColor: theme.colorPrimary,
                    onChanged: (bool value){ //
                      item.areaShowOnMap = value;
                      if (value)
                        _setCircle(item);
                      else
                        _deleteCircle(item);
                    }
                ),
                Expanded(
                    child: Text(strings.get(275), style: theme.text14, overflow: TextOverflow.clip,)) // "Show Delivery Area",
              ],)
        ),
      ],
    ));
    list.add(SizedBox(width: 10,));
  }
  return Container(
    height: height+20,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list,
    ),
  );
}

_route(String id, Function(String id) _onTopRestaurantNavigateIconClick){
  return Stack(
    children: <Widget>[
      Image.asset("assets/route.png",
        fit: BoxFit.cover, color: theme.colorPrimary,
      ),
      Positioned.fill(
        child: Material(
            color: Colors.transparent,
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _onTopRestaurantNavigateIconClick(id);
                }
            )),
      )
    ],
  );
}

getDistanceText(Restaurants item){
  var _dist = "";
  if (item.distance != -1) {
    if (appSettings.distanceUnit == "km") {
      if (item.distance <= 1000)
        _dist = "${item.distance.toStringAsFixed(0)} m";
      else
        _dist = "${(item.distance / 1000).toStringAsFixed(0)} km";
    }else{                // miles
      if (item.distance < 1609.34) {
        _dist = "${(item.distance/1609.34).toStringAsFixed(3)} miles";
      }else
        _dist = "${(item.distance / 1609.34).toStringAsFixed(0)} miles";
    }
  }
  return _dist;
}

onTopRestaurantClick(String id, String heroId, String image){
  print("User pressed Top Restaurant with id: $id");
  idHeroes = UniqueKey().toString();
  idRestaurant = id;
  route.setDuration(1);
  route.push(_context, "/restaurantdetails");
}