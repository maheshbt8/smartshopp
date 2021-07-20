import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping/config/api.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/server/mainwindowdata.dart';
import 'package:shopping/model/topRestourants.dart';
import 'package:shopping/ui/main/Delivery/widgetDetails.dart';
import 'package:shopping/widget/iCard27.dart';
import 'package:shopping/widget/ibutton3.dart';
import 'package:shopping/widget/iinputField2.dart';
import 'package:shopping/widget/itemBasketText.dart';
import '../home/home.dart';
import '../mainscreen.dart';

distanceTooMaxText(List<Widget> list, double distance, int _areakm){
  list.add(Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Text("${strings.get(218)} ${distance.toStringAsFixed(3)} ${appSettings.distanceUnit} ${strings.get(261)}", style: theme.text16Red,) // ""Note!\тThe delivery distance is very long."",
  )
  );
  for (var item in nearYourRestaurants)
    if (item.id == basket.restaurant) {
      list.add(Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Text(
            "${strings.get(259)} ${item.name} ${strings.get(260)} $_areakm ${appSettings.distanceUnit}", style: theme.text14,) // "The Restaurant: ",
      ));
      break;
    }
}

marketAddressText(List<Widget> list, Restaurants rest, double windowWidth){
  if (rest == null)
    return;

  list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(children: [
        Text("${strings.get(267)}: ", style: theme.text14bold),       // "Restaurant", name
        Expanded(child: Text("${rest.name}", style: theme.text14, overflow: TextOverflow.clip,)),
      ],)));
  list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 8),
      child: Row(children: [
        Text("${strings.get(48)}: ", style: theme.text14bold),       // Address
        Expanded(child: Text("${rest.address}", style: theme.text14, overflow: TextOverflow.clip,)),
      ],)));
  list.add(Container(
    margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
    height: 0.5, width: windowWidth, color: Colors.black.withAlpha(120),));
}

deliveryFeePerKm(List<Widget> list){
  list.add(Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text("${strings.get(301)}: ${basket.makePriceString(basket.fee)} "
                    "${strings.get(300)} ${appSettings.distanceUnit}", style: theme.text14bold,)), // Delivery fee
                Text(basket.makePriceString(basket.getShoppingCost(true)), style: theme.text14R,)
              ],
            ),
            SizedBox(height: 20,)
          ])
  ));
}

deliveryDistanceText(List<Widget> list, rest, String toAddress){
  list.add(Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Column(
          children: [
            Row(
              children: [
                Text(strings.get(302), style: theme.text14bold,     // From
                ),
                Expanded(child: Text("${rest.address}", style: theme.text14, overflow: TextOverflow.clip, maxLines: 2, textAlign: TextAlign.right,)),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              children: [
                Text(strings.get(303), style: theme.text14bold,     // To
                ),
                Expanded(child: Text(toAddress, style: theme.text14, overflow: TextOverflow.clip, maxLines: 2, textAlign: TextAlign.right,)),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              children: [
                Text(strings.get(304), style: theme.text14bold,     // Distance
                ),
                Expanded(child: Text("${basket.distance.toStringAsFixed(3)} ${appSettings.distanceUnit}", style: theme.text14, overflow: TextOverflow.clip, maxLines: 2, textAlign: TextAlign.right,)),
              ],
            ),
            SizedBox(height: 20,)
          ])
  ));
}

couponWidget(List<Widget> list, editControllerCoupon, _couponEnable, _onCouponEnter){
  list.add(Container(
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
    child: IInputField2(hint : strings.get(258),                      // Coupon
      icon : Icons.art_track,
      controller : editControllerCoupon,
      type : TextInputType.text,
      colorDefaultText: theme.colorDefaultText,
      colorBackground: theme.colorBackgroundDialog,
      onChangeText: _onCouponEnter,
    ),
  ));
  if (_couponEnable)
    list.add(_drawCoupon());
}

_drawCoupon(){
  List<Widget> list = [];
  var t2 = basket.getSubTotal(true);
  var t = basket.getSubTotal(false);

  list.add(SizedBox(height: 5,));
  if (basket.couponComment.isNotEmpty)
    list.add(Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Text(basket.couponComment, style: theme.text14R, textAlign: TextAlign.center,),
    )
    );

  list.add(_itemTextLine(strings.get(93), basket.makePriceString(t), basket.makePriceString(t2),));  // "Subtotal",
  list.add(SizedBox(height: 5,));
  list.add(_itemTextLine(strings.get(94), basket.makePriceString(basket.getShoppingCost(false)),
    basket.makePriceString(basket.getShoppingCost(true)),));                            // "Shopping costs",
  list.add(SizedBox(height: 5,));
  list.add(_itemTextLine(strings.get(95), basket.makePriceString(basket.getTaxes(false)),
      basket.makePriceString(basket.getTaxes(true))));  // "Taxes",
  list.add(SizedBox(height: 5,));
  list.add(_itemTextLine(strings.get(96), basket.makePriceString(basket.getTotal(false)),
    basket.makePriceString(basket.getTotal(true)),));  // "Total",

  list.add(SizedBox(height: 15,));

  return Container(
      color: Colors.black.withAlpha(40),
      child: Column(children: list,));
}

