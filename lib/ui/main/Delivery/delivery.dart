import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/server/addressGet.dart';
import 'package:fooddelivery/ui/main/Delivery/payments.dart';
import 'package:fooddelivery/ui/main/Delivery/widgets.dart';
import 'package:fooddelivery/widget/skinRoute.dart';
import 'address.dart';
import 'package:fooddelivery/model/pref.dart';
import 'package:fooddelivery/model/server/wallet.dart';
import 'package:fooddelivery/model/topRestourants.dart';
import 'package:fooddelivery/ui/main/home/home.dart';
import 'package:fooddelivery/ui/main/mainscreen.dart';
import 'package:fooddelivery/ui/main/vehicle.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/iinkwell.dart';
import 'package:fooddelivery/widget/iinputField2.dart';
import 'deliveryDate.dart';

String couponName = "";
var walletId = "";

class DeliveryScreen extends StatefulWidget {
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen>
    with SingleTickerProviderStateMixin {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  bool _deliveryAddressInit = false;
  String _deliveryAddress = "";
  double _deliveryLatitude = 0;
  double _deliveryLongitude = 0;
  int _currVal = 1;
  // bool _checkCurbsidePickup = false;
  bool _checkBoxValue2 = false;

  _setCurVal(int value){
    _currVal = value;
    _redraw();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _pressContinueButton() async {
    if (stage == 3)
      pay(_currVal, context, _waits, editControllerPhone.text, _openDialog, openDialog);
    if (stage == 2){
      stage = 3;
      _redraw();
    }
    if (stage == 4)
      Navigator.pop(context);
    if (stage == 1) {
      print("User pressed \"Continue\" button");
      print("phone: ${editControllerPhone.text}, comments: ${editControllerComments.text}");
      print("User pressed \"Next\" button");

      if (!_deliveryAddressInit && !basket.curbsidePickup)
        return openDialog(strings.get(184)); // "Select Address",
      if (editControllerPhone.text.isEmpty)
        return openDialog(strings.get(185)); // "Enter Phone number",
      // if (editControllerComments.text.isEmpty)
      //   return openDialog(strings.get(186)); // "Enter Comments",
      if (basket.curbsidePickup && _vehicleType.isEmpty && !_checkBoxValue2)
        return openDialog(strings.get(248)); // "Select Vehicle Type",
      stage = 2;
      pref.set(Pref.deliveryPhone, editControllerPhone.text);
      var text = "";
      if (deliveryDate.dateArrivedInit || _timeArrivedInit)
        text = "${strings.get(224)}";  // Arriving at
      if (deliveryDate.dateArrivedInit)
        text = "$text${deliveryDate.dateArrived}";
      if (_timeArrivedInit)
        text = "$text $_timeArrived";
      if (basket.curbsidePickup && !_checkBoxValue2)
        text = "$text - $_vehicleType";
      if (basket.curbsidePickup && _checkBoxValue2)
        text = "$text - ${strings.get(247)}";  // "Pickup from restaurant",
      if (_couponEnable)
        text = "$text - ${strings.get(258)}: $couponName"; // coupons
      text = "$text - ${strings.get(85)}: ${editControllerComments.text}"; // comments
      pref.set(Pref.deliveryHint, text);
      pref.set(Pref.deliveryAddress, editControllerAddress.text);
    }

    _redraw();
  }

  bool _wait = false;

  _waits(bool value){
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  _onBackClick(){
    if (stage == 1 || stage == 4)
      return Navigator.pop(context);
    if (stage == 2)
      stage = 1;
    if (stage == 3)
      stage = 2;
    setState(() {

    });
  }

  _openDialog(){
    walletSetId(account.token, walletId, basket.orderid, (){}, (String _){});
    _waits(false);
    stage = 4;
    setState(() {
    });
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  int stage = 1;
  var windowWidth;
  var windowHeight;
  final editControllerComments = TextEditingController();
  final editControllerPhone = TextEditingController();
  final editControllerAddress = TextEditingController();
  final editControllerCoupon = TextEditingController();
  int _areakm = -1;
  var restLat = 0.0;
  var restLng = 0.0;
  var _distanceToMax = false;
  var _vehicleType = "";


  _onError(String error) {
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  @override
  void initState() {
    pref.set(Pref.deliveryCurbsidePickup, "false");

    for (var rest in nearYourRestaurants)
      if (rest.id == basket.restaurant) {
        _areakm = rest.area;
        restLat = rest.lat;
        restLng = rest.lng;
      }

    getAddress(account.token, (List<AddressData> address) {
      for (var _data in address)
        if (_data.defaultAddress == "true"){
          _deliveryAddressInit = true;
          _deliveryAddress = _data.text;
          _deliveryLatitude = _data.lat;
          _deliveryLongitude = _data.lng;
          editControllerAddress.text = _deliveryAddress;
          editControllerAddress.selection = TextSelection.fromPosition(
            TextPosition(offset: editControllerAddress.text.length),
          );
          _initDistance();
          setState(() {});
        }
    }, _onError);

    editControllerPhone.text = pref.get(Pref.deliveryPhone);
    if (pref.get(Pref.deliveryPhone).isEmpty)
      editControllerPhone.text = account.phone;

    super.initState();
  }

  double distance = 0;

  _initDistance() async {
    // if (_areakm != -1){
      pref.set(Pref.deliveryLatitude, _deliveryLatitude.toString());
      pref.set(Pref.deliveryLongitude, _deliveryLongitude.toString());
      distance = await homeScreen.location.distanceBetween(_deliveryLatitude, _deliveryLongitude, restLat, restLng);
      if (distance == -1)
        return;
      if (appSettings.distanceUnit == "km")
        distance = distance/1000;
      else
        distance = distance/1609.34;
      basket.distance = distance;
      if (distance > _areakm)
        _distanceToMax = true;
      else
        _distanceToMax = false;
      setState(() {
      });
    // }
  }

  @override
  void dispose() {
    route.disposeLast();
    editControllerComments.dispose();
    editControllerPhone.dispose();
    editControllerAddress.dispose();
    editControllerCoupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () async {
          _onBackClick();
          return false;
        },
    child: Scaffold(
      backgroundColor: theme.colorBackground,
      body: Directionality(
        textDirection: strings.direction,
        child: Stack(
        children: <Widget>[

          Align(
              child: Container (
                child: ListView(
                  children: _getList(),
                ),)
          ),

          Container(
            alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10),
              child: IInkWell(child: _iconBackWidget(), onPress: _onBackClick,)
          ),

          if (_wait)
            skinWait(context, true),

          IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
            body: _dialogBody, backgroundColor: theme.colorBackground,),

        ],
      ),
    )));
  }

  _iconBackWidget(){
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
      child: UnconstrainedBox(
          child: Container(
              height: 25,
              width: 25,
              child: Image.asset("assets/back.png",
                fit: BoxFit.contain, color: theme.colorDefaultText,
              )
          )),
    );
  }

  _getList(){
    List<Widget> list = [];
    deliveryScreenHeader(list, stage);

    if (stage == 1) {
      _body(list);
      list.add(SizedBox(height: 50,));
      if (basket.curbsidePickup)
        list.add(buttonPressOrContinue(windowWidth, _pressContinueButton, stage));
      else
        if (!_distanceToMax)
          list.add(buttonPressOrContinue(windowWidth, _pressContinueButton, stage));

      list.add(SizedBox(height: 150,));
    }

    if (stage == 2)  // information summary
      informationSummaryScreen(list, windowWidth, editControllerAddress.text, _couponEnable, _pressContinueButton, stage);

    if (stage == 3)  // payments gateway list
      paymentsGatewayList(list, windowWidth, _currVal, _setCurVal, _pressContinueButton, stage);

    if (stage == 4)
      finishWidget(list, windowWidth, windowHeight);

    return list;
  }

  _body(List<Widget> list){
    marketAddressText(list, basket.getShopInfo(), windowWidth);

    if (appSettings.curbsidePickup == "true"){
      list.add(Container(
          margin: EdgeInsets.only(left: 5),
          child: Row(
            children: [
              Checkbox(
                value: basket.curbsidePickup,
                activeColor: theme.colorPrimary,
                checkColor: theme.colorDefaultText,
                onChanged: (bool value){
                  pref.set(Pref.deliveryCurbsidePickup, value.toString());
                  setState(() {
                    basket.curbsidePickup = value;
                  });
                },
              ),
              Text(strings.get(201), style: theme.text14bold,) // I will take the food myself
            ],
          )
      ));
    }

    //
    if (!basket.curbsidePickup && appSettings.delivering == "true") {
      list.add(Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Text(
            strings.get(182), style: theme.text14bold,) // Delivery Address
      ));

      var _text = "Latitude: ${_deliveryLatitude.toStringAsFixed(6)}, Longitude: ${_deliveryLongitude.toStringAsFixed(6)}";
      list.add(Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Text((_deliveryAddressInit) ? _text : strings.get(183),
            style: theme.text14,) // "no address",
      ));

      if (_deliveryAddressInit){
        list.add(Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
          child: IInputField2(hint : strings.get(48),  // "Address",
            icon : Icons.location_city,
            controller : editControllerAddress,
            type : TextInputType.text,
            colorDefaultText: theme.colorDefaultText,
            colorBackground: theme.colorBackgroundDialog,
          ),
        ));

        if (_distanceToMax){
          distanceTooMaxText(list, distance, _areakm);    // distance too max
        }else{
          if (basket.perkm == '1')
            deliveryFeePerKm(list); // Delivery fee : 10$ per km
        }
        deliveryDistanceText(list, basket.getShopInfo(), editControllerAddress.text); // from address - to address and distance
      }

