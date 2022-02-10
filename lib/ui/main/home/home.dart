import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/foods.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/review.dart';
import 'package:shopping/model/server/mainwindowdata.dart';
import 'package:shopping/model/server/search.dart';
import 'package:shopping/model/topRestourants.dart';
import 'package:shopping/widget/ReviewsText.dart';
import 'package:shopping/widget/basic/category.dart';
import 'package:shopping/widget/buttonadd.dart';
import 'package:shopping/widget/easyDialog2.dart';
import 'package:shopping/widget/ibanner.dart';
import 'package:shopping/widget/ibutton3.dart';
import 'package:shopping/widget/ilist1.dart';
import 'package:shopping/widget/skinRoute.dart';
import 'package:shopping/widget/widgets.dart';
import 'package:shopping/widget/wproducts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import '../mainscreen.dart';
import 'package:shopping/widget/wproducts.dart';
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) callback;
  final Function(String) onErrorDialogOpen;
  final Function() redraw;
  final scaffoldKey;

  HomeScreen({
    this.redraw,
    this.onErrorDialogOpen,
    this.callback,
    this.scaffoldKey,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

String idDishes;
String idRestaurant;
String idRestaurantOnMap;
String imageRestaurant;
String currentCategoryId;
String imageCategory;
String idHeroes;
String idOrder;
String firstCategory;
String firstCategoryImage;
var floatingActionButton = null;

HomeScreenModel homeScreen = HomeScreenModel();

class _HomeScreenState extends State<HomeScreen> {
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  _onBannerClick(String id, String heroId, String image) {
    dprint("Banner click: $id");
    for (var item in homeScreen.secondStepData.banner1) {
      if (item.id == id) {
        if (item.type == "1") {
          // open food
          idHeroes = heroId;
          idDishes = item.details;
          route.setDuration(1);
          route.push(context, "/dishesdetails");
        }
        if (item.type == "2") {
          // open link
          _openUrl(item.details);
        }
        break;
      }
    }
    for (var item in homeScreen.secondStepData.banner2) {
      if (item.id == id) {
        if (item.type == "1") {
          // open food
          idHeroes = heroId;
          idDishes = item.details;
          route.setDuration(1);
          route.push(context, "/dishesdetails");
        }
        if (item.type == "2") {
          // open link
          _openUrl(item.details);
        }
        break;
      }
    }
  }

  _openUrl(uri) async {
    if (await canLaunch(uri)) await launch(uri);
  }

  _onPressSearch(String value) {
    dprint("Search word: $value");
    _search = value;
    getSearch(value, _successSearch, (String _) {});
    setState(() {});
  }

  _onRestaurantClick(String id, String heroId, String image) {
    dprint("User pressed Restaurant Near Your with id: $id");
    idHeroes = heroId;
    imageRestaurant = image;
    idRestaurant = id;
    route.setDuration(1);
    route.push(context, "/restaurantdetails");
  }

  _onTopRestaurantNavigateIconClick(String id) {
    dprint("User pressed Top Restaurant Route icon with id: $id");
    idRestaurantOnMap = id;
    //route.mainScreen.route("map");
    mainScreenState.routes("map");
  }

  _onCategoriesClick(String id, String heroId, String image) {
    dprint("User pressed Category item with id: $id");
    idHeroes = heroId;
    currentCategoryId = id;
    imageCategory = image;
    route.setDuration(1);
    route.push(context, "/categorydetails");
  }

  _onProductClick(String id, String heroId) {
    dprint("User pressed Most Popular item with id: $id");
    idHeroes = heroId;
    idDishes = id;
    route.setDuration(1);
    route.push(context, "/dishesdetails");
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  String _search = "";
  bool _wait = false;
  var windowWidth;
  var windowHeight;
  TextEditingController _searchController = TextEditingController();

  _waits(bool value) {
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  _dataLoad() async {
    _homeScreenLoad = false;
    _waits(false);
    await homeScreen.distance();
    if (mounted) setState(() {});
    widget.redraw();
  }

  _error(String err) {
    _waits(false);
    widget.onErrorDialogOpen(
        "${strings.get(128)} $err"); // "Something went wrong. ",
  }

  @override
  void initState() {
    super.initState();
    account.addCallback(this.hashCode.toString(), callback);
    _wait = true;
    homeScreen.load(_dataLoad, _error);
  }

  bool _homeScreenLoad = true;

  callback(bool reg) {
    setState(() {});
  }

  @override
  void dispose() {
    account.removeCallback(this.hashCode.toString());
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: strings.direction,
      child: Stack(
        children: [
          Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 45),
              child: ListView(
                  padding: EdgeInsets.only(top: 0),
                  shrinkWrap: true,
                  children: _children())),
          if (_addToBasketItem != null)
            Container(
              margin: EdgeInsets.only(bottom: 60),
              child: buttonAddToCart(_addToBasketItem, () {
                setState(() {});
              }, () {
                _addToBasketItem = null;
                setState(() {});
              }, widget.scaffoldKey),
            ),
          IEasyDialog2(
            setPosition: (double value) {
              _show = value;
            },
            getPosition: () {
              return _show;
            },
            color: theme.colorGrey,
            body: _dialogBody,
            backgroundColor: theme.colorBackground,
          ),
          if (_wait) skinWait(context, true),
          Positioned(
            bottom: 90,
            right: 20,
            child: Container(
              height: 40,
              width: 40,
              child: InkWell(
                onTap: () {
                  _share();
                },
                child: Image.asset("assets/img_share.png"),
              ),
              // color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  _children() {
    List<Widget> list = [];
    if (_homeScreenLoad) return list;
    String lastRow = "";
    for (var row in appSettings.rows) {
      lastRow = row;
      //
      // SEARCH
      //
      if (row == "search") {
        skinHomeScreenSearch(list, _searchController, () {
          _search = ""; // on press right icon
          _searchController.text = "";
          setState(() {});
        }, _onPressSearch, widget.redraw, windowWidth);
      }
      if (_search.isNotEmpty) continue;
      //
      // BANNER 1
      //

      if (row == "banner1") {
        if (homeScreen.secondStepData != null &&
            homeScreen.secondStepData.banner1 != null &&
            homeScreen.secondStepData.banner1.isNotEmpty) {
          list.add(Container(
              child: IBanner(
            homeScreen.secondStepData.banner1,
            width: windowWidth * 0.95,
            height: windowWidth * appSettings.banner1CardHeight / 100,
            colorActivy: theme.colorPrimary,
            colorProgressBar: theme.colorPrimary,
            radius: appSettings.radius,
            shadow: appSettings.shadow,
            style: theme.text16boldWhite,
            callback: _onBannerClick,
            seconds: 4,
          )));
        }
      }

      //
      // BANNER 2
      //
      if (row == "banner2") {
        if (homeScreen.secondStepData != null &&
            homeScreen.secondStepData.banner2 != null &&
            homeScreen.secondStepData.banner2.isNotEmpty) {
          list.add(Container(
              child: IBanner(
            homeScreen.secondStepData.banner2,
            width: windowWidth * 0.95,
            height: windowWidth * appSettings.banner1CardHeight / 100,
            colorActivy: theme.colorPrimary,
            colorProgressBar: theme.colorPrimary,
            radius: appSettings.radius,
            shadow: appSettings.shadow,
            style: theme.text16boldWhite,
            callback: _onBannerClick,
            seconds: 4,
          )));
        }
      }
      //
      // CATEGORIES
      //
      if (row == "cat") skinHomeCategory(list, windowWidth, _onCategoriesClick);
      //
      // MOST POPULAR PRODUCTS
      //
      if (row == "pop") {
        list.add(Container(
          color: appSettings.dishesTitleColor,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: ListWithIcon(
              imageAsset: "assets/popular.png",
              text: strings.get(42),
              // "Most Popular",
              icon: Icons.add_to_photos,
              imageColor: appSettings.getIconColorByMode(theme.darkMode)),
        ));

        if (appSettings.typeFoods == "type2")
          dishList2(list, mostPopular, context, _onProductClick, windowWidth,
              "", _onAddToCartClick);
        else {
          if (appSettings.oneInLine == "false")
            dishList(list, mostPopular, context, _onProductClick, windowWidth,
                _onAddToCartClick, "");
          else
            dishListOneInLine(list, mostPopular, _onProductClick, windowWidth,
                _onAddToCartClick, "");
        }
      }
      //skinHomeMostPopularFoods(list, windowWidth, _onProductClick, _onAddToCartClick, context);
      //
      // TOP PRODUCTS ON THIS WEEK
      //
      if (row == "topf") {
        list.add(Container(
          color: appSettings.dishesTitleColor,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: ListWithIcon(
              imageAsset: "assets/hot.png",
              text: strings.get(199),
              // "Top Trends this week",
              icon: Icons.trending_up_outlined,
              imageColor: appSettings.getIconColorByMode(theme.darkMode)),
        ));
        if (appSettings.typeFoods == "type2")
          dishList2(list, topFoods, context, _onProductClick, windowWidth, "",
              _onAddToCartClick);
        else {
          if (appSettings.oneInLine == "false")
            dishList(list, topFoods, context, _onProductClick, windowWidth,
                _onAddToCartClick, "");
          else
            dishListOneInLine(list, topFoods, _onProductClick, windowWidth,
                _onAddToCartClick, "");
        }
      }
      //skinHomeTopFoods(list, windowWidth, _onProductClick, _onAddToCartClick, context);
      //
      //  RESTAURANTS NEAR YOU
      //

      if (row == "nearyou" && theme.multiple)
        skinHomeNearYourRestaurants(
            list,
            windowWidth,
            distanceForNearYourFilter,
            _onRestaurantClick,
            _onTopRestaurantNavigateIconClick,
            openFilterNearYourDistance);

      //
      // TOP RESTAURANTS (MARKETS)
      //
      if (row == "topr" && theme.multiple) if (topRestaurants.isNotEmpty)
        skinHomeTopRestaurants(list, windowWidth, _onRestaurantClick);

      //
      // COPYRIGHT
      //
      if (row == "copyright") {
        list.add(copyrightBlock(widget.callback));
      }
      // CATEGORY DETAILS
      //
      if (row == "categoryDetails")
        bCategoryDetails(list, windowWidth, _onProductClick, _onAddToCartClick);
      //
      // REVIEWS
      //
      if (row == "review") {
        if (reviews.isNotEmpty)
          list.add(Container(
            color: appSettings.reviewTitleColor,
            padding: EdgeInsets.all(10),
            child: ListWithIcon(
                imageAsset: "assets/reviews.png",
                text: strings.get(43),
                // "Recent Reviews",
                icon: Icons.rate_review,
                imageColor: appSettings.getIconColorByMode(theme.darkMode)),
          ));
        _reviews(list);
      }
    }
    //
    // SEARCH
    //
    if (_search.isNotEmpty) {
      if (appSettings.typeFoods == "type2")
        dishList2(list, searchData, context, _onProductClick, windowWidth, "",
            _onAddToCartClick);
      else {
        if (appSettings.oneInLine == "false")
          dishList(list, searchData, context, _onProductClick, windowWidth,
              _onAddToCartClick, "");
        else
          dishListOneInLine(list, searchData, _onProductClick, windowWidth,
              _onAddToCartClick, "");
      }
      list.add(Container(
        color: appSettings.dishesBackgroundColor,
        height: 200,
      ));
      return list;
    }

    Color lastColor = theme.colorBackground;
    if (lastRow.isNotEmpty) {
      if (lastRow == "search") lastColor = appSettings.searchBackgroundColor;
      if (lastRow == "nearyou")
        lastColor = appSettings.restaurantBackgroundColor;
      if (lastRow == "cat") lastColor = appSettings.categoriesBackgroundColor;
      if (lastRow == "pop") lastColor = appSettings.dishesBackgroundColor;
      if (lastRow == "review") lastColor = appSettings.reviewBackgroundColor;
    }

    list.add(Container(
      color: lastColor,
      height: 100,
    ));

    return list;
  }

  DishesData _addToBasketItem;

  _onAddToCartClick(String id) {
    dprint("add to cart click id=$id");
    _addToBasketItem = loadFood(id);
    _addToBasketItem.count = 1;
    setState(() {});
  }

  _successSearch(List<DishesData> _data, String currency) {
    searchData.clear();
    searchData = _data;
    setState(() {});
  }

  double _show = 0;
  Widget _dialogBody = Container();
  int distanceForNearYourFilter = 0;

  openFilterNearYourDistance() {
    int _selectitem = 0;
    _dialogBody = Column(
      children: [
        Text(
          strings.get(309),
          style: theme.text14,
        ),
        // Select maximum distance:
        // SizedBox(height: 10,),
        Container(
            height: 200,
            child: CupertinoPicker(
              magnification: 1.5,
              backgroundColor: theme.colorBackground,
              children: <Widget>[
                Text(
                  strings.get(133),
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ), // All
                Text(
                  "5 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
                Text(
                  "10 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
                Text(
                  "15 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
                Text(
                  "20 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
                Text(
                  "25 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ), // 5
                Text(
                  "50 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
                Text(
                  "100 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
                Text(
                  "150 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
                Text(
                  "200 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ), // 9
                Text(
                  "300 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
              ],
              itemExtent: 40,
              //height of each item
              looping: false,
              onSelectedItemChanged: (int index) {
                _selectitem = index;
              },
            )),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
                child: IButton3(
                    color: theme.colorPrimary,
                    text: strings.get(155), // Cancel
                    textStyle: theme.text14boldWhite,
                    pressButton: () {
                      setState(() {
                        _show = 0;
                      });
                    })),
            Flexible(
                child: IButton3(
                    color: theme.colorPrimary,
                    text: strings.get(127), // OK
                    textStyle: theme.text14boldWhite,
                    pressButton: () {
                      switch (_selectitem) {
                        case 0:
                          distanceForNearYourFilter = 0;
                          break;
                        case 1:
                          distanceForNearYourFilter = 5;
                          break;
                        case 2:
                          distanceForNearYourFilter = 10;
                          break;
                        case 3:
                          distanceForNearYourFilter = 15;
                          break;
                        case 4:
                          distanceForNearYourFilter = 20;
                          break;
                        case 5:
                          distanceForNearYourFilter = 25;
                          break;
                        case 6:
                          distanceForNearYourFilter = 50;
                          break;
                        case 7:
                          distanceForNearYourFilter = 100;
                          break;
                        case 8:
                          distanceForNearYourFilter = 150;
                          break;
                        case 9:
                          distanceForNearYourFilter = 200;
                          break;
                        case 10:
                          distanceForNearYourFilter = 300;
                          break;
                      }
                      setState(() {
                        _show = 0;
                      });
                    })),
          ],
        ),
        SizedBox(
          height: 60,
        )
      ],
    );
    setState(() {
      _show = 1;
    });
  }

  _reviews(List<Widget> list) {
    for (var item in reviews)
      if (item.name != 'null') {
        list.add(Container(
          color: appSettings.reviewBackgroundColor,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ReviewsText(
            color: theme.colorPrimary,
            title: item.name,
            text: item.text,
            date: item.date,
            userAvatar: item.image,
            rating: item.star,
          ),
        ));
      }
  }

  Future<void> _share() async {
    // Share.share(
    //     'Smartshopp |  Buy / Sell your Products https://play.google.com/store/apps/details?id=com.shopping.smartshop',
    //     subject: 'Download App Now');

    try {
      final ByteData bytes = await rootBundle.load('assets/new_app_logo.png');
      await WcFlutterShare.share(
          sharePopupTitle: 'share',
          subject: 'This is subject',
          text: 'Smartshopp in India' +
              '\n' +
              'Website: https://smartshopp.in' +
              '\n' +
              'Play Store: https://play.google.com/store/apps/details?id=com.shopping.smartshop',
          fileName: 'share.png',
          mimeType: 'image/png',
          bytesOfFile: bytes.buffer.asUint8List());
    } catch (e) {
      print('error: $e');
    }
  }
}
