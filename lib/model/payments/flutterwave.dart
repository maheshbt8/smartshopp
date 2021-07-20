import 'package:flutter/material.dart';
import 'package:flutterwave/core/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:shopping/ui/main/home/home.dart';

/*
  static const String NGN = "NGN";
  static const String KES = "KES";
  static const String RWF = "RWF";
  static const String UGX = "UGX";
  static const String ZMW = "ZMW";
  static const String GHS = "GHS";
  static const String XAF = "XAF";
  static const String XOF = "XOF";
 */

class FlutterWaveModel {

  String txref = "Ref";
  String amount = "";
  String currency = ""; //"NGN";

  handleCheckout(double _amount, String email, String currencyCode, BuildContext context,
      String phone, String userName, String orderId) async {

    currency = currencyCode;
    // currency = "NGN";
    txref = "id$orderId";
    amount = "$_amount";

    try {
      Flutterwave flutterwave = Flutterwave.forUIPayment(
          context: context,
          encryptionKey: homeScreen.mainWindowData.payments.flutterWaveEncryptionKey ,// "FLWSECK_TESTb2cb67422c66",
          publicKey: homeScreen.mainWindowData.payments.flutterWavePublicKey, //"FLWPUBK_TEST-02351a8bf2d056ea3722151c2aec5f43-X",
          currency: currency,
          amount: amount,
          email: email,
          fullName: userName,
          txRef: txref,
          isDebugMode: true,
          phoneNumber: phone,
          acceptCardPayment: true,
          acceptUSSDPayment: true,
          acceptAccountPayment: true,
          acceptFrancophoneMobileMoney: true,
          acceptGhanaPayment: true,
          acceptMpesaPayment: true,
          acceptRwandaMoneyPayment: true,
          acceptUgandaPayment: true,
          acceptZambiaPayment: true);

      final ChargeResponse response = await flutterwave.initializeForUiPayments();
      if (response != null)
        if (response.status == "success")
          return response.data.flwRef;
    } catch(error) {
      print(error);
    }

    return null;
  }
}
