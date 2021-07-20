import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/categories.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/foods.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/server/category.dart';
import 'package:shopping/model/server/mainwindowdata.dart';
import 'package:shopping/ui/main/home/home.dart';
import 'package:shopping/widget/buttonadd.dart';
import 'package:shopping/widget/easyDialog2.dart';
import 'package:shopping/widget/ibutton3.dart';
import 'package:shopping/widget/ilist1.dart';
import 'package:shopping/widget/skinRoute.dart';
import 'package:shopping/widget/wproducts.dart';
import 'mainscreen.dart';

class CategoryDetailsScreen extends StatefulWidget {
  CategoryDetailsScreen({Key key}) : super(key: key);
  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> with SingleTickerProviderStateMixin {

  _onCategoriesClick(String id, String heroId, String image) {
    dprint("User pressed Category item with id: $id");
    if (id == ""){
      id = firstCategory;
      image = firstCategoryImage;
      _categoryImage = firstCategoryImage;
    }
    currentCategoryId = id;
    // listCategoryBack.add(id);
    imageCategory = image;
    dprint("_onCategoriesClick $_categoryImage");
    _waits(true);
    category.get(currentCategoryId, _success, _error);
    _controller.animateTo(
        0, duration: Duration(seconds: 1), curve: Curves.ease);
  }

  _onDishesClick(String id, String heroId) {
    dprint("User pressed Most Popular item with id: $id");
    idHeroes = heroId;
    idDishes = id;
    route.setDuration(1);
    route.push(context, "/dishesdetails");
  }

  ///////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  var _controller = ScrollController();
  Category category = Category();
  bool _wait = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    noMain = true;
    mainCurrentDialogShow = 0;
    _controller.addListener(() {});
    _categoryImage = imageCategory;
    //
    firstCategory = currentCategoryId;
    firstCategoryImage = imageCategory;
    //
    category.get(currentCategoryId, _success, _error);
    account.addCallback(this.hashCode.toString(), callback);
    super.initState();
  }

  @override
  void dispose() {
    noMain = false;
    account.removeCallback(this.hashCode.toString());
    route.disposeLast();
    _controller.dispose();
    super.dispose();
  }

  callback(bool reg){
    if (mounted)
      setState(() {
      });
  }

  String _categoryName = "";
  String _categoryDesc = "";
  String _categoryImage;

  _success(List<DishesData> _data, String currency, String desc, String image,
      String name) {
    _waits(false);
    _categoryName = name;
    _categoryDesc = desc;
    _categoryImage = image;
    dprint("_success _categoryImage $_categoryImage");
    dishData = _data;
    setState(() {});
  }

  _error(String error) {
    _waits(false);
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _waits(bool value) {
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery
        .of(context)
        .size
        .width;
    windowHeight = MediaQuery
        .of(context)
        .size
        .height;
    return WillPopScope(
        onWillPop: () async {
      if (mainCurrentDialogShow != 0) {
        setState(() {
          mainCurrentDialogShow = 0;
        });
        return false;
      }
      Navigator.pop(context);
      return false;
    },
    child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: theme.colorBackground,
        body: Directionality(
            textDirection: strings.direction,
            child: Stack(
                children: [
                  NestedScrollView(
                      controller: _controller,
                      headerSliverBuilder: (BuildContext context,
                          bool innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            expandedHeight: windowHeight * 0.35,
                            automaticallyImplyLeading: false,
                            elevation: 0,
                            backgroundColor: theme.colorBackground,
                            flexibleSpace: FlexibleSpaceBar(
                              collapseMode: CollapseMode.parallax,
                              background: _imageBuild(),
                            ),
                          )
                        ];
                      },

                      body: Stack(
                        children: <Widget>[

                          Container(
                            child: _body(),
                          ),

                          if (_addToBasketItem != null)
                            buttonAddToCart(_addToBasketItem, (){setState(() {});}, ( ){_addToBasketItem = null; setState(() {});},
                                _scaffoldKey),

                          if (_wait)
                            skinWait(context, false),

                          IEasyDialog2(setPosition: (double value) {mainCurrentDialogShow = value;}, getPosition: () {return mainCurrentDialogShow;},
                            color: theme.colorGrey, body: mainCurrentDialogBody, backgroundColor: theme.colorBackground,),

                        ],
                      )
                  ),
                  skinHeaderBackButton(context, Colors.white)
                ])
        )));
  }

  _body() {
    return Container(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: _children(),
      ),
    );
  }

  _children() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: ListWithIcon(
          imageAsset: (theme.vendor) ? "assets/orders2.png" : "assets/orders.png", text: _categoryName, //  name
          imageColor: theme.colorDefaultText),
    ));

    if (_categoryDesc.isNotEmpty) {
      list.add(SizedBox(height: 20,));
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Text(_categoryDesc, style: theme.text14), // description
      ));
    }

    horizontalCategoriesCircleRestaurantV2(list, categories, dishData, windowWidth, _onCategoriesClick, currentCategoryId);

    list.add(SizedBox(height: 20,));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: ListWithIcon(
          imageAsset: "assets/top.png", text: strings.get(91), // Dishes
          imageColor: theme.colorDefaultText),
    ));

    if (appSettings.typeFoods == "type2")
      dishList2(list, dishData, context, _onDishesClick, windowWidth, currentCategoryId, _onAddToCartClick);
    else {
      if (appSettings.oneInLine == "false")
        dishList(list, dishData, context, _onDishesClick, windowWidth, _onAddToCartClick, currentCategoryId);
      else
        dishListOneInLine(list, dishData, _onDishesClick, windowWidth, _onAddToCartClick, currentCategoryId);
    }
    list.add(SizedBox(height: 150,));
    return list;
  }

  DishesData _addToBasketItem;

  _onAddToCartClick(String id){
    dprint("add to cart click id=$id");
    _addToBasketItem = loadFood(id);
    _addToBasketItem.count = 1;
    setState(() {
    });
  }

  _imageBuild() {
    dprint("Category show -> idHeroes=$idHeroes image=$_categoryImage");
    return Stack(
      children: [
        if (_categoryImage != null)
          Container(
              child: Hero(
                  tag: idHeroes,
                  child: ClipRRect(
                      child: Container(
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: _categoryImage,
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
                      )
                  )
              )
          ),

      ],
    );
  }

  openDialog(String _text) {
    mainCurrentDialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155), // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: () {
              mainCurrentDialogShow = 0;
              if (mounted)
                setState(() {
                });
            }
        ),
      ],
    );

    mainCurrentDialogShow = 1;
    if (mounted)
      setState(() {
      });
  }
}