import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping/config/api.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/server/mainwindowdata.dart';
import 'package:shopping/model/topRestourants.dart';
import 'package:shopping/ui/main/mainscreen.dart';
import 'package:shopping/widget/BasketItem.dart';
import 'package:shopping/widget/ibutton3.dart';
import 'package:shopping/widget/ilist1.dart';
import 'package:shopping/widget/itemBasketText.dart';
import 'package:shopping/widget/skinRoute.dart';

class BasketScreen extends StatefulWidget {
  final Function(String) onBack;
  BasketScreen({Key key, this.onBack}) : super(key: key);
  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> with TickerProviderStateMixin{

  ///////////////////////////////////////////////////////////////////////////////
  //
  // Increment and Decrement
  //
  _onItemChangeCount(String id, int value){
    print("Increment item. id: $id, new value: $value");
    basket.setCount(id, value);
    setState(() {
    });
  }

  _onItemDelete(String id){
    print("Delete item. id: $id");
    basket.deleteFrmBasket(id);
    setState(() {
    });
  }

  _pressCheckoutButton(){
    print("User pressed Checkout");
    if (basket.basket.isEmpty)
      return;
    if (!account.isAuth())
      route.push(context, "/login");
    else
      route.push(context, "/delivery");
  }

  ///////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;

  @override
  void dispose() {
    route.disposeLast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Directionality(
        textDirection: strings.direction,
        child: Container(
        color: theme.colorBackground,
        child: Stack(
        children: <Widget>[

        if (basket.inBasket() != 0)
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+40),
            child: ListView(
              children: _getDataActive(),
            ),
          ),

          skinHeader(context, widget.onBack, strings.get(98)), // Basket

          if (basket.inBasket() != 0)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: theme.colorBackground,
                  borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),


              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _bottomBar()
              ),
            ),
          ),