_itemTextLine(String leftText, String rightText, String rightText2){
  return Container(
    margin: EdgeInsets.only(left: 20, right: 20),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Text(leftText, style: theme.text14,),
        ),
        Text(rightText, style: theme.text14l,),
        SizedBox(width: 5,),
        Text(rightText2, style: theme.text16Red,),
      ],
    ),
  );
}

paymentsGatewayList(List<Widget> list, double windowWidth, int _currVal, Function(int) setCurVal,
    Function() _pressContinueButton, stage){
  list.add(SizedBox(height: 20,));
  list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: _row(strings.get(188), strings.get(194))    //  "Payment" - "All transactions are secure and encrypted.",
  ));
  list.add(SizedBox(height: 20,));

  if (homeScreen.mainWindowData.payments.cacheEnable == "true") {
    list.add(_item("assets/payment1.png", 1, strings.get(189), windowWidth, _currVal, setCurVal)); // cache on delivery
    list.add(SizedBox(height: 10,));
  }
  if (appSettings.walletEnable == "true") {
    list.add(_item("assets/payment6.png", 6, "${strings.get(10)} ${strings.get(206)}", windowWidth, _currVal, setCurVal)); // "Wallet",
    list.add(SizedBox(height: 10,));
  }
  // paymob
  if (homeScreen.mainWindowData.payments.payMobEnable == "true") {
    list.add(_item("assets/payment10.png", 10, "PayMob", windowWidth, _currVal, setCurVal)); // PayMob
    list.add(SizedBox(height: 10,));
  }
  //
  if (homeScreen.mainWindowData.payments.payPalEnable == "true") {
    list.add(_item("assets/payment5.png", 5, strings.get(249), windowWidth, _currVal, setCurVal)); // payPal
    list.add(SizedBox(height: 10,));
  }
  if (homeScreen.mainWindowData.payments.payStackEnable == "true") {
    list.add(_item("assets/payment7.png", 7, strings.get(251), windowWidth, _currVal, setCurVal)); // payStack
    list.add(SizedBox(height: 10,));
  }
  if (homeScreen.mainWindowData.payments.stripeEnable == "true") {
    list.add(_item("assets/payment2.png", 4, strings.get(192), windowWidth, _currVal, setCurVal)); // "Visa, Mastercard",
    list.add(SizedBox(height: 10,));
  }
  if (homeScreen.mainWindowData.payments.razEnable == "true") {
    list.add(_item("assets/payment4.png", 3, strings.get(191), windowWidth, _currVal, setCurVal)); // razorpay
    list.add(SizedBox(height: 10,));
  }
  if (homeScreen.mainWindowData.payments.yandexKassaEnable == "true") {
    list.add(_item("assets/payment8.png", 8, strings.get(265), windowWidth, _currVal, setCurVal)); // Yandex kassa
    list.add(SizedBox(height: 10,));
  }
  if (homeScreen.mainWindowData.payments.instamojoEnable == "true") {
    list.add(_item("assets/payment9.png", 9, strings.get(266), windowWidth, _currVal, setCurVal)); // "Instamojo",
    list.add(SizedBox(height: 10,));
  }
  if (homeScreen.mainWindowData.payments.mercadoPagoEnable == "true") {
    list.add(_item("assets/payment11.png", 11, "Mercado Pago", windowWidth, _currVal, setCurVal)); // Mercado Pago
    list.add(SizedBox(height: 10,));
  }
  if (homeScreen.mainWindowData.payments.flutterWaveEnable == "true") {
    list.add(_item("assets/payment12.png", 12, "FlutterWave", windowWidth, _currVal, setCurVal)); // FlutterWave
    list.add(SizedBox(height: 10,));
  }
  //
  list.add(SizedBox(height: 20,));
  list.add(buttonPressOrContinue(windowWidth, _pressContinueButton, stage));
  list.add(SizedBox(height: 150,));
}