      list.add(IButton3(pressButton: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddressScreen(callback: (String text, double lat, double lng) {
                      _deliveryAddressInit = true;
                      _deliveryAddress = text;
                      _deliveryLatitude = lat;
                      _deliveryLongitude = lng;
                      pref.set(Pref.deliveryAddressInit, "true");
                      pref.set(Pref.deliveryAddress, _deliveryAddress);
                      pref.set(Pref.deliveryLatitude, _deliveryLatitude.toString());
                      pref.set(Pref.deliveryLongitude, _deliveryLongitude.toString());
                      editControllerAddress.text = _deliveryAddress;
                      editControllerAddress.selection = TextSelection.fromPosition(
                        TextPosition(offset: editControllerAddress.text.length),
                      );
                      _initDistance();
                      setState(() {
                      });
                    })
            ));
      },
        text: strings.get(184), // Select Address
        color: theme.colorPrimary,
        textStyle: theme.text16boldWhite,));
      list.add(SizedBox(height: 10));

    }else {
      if (appSettings.curbsidePickup == "true") {
        list.add(Container(
            margin: EdgeInsets.only(left: 5),
            child: Row(
              children: [
                Checkbox(
                  value: _checkBoxValue2,
                  activeColor: theme.colorPrimary,
                  checkColor: theme.colorDefaultText,
                  onChanged: (bool value) {
                    setState(() {
                      _checkBoxValue2 = value;
                    });
                  },
                ),
                Text(strings.get(247), style: theme.text14bold,)
                // "Pickup from restaurant",
              ],
            )

        ));

        if (!_checkBoxValue2) {
          list.add(Container(
              color: theme.colorPrimary.withAlpha(40),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: Text(strings.get(202),
                    // When your order will be ready, you will receive a message ...
                    style: theme.text14,)
              )
          ));
          list.add(Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    width: windowWidth * 0.7,
                    child: IButton3(
                        color: theme.colorPrimary,
                        text: strings.get(225), // "Enter Vehicle Information",
                        textStyle: theme.text14boldWhite,
                        pressButton: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VehicleScreen(callback: (String text) {
                                        _vehicleType = text;
                                        setState(() {});
                                      })
                              ));
                        }
                    )),
              ],
            ),
          ));
          if (_vehicleType.isNotEmpty) {
            list.add(SizedBox(height: 20,));
            list.add(Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(_vehicleType, style: theme.text16,)
            ));
          }
        }
      }
    }

    list.add(SizedBox(height: 30,));

    if (appSettings.otp == "true") {
      list.add(Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
        child: Row(children: [
          Text(strings.get(106), style: theme.text16bold), // Phone
          SizedBox(width: 10,),
          Text(editControllerPhone.text, style: theme.text16)
        ],)
      ));
    }else{
      list.add(Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
        child: IInputField2(hint : strings.get(106),                      // Phone",
          icon : Icons.phone,
          controller : editControllerPhone,
          type : TextInputType.phone,
          colorDefaultText: theme.colorDefaultText,
          colorBackground: theme.colorBackgroundDialog,
        ),
      ));
    }

    list.add(Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: IInputField2(hint : strings.get(85),                      // Comments",
        icon : Icons.chat,
        controller : editControllerComments,
        type : TextInputType.text,
        colorDefaultText: theme.colorDefaultText,
        colorBackground: theme.colorBackgroundDialog,
      ),
    ));

    if (appSettings.coupon == "true")
      couponWidget(list, editControllerCoupon, _couponEnable, _onCouponEnter);

    if (appSettings.deliveringDate == "true")
      deliveryDate.changeDeliveryDate(list, windowWidth,
      (double value){setState(() {
        _show = value;
      });
      }, (Widget body){_dialogBody = body;});
    if (appSettings.deliveringTime == "true")
      changeDeliveryTime(list, openDialogTime, _timeArrivedInit, _timeArrived);

    list.add(SizedBox(height: 30,));
  }

  var deliveryDate = DeliveryDate();

  double _show = 0;
  Widget _dialogBody = Container();
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

  String _timeArrived = "";
  bool _timeArrivedInit = false;

  openDialogTime() {
    var hour = DateTime.now().hour+2;
    _timeArrived = "$hour:00";
    var widget = CupertinoDatePicker(
        key: UniqueKey(),
      onDateTimeChanged: (DateTime picked) {
        var h = picked.hour.toString();
        if (picked.hour.toString().length == 1)
          h = "0$h";
        var m = picked.minute.toString();
        if (picked.minute.toString().length == 1)
          m = "0$m";
        _timeArrived = "$h:$m";
        dprint("$_timeArrived");
      },
      use24hFormat: true,
      initialDateTime: DateTime(0, 0, 0, hour, 0),
      //minimumDate: DateTime.now().subtract(Duration(days: 1)),
        minuteInterval: 10,
     // maximumDate: DateTime(2018, 12, 30, 13, 0),
      minimumDate: DateTime(0, 0, 0, hour, 0),
//      minimumYear: 2010,
//      maximumYear: 2022,
//      minuteInterval: 1,
      mode: CupertinoDatePickerMode.time,
    );

    _dialogBody = Column(
      children: [
        Row(
          children: [
            Container(
                width: windowWidth/2-25,
                child: IButton3(
                    color: theme.colorBackgroundGray,
                    text: strings.get(221),              // Now
                    textStyle: theme.text14,
                    pressButton: (){
                      setState(() {
                        _show = 0;
                      });
                    }
                )),
            SizedBox(width: 10,),
            Container(
                width: windowWidth/2-25,
                child: IButton3(
                    color: theme.colorPrimary,
                    text: strings.get(222),              // Later
                    textStyle: theme.text14boldWhite,
                    pressButton: (){
                      setState(() {
                      });
                    }
                )),
          ],
        ),
        SizedBox(height: 30,),
        Container(
          width: windowWidth,
            height: 200,
            child: widget,
        ),
        SizedBox(height: 30,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(223),              // Confirm
            textStyle: theme.text14boldWhite,
            pressButton: (){
              setState(() {
                _timeArrivedInit = true;
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

  bool _couponEnable = false;

  _onCouponEnter(String value){
    _couponEnable = false;
    for (var coupon in homeScreen.mainWindowData.coupons)
      if (value.toUpperCase() == coupon.name.toUpperCase()) {
        var dateStart = DateTime.parse(coupon.dateStart);
        var dateEnd = DateTime.parse(coupon.dateEnd);
        var t = dateStart.isBefore(DateTime.now());
        var m = dateEnd.isAfter(DateTime.now());
        if (t && m) {
          _couponEnable = true;
          couponName = value;
          basket.setCoupon(coupon);
        }
      }
    if (!_couponEnable)
      basket.setCoupon(null);
    setState(() {
    });
  }
}