import 'package:flutter/material.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/model/payments/flutterwave.dart';
import 'package:fooddelivery/model/payments/instamojo/InstaMojoPayment.dart';
import 'package:fooddelivery/model/payments/mercadopago.dart';
import 'package:fooddelivery/model/payments/paymob/PayMobMainScreen.dart';
// import 'package:fooddelivery/model/payments/mercadopago.dart';
// import 'package:fooddelivery/model/payments/paymob/PayMobPayment.dart';
import 'package:fooddelivery/model/payments/paypal/PaypalPayment.dart';
import 'package:fooddelivery/model/payments/paystack.dart';
import 'package:fooddelivery/model/payments/razorpay.dart';
import 'package:fooddelivery/model/payments/stripe.dart';
import 'package:fooddelivery/model/payments/yandex.dart';
import 'package:fooddelivery/model/server/wallet.dart';
import 'package:fooddelivery/model/utils.dart';
import 'package:fooddelivery/ui/main/home/home.dart';
import 'package:fooddelivery/ui/main/mainscreen.dart';
import '../../../main.dart';
import '../../../model/homescreenModel.dart';
import '../../../model/pref.dart';
import 'delivery.dart';

Function(bool) _waits;
Function() _openDialog;
Function(String) openDialog;

pay(int _currVal, BuildContext context, Function(bool) waits, String phone,
    Function() _openDialog2, Function(String) openDialog2) async {
  _openDialog = _openDialog2;
  openDialog = openDialog2;
  _waits = waits;

  if (_currVal == 1) {
     _onSuccess("Cash on Delivery");
  }

  var razorpayCompanyName = homeScreen.mainWindowData.payments.razName;
  var code = homeScreen.mainWindowData.payments.code;
  if (_currVal == 3) { // razorpay
    RazorpayModel _razorpayModel = RazorpayModel();
    _razorpayModel.init();
    double _total = basket.getTotal(true) * 100;
    var t = _total.toInt();
    var phone = pref.get(Pref.deliveryPhone);
    _razorpayModel.openCheckout(
        t.toString(), basket.getDesc(), phone, razorpayCompanyName, code,
        _onSuccess, _onError
    );
  }
  if (_currVal == 7) { // payStack
    var paystack = PayStackModel();
    var ret = await paystack.handleCheckout(basket.getTotal(true), account.email, context);
    if (ret != null)
      _onSuccess(ret);
  }
  if (_currVal == 5) { // paypal
    String _total = basket.getTotal(true).toStringAsFixed(appSettings.symbolDigits);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaypalPayment(
            currency: code,
            userFirstName: "",
            userLastName: "",
            userEmail: "",
            payAmount: _total,
            secret: homeScreen.mainWindowData.payments.payPalSecret,
            clientId: homeScreen.mainWindowData.payments.payPalClientId,
            sandBoxMode: homeScreen.mainWindowData.payments.payPalSandBoxMode,
            onFinish: (w){
              _onSuccess("PayPal: $w");
            }
        ),
      ),
    );
  }
  if (_currVal == 4) { // mastercard
    _waits(true);
    StripeModel _stripe = StripeModel();
    _stripe.init();
    double _total = basket.getTotal(true) * 100;
    var t = _total.toInt();
    var phone = pref.get(Pref.deliveryPhone);
    try {
      await _stripe.openCheckoutCard(
          t, basket.getDesc(), phone, razorpayCompanyName, code, homeScreen.mainWindowData.payments.stripeSecretKey,
          _onSuccess, //_onError
      );
    }catch(ex){
      dprint(ex.toString());
      _onError(ex.toString());
    }
  }
  if (_currVal == 6){       // wallet
    payOnWallet(account.token, basket.getTotal(true).toString(), _onSuccessWallet, _onError2);
  }
  if (_currVal == 8) { // yandex kassa
    _waits(true);
    var yandex = YandexModel();
    try {
      String total = basket.getTotal(true).toStringAsFixed(2);
      var t = double.parse(total);
      var ret = await yandex.handleCheckout(t, account.email, context, basket.getDesc());
      _waits(false);
      if (ret != null)
        _onSuccess("YandexKassa: $ret");
    }catch(ex ){
      _waits(false);
    }
  }
  if (_currVal == 9) { // instamojo
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstaMojoPayment(
            userName: account.userName,
            email: account.email,
            phone: phone,
            payAmount: basket.getTotal(true).toStringAsFixed(appSettings.symbolDigits),
            token: homeScreen.mainWindowData.payments.instamojoPrivateToken,
            apiKey: homeScreen.mainWindowData.payments.instamojoApiKey,
            sandBoxMode: homeScreen.mainWindowData.payments.instamojoSandBoxMode,
            onFinish: (w){
              _onSuccess("INSTAMOJO: $w");
            }
        ),
      ),
    );
  }
  if (_currVal == 10) { // payMob
    String _total = basket.getTotal(true).toStringAsFixed(appSettings.symbolDigits);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayMobMainScreen(
            userFirstName: account.userName,
            userEmail: account.email,
            userPhone: account.phone,
            payAmount: _total,
            apiKey: homeScreen.mainWindowData.payments.payMobApiKey,
            frame: homeScreen.mainWindowData.payments.payMobFrame,
            integrationId: homeScreen.mainWindowData.payments.payMobIntegrationId,
            onFinish: (w){
              dprint("PayMob: $w");
              _onSuccess("PayMob: $w");
            }
        ),
      ),
    );
  }
  if (_currVal == 11) { // MercadoPago
    var mercado = MercadoPagoModel();
    var ret = await mercado.handleCheckout(toDouble(basket.getTotal(true).toStringAsFixed(appSettings.symbolDigits)), account.email, code);
    if (ret != null)
      _onSuccess("MP: $ret");
    else
      openDialog("${strings.get(128)} ${mercado.error}"); // "Something went wrong. ",
  }

  if (_currVal == 12) { // FlutterWave
    var ret = await FlutterWaveModel().handleCheckout(toDouble(basket.getTotal(true).toStringAsFixed(appSettings.symbolDigits)),
        account.email, code, context, account.phone, account.userName, basket.orderid);
    if (ret != null)
      _onSuccess("FW: $ret");
  }
}

_onSuccess(String id){
  _waits(true);
  var curbsidePickup = pref.get(Pref.deliveryCurbsidePickup);
  var addr = pref.get(Pref.deliveryAddress);
  var phone = pref.get(Pref.deliveryPhone);
  var hint = pref.get(Pref.deliveryHint);
  var lat = pref.get(Pref.deliveryLatitude);
  var lng = pref.get(Pref.deliveryLongitude);
  basket.createOrder(id, addr, phone, hint, lat, lng, curbsidePickup, couponName, _openDialog, _onError);
}

_onSuccessWallet(String id){
  walletId = id;
  _waits(true);
  var curbsidePickup = pref.get(Pref.deliveryCurbsidePickup);
  var addr = pref.get(Pref.deliveryAddress);
  var phone = pref.get(Pref.deliveryPhone);
  var hint = pref.get(Pref.deliveryHint);
  var lat = pref.get(Pref.deliveryLatitude);
  var lng = pref.get(Pref.deliveryLongitude);
  basket.createOrder("wallet#$id", addr, phone, hint, lat, lng, curbsidePickup, couponName, _openDialog, _onError);
}

_onError(String err){
  _waits(false);
  if (err == "ERROR: 2")
    return;
  if (err == "cancelled")
    return;
  openDialog("${strings.get(128)} $err"); // "Something went wrong. ",
}

_onError2(String err){
  _waits(false);
  openDialog(err); // "Something went wrong. ",
}