import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/model/foods.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/server/getRestaurant.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/model/server/reviews.dart';
import 'package:fooddelivery/ui/main/home/home.dart';
import 'package:fooddelivery/ui/main/mainscreen.dart';
import 'package:fooddelivery/widget/buttonadd.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/ibanner.dart';
import 'package:fooddelivery/widget/iboxCircle.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/iinkwell.dart';
import 'package:fooddelivery/widget/ilist1.dart';
import 'package:fooddelivery/widget/rewiewsBar.dart';
import 'package:fooddelivery/widget/skinRoute.dart';
import 'package:fooddelivery/widget/wproducts.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  RestaurantDetailsScreen({Key key}) : super(key: key);
  @override
  _RestaurantDetailsScreenState createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> with SingleTickerProviderStateMixin {

  ///////////////////////////////////////////////////////////////////////////////
  //

  _onBannerClick(String id, String heroId, String image){
    dprint("Banner click: $id");
    for (var item in _this.banner1){
      if (item.id == id){
        if (item.type == "1") { // open food
          idHeroes = heroId;
          idDishes = item.details;
          route.setDuration(1);
          route.push(context, "/dishesdetails");
        }
        if (item.type == "2") { // open link
          _openUrl(item.details);
        }
        break;
      }
    }
  }

  _openUrl(uri) async {
    if (await canLaunch(uri))
      await launch(uri);
  }

  _onCategoriesClick(String id, String heroId, String image){
    print("User pressed Category item with id: $id");
    idHeroes = heroId;
    _currentCategoryId = id;
    if (id == "")
      _categoryName = strings.get(133); // All
    for (var item in _this.categories)
      if (item.id == id)
        _categoryName = item.name;

    setState(() {
    });
  }

  _onDishesClick(String id, String heroId){
    print("User pressed Most Popular item with id: $id");
    idDishes = id;
    idHeroes = heroId;
    route.setDuration(1);
    route.push(context, "/dishesdetails");
  }

  _pressAddReview(){
    dprint("User pressed Add review");
    _openRatingDialog();
  }

  _callbackDone(){
    if (editControllerReview.text.isEmpty)
      return  openDialog(strings.get(141)); //  Enter your review
    print ("Pressed Ok in rating dialog");
    reviewsRestaurantAdd(account.token, _this.restaurant.id.toString(), _stars.toString(), editControllerReview.text, _successReview, _error);
  }

  ///////////////////////////////////////////////////////////////////////////////
  var _stars = 5;
  var windowWidth;
  var windowHeight;
  var _currentCategoryId = "";
  ResponseRestaurant _this;
  bool _wait = true;
  var restaurant = RestaurantData();
  var _categoryName = "";
  final editControllerReview = TextEditingController();
  String _imageRestaurant;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    noMain = true;
    mainCurrentDialogShow = 0;
    _imageRestaurant = imageRestaurant;
    restaurant.get(idRestaurant, _success, _error);
    _categoryName = strings.get(133); // All
    account.addCallback(this.hashCode.toString(), callback);
    super.initState();
  }

  @override
  void dispose() {
    noMain = false;
    account.removeCallback(this.hashCode.toString());
    route.disposeLast();
    editControllerReview.dispose();
    super.dispose();
  }

  callback(bool reg){
    if (mounted)
      setState(() {
      });
  }

  _successReview(String date, List<RestaurantsReviewsData> reviews) {
    _this.restaurantsreviews = reviews;
    // _this.restaurantsreviews.add(
    //     RestaurantsReviewsData(
    //       image: account.userAvatar,
    //       name: account.userName,
    //       desc: editControllerReview.text,
    //       updatedAt: date,
    //       rate: _stars,)
    // );
    setState(() {
    });
  }

  _success(ResponseRestaurant _data){
    _this = _data;
    _imageRestaurant = _this.restaurant.image;
    dishDataRestaurant.clear();
    dishDataRestaurant = _data.foods;
    _waits(false);
  }
  _error(String error){
    _waits(false);
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _waits(bool value){
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

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
                  expandedHeight: windowHeight*0.35,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: theme.colorBackground,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: _imageBuild(),
                 ),
                floating: true,
                )];
            },

            body: Stack (
              children: <Widget>[

                Container(
                  child: _body(),
                ),

                if (_addToBasketItem != null)
                  buttonAddToCart(_addToBasketItem, (){setState(() {});}, ( ){_addToBasketItem = null; setState(() {});},
                      _scaffoldKey),

                if (_wait)
                  skinWait(context, true),

                IEasyDialog2(setPosition: (double value){mainCurrentDialogShow = value;}, getPosition: () {return mainCurrentDialogShow;}, color: theme.colorGrey,
                  body: mainCurrentDialogBody, backgroundColor: theme.colorBackground),

                    ],
                  )
          ),

            skinHeaderBackButton(context, Colors.white)

          ],
        ))
    );
  }

  _body(){
    return Container(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: _children(),
      ),
    );
  }

  _children(){
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));

    list.add(Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: ListWithIcon(imageAsset: "assets/star.png", text: (_this != null) ? _this.restaurant.name : "",                // name
        imageColor: theme.colorDefaultText),
    ));

    if (_this != null && _this.restaurant.desc.isNotEmpty)
      list.add(SizedBox(height: 20,));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Text((_this != null) ? _this.restaurant.desc : "", style: theme.text14),                                               // description
    ));

    // banners for vendor market
    if (_this != null && _this.banner1 != null && _this.banner1.length != 0) {
      list.add(Container(
          child: IBanner(_this.banner1,
            width: windowWidth * 0.95,
            height: windowWidth * appSettings.banner1CardHeight / 100,
            colorActivy: theme.colorPrimary,
            colorProgressBar: theme.colorPrimary,
            radius: appSettings.radius,
            shadow: appSettings.shadow,
            style: theme.text16boldWhite,
            callback: _onBannerClick,
            seconds: 4,
          ))
      );
    }
    list.add(SizedBox(height: 20,));

    if (_this != null && _this.restaurant != null) {
      if (_this.restaurant.phone.isNotEmpty ||
          _this.restaurant.mobilephone.isNotEmpty) {
        list.add(Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: ListWithIcon(
              imageAsset: "assets/info.png",
              text: strings.get(69),      // Information
              imageColor: theme.colorDefaultText),
        ));

        list.add(_phone());
        list.add(_phoneMobile());

        list.add(SizedBox(height: 20,));

        if (_this.restaurant.openTimeMonday != null)
          if (_this.restaurant.openTimeMonday.isNotEmpty) {
            list.add(_workTime());
            list.add(SizedBox(height: 20,));
          }
      }
    }

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: ListWithIcon(imageAsset: "assets/categories.png", text: strings.get(91),             // Products
        imageColor: theme.colorDefaultText),
    ));

    list.add(SizedBox(height: 10,));

    if (_this != null) {
      if (_this.ver == '1'){
        if (appSettings.categoryCardCircle == "true")
          list.add(horizontalCategoriesCircleRestaurant(_this.categories, windowWidth, _onCategoriesClick));
        else
          list.add(horizontalCategoriesRestaurant(_this.categories, windowWidth, _onCategoriesClick));
      }
      if (_this.ver == '2'){
          horizontalCategoriesCircleRestaurantV2(list, _this.categories, _this.foods, windowWidth, _onCategoriesClick, _currentCategoryId);
      }
    }

    list.add(SizedBox(height: 20,));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: ListWithIcon(imageAsset: "assets/top.png", text: "${strings.get(91)} - $_categoryName",                // Dishes
        imageColor: theme.colorDefaultText),
    ));

    if (appSettings.typeFoods == "type2")
      dishList2(list, dishDataRestaurant, context, _onDishesClick, windowWidth, _currentCategoryId, _onAddToCartClick);
    else {
      if (appSettings.oneInLine == "false")
        dishList(list, dishDataRestaurant, context, _onDishesClick, windowWidth, _onAddToCartClick, _currentCategoryId);
      else
        dishListOneInLine(list, dishDataRestaurant, _onDishesClick, windowWidth, _onAddToCartClick, _currentCategoryId);
    }

    list.add(SizedBox(height: 20,));
    marketReviews(list, _this, windowWidth);
    list.add(SizedBox(height: 20,));

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

  DishesData _addToBasketItem;

  _onAddToCartClick(String id){
    dprint("add to cart click id=$id");
    _addToBasketItem = loadFood(id);
    _addToBasketItem.count = 1;
    setState(() {
    });
  }

  _imageBuild(){
      return Stack(
          children: [
          if (_imageRestaurant != null && _imageRestaurant.isNotEmpty)
          Container(
          child: Hero(
            tag: idHeroes,
            child: Container(
                child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      CircularProgressIndicator(),
                  imageUrl: _imageRestaurant,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  errorWidget: (context,url,error) => new Icon(Icons.error),
                ),
              )
          )
        ),

        if (_wait)(
            Container(
              color: Color(0x80000000),
              width: windowWidth,
              height: windowHeight,
            )),

          ]);
  }

  _phone(){
    if (_this == null)
      return Container();
    if (_this.restaurant.phone.isEmpty)
      return Container();

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text("${strings.get(106)}: ${_this.restaurant.phone}", style: theme.text14)  //  "Phone",
          ),
          IInkWell(child: IBoxCircle(child: _icon(), color: Colors.white,), onPress: _callMe,)
        ],
      ),
    );
  }

  _phoneMobile(){
    if (_this == null)
      return Container();
    if (_this.restaurant.mobilephone.isEmpty)
      return Container();

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text("${strings.get(81)}: ${_this.restaurant.mobilephone}", style: theme.text14) // "Mobile Phone",
          ),
          IInkWell(child: IBoxCircle(child: _icon()), onPress: _callMeMobile,)
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

  _callMe() async {
    var uri = 'tel:${_this.restaurant.phone}';
    if (await canLaunch(uri))
      await launch(uri);
  }

  _callMeMobile() async {
    var uri = 'tel:${_this.restaurant.mobilephone}';
    if (await canLaunch(uri))
      await launch(uri);
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
                              mainCurrentDialogShow = 0;
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
                              mainCurrentDialogShow = 0;
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
    mainCurrentDialogBody = _ratingDialogBuilding();

    setState(() {
      mainCurrentDialogShow = 1;
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
          mainCurrentDialogBody = _ratingDialogBuilding();
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
          mainCurrentDialogBody = _ratingDialogBuilding();
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

  openDialog(String _text) {
    mainCurrentDialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155),              // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: (){
              setState(() {
                mainCurrentDialogShow = 0;
              });
            }
        ),
      ],
    );

    setState(() {
      mainCurrentDialogShow = 1;
    });
  }

  _workTime(){
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: <Widget>[
            _oneitem(strings.get(70), "${_this.restaurant.openTimeMonday} - ${_this.restaurant.closeTimeMonday}"), // "Monday",
            _oneitem(strings.get(71), "${_this.restaurant.openTimeTuesday} - ${_this.restaurant.closeTimeTuesday}"), // "Tuesday",
            _oneitem(strings.get(72), "${_this.restaurant.openTimeWednesday} - ${_this.restaurant.closeTimeWednesday}"), // "Wednesday",
            _oneitem(strings.get(73), "${_this.restaurant.openTimeThursday} - ${_this.restaurant.closeTimeThursday}"), // "Thursday",
            _oneitem(strings.get(74), "${_this.restaurant.openTimeFriday} - ${_this.restaurant.closeTimeFriday}"), // "Friday",
            _oneitem(strings.get(75), "${_this.restaurant.openTimeSaturday} - ${_this.restaurant.closeTimeSaturday}"), // Saturday
            _oneitem(strings.get(76), "${_this.restaurant.openTimeSunday} - ${_this.restaurant.closeTimeSunday}"), // Sunday
          ],
        )
    );
  }

  _oneitem(String day, String time){
    return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(day, style: theme.text14),
            Text(time, style: theme.text14bold)
          ],
        ));
  }

}