_row(String text1, String text2){
  return Container(
      child: Row(
        children: [
          Icon(Icons.done, color: Colors.green, size: 20,),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text1, style: theme.text14bold,),
              SizedBox(height: 5,),
              Text(text2, style: theme.text14,)
            ],
          )
        ],
      )
  );
}

_item(String image, int index, String text, double windowWidth, int _currVal, Function(int) setCurVal){
  var _align = Alignment.centerLeft;
  if (strings.direction == TextDirection.rtl)
    _align = Alignment.centerRight;

  return Container(
      color: theme.colorBackgroundGray,
      child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Expanded(child: Container(
                  child: RadioListTile(
                    activeColor: theme.colorCompanion,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(text, style: theme.text14,),
                            )),
                        Container(
                            alignment: _align,
                            child: UnconstrainedBox(
                                child: Container(
                                  //height: windowWidth*0.1,
                                    width: windowWidth*0.2,
                                    child: Container(
                                      child: Image.asset(image,
                                          fit: BoxFit.contain
                                      ),
                                    )))
                        )
                      ],
                    ),
                    groupValue: _currVal,
                    value: index,
                    onChanged: (val) {
                      setCurVal(val);
                    },
                  ))),

            ],
          )


      )
  );
}


buttonPressOrContinue(double windowWidth, Function() _pressContinueButton, stage){
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.only(left: windowWidth*0.15, right: windowWidth*0.15),
    child: IButton3(pressButton: _pressContinueButton,
      text: (stage == 3) ? strings.get(118) : strings.get(18),            // Done or Continue
      color: theme.colorPrimary,
      textStyle: theme.text16boldWhite,),
  );
}

deliveryScreenHeader(List<Widget> list, stage){
  list.add(SizedBox(height: 15,));
  list.add(ICard27(
    colorActive: theme.colorPrimary,
    colorInactive: theme.colorDefaultText.withOpacity(0.5),
    stage: stage, icons: [Icons.location_on, Icons.info_rounded, Icons.credit_card, Icons.check_circle],
  ));
  list.add(SizedBox(height: 15,));
  list.add(Container(height: 1, color: theme.colorGrey,));
  list.add(SizedBox(height: 30,));
}

changeDeliveryTime(List<Widget> list, Function() openDialogTime, bool _timeArrivedInit, String _timeArrived){
  var _time = strings.get(219); // Arriving in 30-60 min
  if (_timeArrivedInit)
    _time = "${strings.get(224)}$_timeArrived"; // "Arriving at ";
  list.add(SizedBox(height: 20,));
  list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: row2(_time, strings.get(220), openDialogTime) //  Arriving in 30-60 min - "Change >",
  ));
}

row2(String text1, String text2, Function() openDialogTime){
  return InkWell(
      onTap: () {
        openDialogTime();
      },
      child: Container(
          child: Row(
            children: [
              Icon(Icons.done, color: Colors.green, size: 20,),
              SizedBox(width: 20,),
              Expanded(child: Text(text1, style: theme.text14bold,)),
              Text(text2, style: theme.text14,)
            ],
          )
      ));
}

