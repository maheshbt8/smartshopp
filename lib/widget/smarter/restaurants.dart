import 'package:flutter/material.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/server/mainwindowdata.dart';
import 'package:shopping/model/topRestourants.dart';
import 'package:shopping/ui/main/home/home.dart';
import 'package:shopping/widget/basic/restaurants.dart';
import 'package:shopping/widget/ilist1.dart';
import 'package:shopping/widget/smarter/ipromotions.dart';
import '../cacheImageWidget.dart';

sHomeTopRestaurants(List<Widget> list, double windowWidth,
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
      child: IPromotionSmart(topRestaurantsWithCity,
        height: windowWidth * appSettings.topRestaurantCardHeight / 100,
        width: windowWidth * 0.95,
        colorActivy: theme.colorPrimary,
        colorProgressBar: theme.colorPrimary,
        radius: appSettings.radius,
        shadow: appSettings.shadow,
        style: theme.text16bold,
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
              icon: Icons.location_city,
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

sHorizontalTopRestaurants(List<Widget> listOutput, Function() openFilter, int distanceForNearYourFilter, double windowWidth,
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
    list.add(ICard20FileCachingSmart(
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



class ICard20FileCachingSmart extends StatefulWidget {
  final Color color;
  final Color colorProgressBar;
  final TextDirection direction;
  final double width;
  final double height;
  final String text;
  final String text2;
  final String text3;
  final String image;
  final Color colorRoute;
  final String id;
  final TextStyle title;
  final TextStyle body;
  final Function(String id, String hero, String) callback;
  final Function(String id) callbackNavigateIcon;
  final double radius;
  final int shadow;

  ICard20FileCachingSmart({this.color = Colors.white, this.width = 100, this.height = 100, this.colorProgressBar = Colors.black,
    this.text = "", this.text2 = "", this.image = "", this.colorRoute = Colors.black,
    this.id = "", this.title, this.body, this.callback, this.callbackNavigateIcon,
    this.text3 = "", this.direction,
    this.radius, this.shadow,
  });

  @override
  _ICard20FileCachingSmartState createState() => _ICard20FileCachingSmartState();
}

class _ICard20FileCachingSmartState extends State<ICard20FileCachingSmart>{

  var _titleStyle = TextStyle(fontSize: 16);
  var _bodyStyle = TextStyle(fontSize: 14);

  @override
  Widget build(BuildContext context) {
    var _id = UniqueKey().toString();
    if (widget.title != null)
      _titleStyle = widget.title;
    if (widget.body != null)
      _bodyStyle = widget.body;
    return Container(
        margin: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
        width: widget.width-10+2,
        height: widget.height-20,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Expanded( child: InkWell(
                    onTap: () {
                      if (widget.callback != null)
                        widget.callback(widget.id, _id, widget.image);
                    }, // needed
                    child: Hero(
                      tag: _id,
                      child: Container(
                          width: widget.width-10,
                          height: widget.height-20,
                          decoration: BoxDecoration(
                              color: widget.color,
                              borderRadius: new BorderRadius.circular(widget.radius),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withAlpha(widget.shadow+20),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(2, 2), // changes position of shadow
                                ),
                              ]
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(widget.radius), topRight: Radius.circular(widget.radius),
                                  bottomLeft: Radius.circular(widget.radius), bottomRight: Radius.circular(widget.radius)),
                              child: cacheImageWidgetCover(widget.image, theme.colorPrimary)
                          )
                      ),
                    ))),

                InkWell(
                    onTap: () {
                      if (widget.callback != null)
                        widget.callback(widget.id, _id, widget.image);
                    }, // needed
                    child: Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(widget.text, style: _titleStyle, overflow: TextOverflow.ellipsis,),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                  Expanded(child: Text(widget.text2, maxLines: 1, style: _bodyStyle, overflow: TextOverflow.ellipsis,)),
                                  Text(widget.text3, style: _bodyStyle, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,),
                              ],
                            ),
                          ],
                        ))),

              ],
            ),

          ],
        )

    );
  }
}

BuildContext _context;

sMapHorizontalRestaurants(double windowWidth, BuildContext context, Function(String id) _onTopRestaurantNavigateIconClick,
    Function(Restaurants rest) _deleteCircle, Function(Restaurants item) _setCircle) {
  _context = context;
  List<Widget> list = [];
  var height = windowWidth*appSettings.restaurantCardHeight/100;
  for (var item in nearYourRestaurants) {
    var _dist = getDistanceText(item);
    list.add(Stack(
      children: [
        Container(
          color: theme.colorBackground,
          child: ICard20FileCachingSmart(
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
        )),
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

onTopRestaurantClick(String id, String heroId, String image){
  print("User pressed Top Restaurant with id: $id");
  idHeroes = UniqueKey().toString();
  idRestaurant = id;
  route.setDuration(1);
  route.push(_context, "/restaurantdetails");
}