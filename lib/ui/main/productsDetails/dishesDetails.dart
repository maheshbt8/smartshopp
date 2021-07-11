import 'package:flutter/material.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/model/foods.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/model/server/reviews.dart';
import 'package:fooddelivery/ui/main/home/home.dart';
import 'package:fooddelivery/ui/main/mainscreen.dart';
import 'package:fooddelivery/ui/main/productsDetails/humorist.dart';
import 'package:fooddelivery/ui/main/productsDetails/pagin1.dart';
import 'package:fooddelivery/ui/main/productsDetails/rProducts.dart';
import 'package:fooddelivery/ui/main/productsDetails/restaurantWidgets.dart';
import 'package:fooddelivery/ui/main/productsDetails/variants.dart';
import 'package:fooddelivery/widget/cacheImageWidget.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/ibox.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/ilist1.dart';
import 'package:fooddelivery/widget/rewiewsBar.dart';
import 'package:fooddelivery/widget/skinRoute.dart';
import 'package:fooddelivery/widget/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'imagebigscreen.dart';

class DishesDetailsScreen extends StatefulWidget {
  DishesDetailsScreen({Key key}) : super(key: key);
  @override
  _DishesDetailsScreenState createState() => _DishesDetailsScreenState();
}

class _DishesDetailsScreenState extends State<DishesDetailsScreen> with SingleTickerProviderStateMixin {

  ///////////////////////////////////////////////////////////////////////////////
  //

  _onShopClick(){
    dprint("User pressed Shop with id: ${_this.restaurant}");
    idHeroes = "";
    imageRestaurant = "";
    idRestaurant = _this.restaurant;
    route.setDuration(1);
    route.push(context, "/restaurantdetails");
  }

  _onAddToCartClick(String id){
    dprint("add to cart click id=$id");
    // _addToBasketItem = loadFood(id);
    // _addToBasketItem.count = 1;
    setState(() {
    });
  }

  _onProductClick(String id, String heroId){
    dprint("User pressed Most Popular item with id: $id");
    idHeroes = heroId;
    idDishes = id;
    route.setDuration(1);
    route.push(context, "/dishesdetails");
  }

  _onFavoriteClick(){
    account.revertFavoriteState(_this.id);
    setState(() {
    });
  }

  _pressAddReview(){
    dprint("User pressed Add review");
    _openRatingDialog();
  }

  _extrasClick(String id, bool value){
    for (var item in _this.extras)
      if (item.id == id)
        item.select = value;
    dprint("User pressed Extras item with id: $id, set=$value");
    setState(() {});
  }

  _onPress(int count){
    dprint("Count = $count");
    _this.count = count;
    setState(() {});
  }