          if (basket.inBasket() == 0)
              _noItems(),
        ],
      ),

    )));
  }

  Column _noItems(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Container(
              width: windowWidth,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              alignment: Alignment.center,
              child: Text(strings.get(86),                              // There is no item in your cart
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: theme.colorDefaultText,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ))),

          Container(
              width: windowWidth,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              alignment: Alignment.center,
              child: Text(strings.get(87),                  // Check out our new items and update your collection
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: theme.colorDefaultText,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ))),

          SizedBox(height: 20,),

    Container(
    margin: EdgeInsets.only(left: 30, right: 30),
    child: IButton3(text: strings.get(88), textStyle: theme.text14boldWhite,      // Continue Shopping
            color: theme.colorPrimary, pressButton: (){widget.onBack("home");},
          ))
          //_buttonContinueShopping(),

        ]);
  }

  List<Widget> _bottomBar(){
    List<Widget> list = [];
    var t = basket.getSubTotal(false);
    list.add(itemBasketText(strings.get(93), basket.makePriceString(t), false));  // "Subtotal",
    list.add(SizedBox(height: 5,));
    if (basket.perkm == '1')
      list.add(itemBasketText(strings.get(94), "${basket.makePriceString(basket.fee)} ${strings.get(300)} ${appSettings.distanceUnit}", false));   // "Shopping costs",   10$ per km
    else
      list.add(itemBasketText(strings.get(94), basket.makePriceString(basket.getShoppingCost(false)), false));   // "Shopping costs",
    list.add(SizedBox(height: 5,));
    list.add(itemBasketText(strings.get(95), basket.makePriceString(basket.getTaxes(false)), false));  // "Taxes",
    list.add(SizedBox(height: 5,));
    list.add(itemBasketText(strings.get(96), basket.makePriceString(basket.getTotal(false)), true));  // "Total",

    var _color = theme.colorPrimary;
    var restaurant = getRestaurant(basket.restaurant);
    if (restaurant != null) {
      if (restaurant.minimumAmount != 0){
        if (basket.getTotal(false) < restaurant.minimumAmount){
          list.add(Container(
            margin: EdgeInsets.only(top: 10),
            child: Text("${strings.get(294)}: ${basket.makePriceString(restaurant.minimumAmount)}", style: theme.text16Red), // Minimum order amount
          ));
          _color = Colors.black.withAlpha(100);
        }
      }
    }

    list.add(SizedBox(height: 15,));
    list.add(Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      child: IButton3(text: strings.get(97), textStyle: theme.text14boldWhite,
        enable: (_color == theme.colorPrimary),
        color: _color, pressButton: _pressCheckoutButton,             // Checkout
      ),
    ));
    list.add(SizedBox(height: 15,));
    return list;
  }

  List<Widget> _getDataActive(){
    List<Widget> list = [];

    list.add(Container(
      child: ListWithIcon(imageAsset: "assets/shop.png", icon: Icons.shopping_cart, text: strings.get(99),), // "Shopping Cart",
    ));
    list.add(Container(
      margin: EdgeInsets.only(top: 10, left: 35, right: 35),
      child: Text(strings.get(100), style: theme.text14,), // "Verify your quantity and click checkout",
    ));

    var restaurant = getRestaurant(basket.restaurant);
    if (restaurant != null) {
      list.add(SizedBox(height: 10,));
      list.add(Container(height: 0.5, color: theme.colorDefaultText.withAlpha(100),));
      list.add(SizedBox(height: 10,));
      if (theme.multiple){
        list.add(Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            child: Row(
              children: [
                Text("${strings.get(267)}: ", style: theme.text14bold,), // Restaurant
                Text(restaurant.name, style: theme.text14,),
              ],
            )
          ));
      }
    }

    list.add(SizedBox(height: 20,));

    for (var item in basket.basket)
      if (item.count != 0) {
        list.add(_item(item));
        list.add(SizedBox(height: 10,));
      }

    list.add(SizedBox(height: 225,));
    return list;
  }

  _item(DishesData item){
    var _title = item.name;
    var _count = 0;
    double _total = item.price*item.count;
    if (item.discountprice != null && item.discountprice != 0)
      _total = item.discountprice*item.count;
    for (var ex in item.extras)
      if (ex.select) {
        _count++;
        _total += (ex.price*item.count);
      }
    if (_count != 0)
      _title = "${item.name} ${strings.get(197)} $_count ${strings.get(198)}"; // name and 3 items

    List<Widget> list = [];

    list.add(BasketItem(
      color: theme.colorBackground,
      width: windowWidth,
      height: 90,
      title1: _title,
      price: basket.makePriceString(_total),
      image: "$serverImages${item.image}",
      incDec: _onItemChangeCount,
      delete: _onItemDelete,
      id: item.id,
      count: item.count,
      getCount: basket.getCount,
    ));

    var first = true;
    for (var ex in item.extras){
      if (ex.select){
        if (first){
          list.add(SizedBox(height: 10,));
          first = false;
          var t = basket.makePriceString(item.price);
          list.add(Container(
            margin: EdgeInsets.only(left: windowWidth*0.30),
            child: Text("${item.name} ${item.count} x $t", style: theme.text14bold,)
          ));
        }
        list.add(SizedBox(height: 5,));
        var t = basket.makePriceString(ex.price);
        list.add(Container(
            margin: EdgeInsets.only(left: windowWidth*0.30),
            child: Text("+ ${ex.name} ${item.count} x $t", style: theme.text14bold,))
        );
      }
    }
    if (!first)
      list.add(SizedBox(height: 10,));
    if (theme.appSkin == "smarter") {
      list.add(SizedBox(height: 10,));
      list.add(Container(height: 1, color: theme.sGreyColor));
      list.add(SizedBox(height: 20,));
      return Container(
          decoration: BoxDecoration(
              color: theme.colorBackground,
              // border: Border.all(color: Colors.black.withAlpha(100)),
              borderRadius: new BorderRadius.circular(appSettings.radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(appSettings.shadow),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list,
          )
      );
    }
    return Container(
      decoration: BoxDecoration(
          color: theme.colorBackground,
          border: Border.all(color: Colors.black.withAlpha(100)),
          borderRadius: new BorderRadius.circular(appSettings.radius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(appSettings.shadow),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(2, 2), // changes position of shadow
            ),
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      )
    );
  }


}