finishWidget(List<Widget> list, double windowWidth, double windowHeight){
  list.add(Container(
      color: Colors.black.withAlpha(60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          Container(
            width: windowWidth,
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text(strings.get(252), style: theme.text16, textAlign: TextAlign.center,), // "It's ordered!",
          ),
          SizedBox(height: 5,),
          Container(
            width: windowWidth,
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("${strings.get(253)}${basket.orderid}", textAlign: TextAlign.start, style: theme.text14,), // "Order No. #",
          ),
          SizedBox(height: 15,),
        ],
      )
  ));

  list.add(SizedBox(height: 25,));
  list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.centerLeft,
      child: Text(strings.get(254), style: theme.text16bold,)  // "You've successfully placed the order",
  ));
  list.add(SizedBox(height: 35,));
  list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.centerLeft,
      child: Text(strings.get(255), style: theme.text14,)  // You can check status of your...
  ));
  list.add(SizedBox(height: windowHeight*0.2,));
  list.add(IButton3(
      color: theme.colorPrimary, text: strings.get(256).toUpperCase(), textStyle: theme.text14boldWhite,
      pressButton: (){
        mainScreenState.onBack("orders");
        // route.mainScreen.route("orders");
        // route.popToMain(context);
      }) // Show All my orders
  );
  // pressButton: _pressContinueButton
  list.add(SizedBox(height: 10,));
  list.add(IButton3(
    color: theme.colorPrimary, text: strings.get(257).toUpperCase(), textStyle: theme.text14bold, onlyBorder: true,
    pressButton: (){          // "Back to shop",
      mainScreenState.onBack("home");
      // route.mainScreen.route("home");
      // route.popToMain(context);
    },)
  );
  //  list.add(_button());
}

informationSummaryScreen(List<Widget> list, double windowWidth, String toText, _couponEnable,
    _pressContinueButton, stage) {
  for (var item in basket.basket){
    list.add(Container(
      margin: EdgeInsets.only(left: 16, right: 15),
      child: WidgetDetails(
      width: windowWidth,
      height: 100,
      title: item.name,
      price: basket.getItemPriceText(item),
      image: "$serverImages${item.image}"
    )));
    list.add(SizedBox(height: 20, ));
  }

  list.add(SizedBox(height: 30, ));

  if (!basket.curbsidePickup)
    deliveryDistanceText(list, basket.getShopInfo(), toText); // from address - to address and distance

  if (basket.getCoupon() != null && (basket.getSubTotal(true) != basket.getSubTotal(false))) {
    list.add(Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      color: Colors.black.withAlpha(40),
      child: Text("${strings.get(258)}: ${basket.getCoupon().name}", style: theme.text16bold,),));  // Coupon
    list.add(_drawCoupon());
    list.add(SizedBox(height: 20, ));
  }else{
    var t = basket.getSubTotal(false);
    list.add(itemBasketText(strings.get(93), basket.makePriceString(t), false));  // "Subtotal",
    list.add(SizedBox(height: 5,));
    if (!basket.curbsidePickup){
      if (basket.perkm == '1')
        list.add(itemBasketText("${strings.get(94)} ${basket.makePriceString(basket.fee)} ${strings.get(300)} ${appSettings.distanceUnit}",
            "${basket.makePriceString(basket.getShoppingCost(true))}", false));   // "Shopping costs",   10$ per km
      else
        list.add(itemBasketText(strings.get(94), basket.makePriceString(basket.getShoppingCost(false)), false));   // "Shopping costs",
    }else{
      list.add(itemBasketText(strings.get(94), basket.makePriceString(0), false));   // "Shopping costs",
    }
    list.add(SizedBox(height: 5,));
    list.add(itemBasketText(strings.get(95), basket.makePriceString(basket.getTaxes(false)), false));  // "Taxes",
    list.add(SizedBox(height: 5,));
    list.add(itemBasketText(strings.get(96), basket.makePriceString(basket.getTotal(false)), true));  // "Total",
  }

  list.add(SizedBox(height: 50,));
  list.add(buttonPressOrContinue(windowWidth, _pressContinueButton, stage));
  list.add(SizedBox(height: 150,));
}