  _tapAddToCart(){
    print("User pressed \"Add to cart\" button. Count = ${_this.count}");
    if (!account.isAuth())
      return route.push(context, "/login");
    if (basket.restaurantCheck(_this.restaurant)) {
      if (basket.dishInBasket(_this.id))
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strings.get(131))));  // "This food already added to cart",
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strings.get(130))));  // "This food was added to cart",
        basket.add(_this);
        _redraw();
        account.redraw();
      }
    }else{
      openResetDishesDialog();
    }
  }

  _callbackReset(){
    dprint("Reset cart");
    if (!account.isAuth()){
      basket.basket.clear();
      basket.add(_this);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strings.get(130))));  // "This food was added to cart",
      _redraw();
    }else {
      basket.reset(() {
        basket.add(_this);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strings.get(130))));  // "This food was added to cart",
        _redraw();
      });
    }
  }

  _callbackDone(){
    print ("Pressed Ok in rating dialog");
    if (editControllerReview.text.isEmpty)
      return openDialog(strings.get(141)); //  Enter your review
    reviewsFoodAdd(account.token, _this.id.toString(), _stars.toString(), editControllerReview.text, _success, _error);
  }

  _success(String date, List<FoodsReviews> reviews) {
    _this.foodsreviews = reviews;
    setState(() {
    });
  }

  ///////////////////////////////////////////////////////////////////////////////
  var _stars = 5;
  var windowWidth;
  var windowHeight;
  final editControllerReview = TextEditingController();
  TabController _tabController;

  _error(String error){
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  DishesData _this;

  @override
  void initState() {
    _this = loadFood(idDishes);
    _this.count = 1;
    if (_this.extras != null)
      for (var item in _this.extras)
        item.select = false;
    rProductsLoad(_this, _redraw);

    _tabController = TabController(vsync: this, length: _this.imagesFiles.length+1);
    _tabController.addListener(_handleTabSelection);

    super.initState();
  }

  var _tabIndex = 0;
  _handleTabSelection() {
    _tabIndex = _tabController.index;
    setState(() {});
  }

  @override
  void dispose() {
    route.disposeLast();
    editControllerReview.dispose();
    super.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: theme.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
            children: [
              NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: windowHeight*0.5,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: theme.colorBackground,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: _imageBuild(),
                  ),
                )];
            },

            body: Stack (
              children: <Widget>[

                Container(
                  child: _body(),
                ),

                skinProductDetailsAddToCartButtons(windowWidth, basket.makePriceString(basket.getItemPrice(_this)), _tapAddToCart, _onPress),

                IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
                    body: _dialogBody, backgroundColor: theme.colorBackground),

              ],
            )
        ),

        skinHeaderBackButtonWithBasket(context, mainScreenState.onBack, Colors.white),

        ]),
      ));
  }

  double _show = 0;
  Widget _dialogBody = Container();

  _body(){
    return Container(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: _children(),
      ),
    );
  }

  _redraw(){
    if (mounted)
      setState(() {});
  }

  _children(){
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));

    var _dPrice = "";
    var _price = "";
    if (_this.price != null)
      _price = basket.makePriceString(_this.price);
    if (_this.discountprice != 0) {
      _price = basket.makePriceString(_this.discountprice);
      _dPrice = basket.makePriceString(_this.price);
    }

    var _addedName = "";
    if (_this.variants != null)
      for (var item in _this.variants)
        if (item.select)
          _addedName = item.name;

    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: ListWithIcon(imageAsset: (theme.vendor) ? "assets/orders2.png" : "assets/orders.png", text: "${_this.name} $_addedName",                          // dish name
              imageColor: theme.colorDefaultText, ),
          ),
          SizedBox(width: 10,),
          if (_dPrice.isNotEmpty)
            Text(_dPrice, style: theme.text16Ubold,),
          if (_dPrice.isNotEmpty)
            SizedBox(width: 5,),
          Text(_price, style: theme.text18boldPrimary,),
        ],
      )));
    list.add(SizedBox(height: 20,));

    if (_this.desc.isNotEmpty) {
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Text(_this.desc, style: theme.text14),                                       // dish description
      ));
      list.add(SizedBox(height: 20,));
    }

    variants(list, _this, _redraw);                                                              // Variants

    restaurantExtras(list, _this.extras, _extrasClick);                                      // Extras

    if (_this.ingredients.isNotEmpty) {
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ListWithIcon(imageAsset: "assets/ingredients.png", text: strings.get(79),               // Ingredients
          imageColor: theme.colorDefaultText),
      ));
      list.add(SizedBox(height: 20,));
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          _this.ingredients, style: theme.text14),    // Ingredients description
      ));
      list.add(SizedBox(height: 20,));
    }

    _nutrition(list);

    list.add(SizedBox(height: 20,));

    skinRProducts(_this, list, windowWidth, _onProductClick, _onAddToCartClick);

    if (theme.multiple) {
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ListWithIcon(
            imageAsset: "assets/info.png", text: strings.get(69), // Information
            imageColor: theme.colorDefaultText),
      ));

      list.add(InkWell(
          onTap: () {
            _onShopClick();
          },
          child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
          child: Text(_this.restaurantName, style: theme.text16bold,)))
      );

      list.add(phone(_this.restaurantPhone, _callMe));
      list.add(phoneMobile(_this.restaurantMobilePhone, _callMeMobile));
    }

    list.add(SizedBox(height: 20,));
    foodsReviews(list, _this, windowWidth);
    list.add(SizedBox(height: 30,));

    if (account.isAuth())
      list.add(Container(
          alignment: Alignment.center,
        margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
        child: IButton3(text: strings.get(138),                           // Add Review
          color: theme.colorPrimary, pressButton: _pressAddReview,
          textStyle: theme.text14boldWhite,
        )
      ));

    list.add(SizedBox(height: 200,));

    return list;
  }

  _callMe() async {
    var uri = 'tel:${_this.restaurantPhone}';
    if (await canLaunch(uri))
      await launch(uri);
  }

  _imageBuild(){
    dprint("Food -> idHeroes=$idHeroes");
    List<Widget> list = [];
    List<Widget> listContain = [];
    listContain.add(Hero(tag: idHeroes,
        child: cacheImageWidgetContain("$serverImages${_this.image}", theme.colorPrimary)));
    list.add(Hero(tag: idHeroes,
        child: cacheImageWidgetCover("$serverImages${_this.image}", theme.colorPrimary)));
    for (var item in _this.imagesFiles){
      listContain.add(cacheImageWidgetContain("$serverImages$item", theme.colorPrimary));
      list.add(cacheImageWidgetCover("$serverImages$item", theme.colorPrimary));
    }
    return Stack(
      children: [
        InkWell(
            onTap: () {
              // open big image
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImagesBigScreen(
                      list: listContain
                  ),
                ),
              );
            },
            child: TabBarView(
            controller: _tabController,
            children: list
        )),
        if (_this.discountprice != 0)
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+50),
            child: Humorist(child: saleSticker(windowWidth*0.5, _this.discount, basket.makePriceString(_this.discountprice), basket.makePriceString(_this.price))),
          ),
        if (account.isAuth())(
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: 50+MediaQuery.of(context).padding.top, right: 10),
              child: Stack(
                children: <Widget>[
                  Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      child: Icon((account.getFavoritesState(_this.id)) ? Icons.favorite : Icons.favorite_border, color: theme.colorPrimary, size: 30,)
                  ),
                  Positioned.fill(
                    child: Material(
                        color: Colors.transparent,
                        shape: CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          splashColor: Colors.grey[400],
                          onTap: (){
                            _onFavoriteClick();
                          }, // needed
                        )),
                  )
                ],
              ),
            )
        ),
        if (_this.imagesFiles.length != 0)
          Container(
            alignment: Alignment.bottomCenter,
            child: pagination1(_this.imagesFiles.length+1, _tabIndex, theme.colorPrimary),
            margin: EdgeInsets.only(bottom: 10),
          ),
      ],
    );
  }

  _callMeMobile() async {
  var uri = 'tel:${_this.restaurantMobilePhone}';
  if (await canLaunch(uri))
  await launch(uri);
}

  _nutrition(List<Widget> list){
    if (_this.nutritions == null || _this.nutritions.isEmpty)
      return;
    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: ListWithIcon(imageAsset: "assets/brands.png", text: strings.get(80),                         // Nutrition
          imageColor: theme.colorDefaultText),
    ));

    int index = 0;
    List<Widget> items = [];
    for (var data in _this.nutritions) {
      items.add(_nutritionItem(data.name, data.desc),);
      index++;
      if (index == 4){
        index = 4;
        list.add(Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: items
            )));
        items = [];
      }
    }
    if (items.isNotEmpty)
      list.add(Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: items
          )));
  }

  _nutritionItem(String text1, String text2){
    return IBox(radius: 0, blur: 10, child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text(text1, style: theme.text12grey,),
            Text(text2, style: theme.text14primary,),
          ],
      )));
  }

  openDialog(String _text) {
    _dialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155),              // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: (){
              setState(() {
                _show = 0;
              });
            }
        ),
      ],
    );

    setState(() {
      _show = 1;
    });
  }

  _ratingDialogBuilding(){
    return Directionality(
        textDirection: strings.direction,
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: Text(strings.get(142), textAlign: TextAlign.center, style: theme.text18boldPrimary,) // "Enjoying Restaurant?",
              ), // "Reason to Reject",
              SizedBox(height: 10,),
              Container(
                  alignment: Alignment.center,
                  child: Text(strings.get(143), textAlign: TextAlign.center, style: theme.text16,) // "How would you rate this restaurant?",
              ), // "Reason to Reject",
              SizedBox(height: 20,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _starsWidget(),
                ),
              ),
              SizedBox(height: 20,),
              Text("${strings.get(141)}:", style: theme.text12bold,),  // ""Enter your review",",
              _edit(editControllerReview, strings.get(141), false),                //  "Enter your review",
              SizedBox(height: 30,),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Container(
                  width: windowWidth/2-45,
                    child: IButton3(
                          color: theme.colorPrimary,
                          text: strings.get(127),                  // Ok
                          textStyle: theme.text14boldWhite,
                          pressButton: (){
                            setState(() {
                              _show = 0;
                            });
                            _callbackDone();
                          }
                      )),
                      SizedBox(width: 10,),
                  Container(
                    width: windowWidth/2-45,
                    child: IButton3(
                          color: theme.colorPrimary,
                          text: strings.get(155),              // Cancel
                          textStyle: theme.text14boldWhite,
                          pressButton: (){
                            setState(() {
                              _show = 0;
                            });
                          }
                      )),
                    ],
                  )),

            ],
          ),
        ));
  }

  _openRatingDialog(){
    _dialogBody = _ratingDialogBuilding();

    setState(() {
      _show = 1;
    });
  }

  List<Widget> _starsWidget(){
    List<Widget> list = [];

    if (_stars >= 1) list.add(_good(1)); else list.add(_bad(1));
    if (_stars >= 2) list.add(_good(2)); else list.add(_bad(2));
    if (_stars >= 3) list.add(_good(3)); else list.add(_bad(3));
    if (_stars >= 4) list.add(_good(4)); else list.add(_bad(4));
    if (_stars >= 5) list.add(_good(5)); else list.add(_bad(5));

    return list;
  }

  _good(int pos){
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _stars = pos;
          _dialogBody = _ratingDialogBuilding();
          setState(() {
          });
        },
        child: Icon(Icons.star, color: Colors.orangeAccent, size: 40));
  }

  _bad(int pos){
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _stars = pos;
          _dialogBody = _ratingDialogBuilding();
          setState(() {
          });
        },
        child: Icon(Icons.star_border, color: Colors.orangeAccent, size: 40)
    );
  }

  _edit(TextEditingController _controller, String _hint, bool _obscure){
    return Container(
        height: 40,
        child: Directionality(
          textDirection: strings.direction,
          child: TextFormField(
            controller: _controller,
            onChanged: (String value) async {
            },
            cursorColor: theme.colorDefaultText,
            style: theme.text14,
            cursorWidth: 1,
            obscureText: _obscure,
            maxLines: 1,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: _hint,
                hintStyle: theme.text14
            ),
          ),
        ));
  }

  _body3(){
    return Container(
        width: windowWidth,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Text(strings.get(82), textAlign: TextAlign.center, style: theme.text18boldPrimary,), // "You can add to cart, only dishes from single restaurant. Do you want to reset cart? And add new dishes.",
            SizedBox(height: 50,),
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Container(
                width: windowWidth/2-45,
                  child: IButton3(
                        color: Colors.red,
                        text: strings.get(83), // Reset
                        textStyle: theme.text14boldWhite,
                        pressButton: (){
                          setState(() {
                            _show = 0;
                          });
                          _callbackReset();
                        }
                    )),
                    SizedBox(width: 10,),
                Container(
                  width: windowWidth/2-45,
                  child: IButton3(
                        color: theme.colorPrimary,
                        text: strings.get(84), // Cancel
                        textStyle: theme.text14boldWhite,
                        pressButton: (){
                          setState(() {
                            _show = 0;
                          });
                        }
                    )),
                  ],
                )),

          ],
        )
    );
  }

  openResetDishesDialog(){
    _dialogBody = _body3();
    setState(() {
      _show = 1;
    });
  }
}

