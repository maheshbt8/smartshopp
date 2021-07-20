import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/ui/main/home/home.dart';

class StripeModel{

  init(){
    Stripe.publishableKey = homeScreen.mainWindowData.payments.stripeKey;
    Stripe.merchantIdentifier = 'test';
  }

  // init(){
  //   var stripeId = homeScreen.mainWindowData.payments.stripeKey;
  //   StripePayment.setOptions(
  //       StripeOptions(
  //           publishableKey: stripeId,
  //           merchantId: "Test", //YOUR_MERCHANT_ID
  //           androidPayMode: 'test'
  //       ));
  // }


  // Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
  //   var stripeSecret = homeScreen.mainWindowData.payments.stripeSecretKey;
  //
  //   try {
  //     Map<String, String> requestHeaders = {
  //       'Content-type': 'application/x-www-form-urlencoded',
  //       'Authorization' : "Bearer $stripeSecret",
  //     };
  //
  //     Map<String, dynamic> body= {"amount": amount, "currency" : currency, "payment_method_types[]": "card"};
  //     var url = "https://api.stripe.com/v1/payment_intents";
  //     var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 10));
  //
  //     dprint(url);
  //     dprint('Response status: ${response.statusCode}');
  //     dprint('Response body: ${response.body}');
  //
  //     return json.decode(response.body);
  //   } catch (ex) {
  //     print (ex);
  //   }
  //   return null;
  // }
  //
  // Function(String) _onError;
  //
  // Future<void> openCheckoutCard(int amount, String desc, String clientPhone, String companyName, String currency,
  //     Function(String) onSuccess, Function(String) onError) async {
  //   _onError = onError;
  //     var paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).catchError(setError);
  //     print(paymentMethod);
  //     Map<String, dynamic> paymentIntent = await createPaymentIntent(amount.toString(), currency);
  //     if (paymentIntent == null)
  //       return onError("error1");
  //     dprint(paymentIntent.toString());
  //     var sec = paymentIntent['client_secret'];
  //     var response = await StripePayment.confirmPaymentIntent(
  //       PaymentIntent(
  //         clientSecret: sec,
  //         paymentMethodId: paymentMethod.id,
  //       ),
  //     ).catchError(setError);
  //     print(response);
  //     onSuccess("Payment $currency${amount/100} Stripe:${response.paymentIntentId}");
  //     return true;
  // }
  //
  // setError(dynamic error){
  //   if (_onError != null)
  //     _onError(error.code); // may be cancelled
  //   dprint(error);
  // }


  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency, String stripeSecret) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Authorization' : "Bearer $stripeSecret",
      };
      Map<String, dynamic> body= {"amount": amount, "currency" : currency, "payment_method_types[]": "card"};
      var url = "https://api.stripe.com/v1/payment_intents";
      var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 10));
      dprint(url);
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');
      return json.decode(response.body);
    } catch (ex) {
      print (ex.toString());
    }
    return null;
  }

  Future<bool> openCheckoutCard(int amount, String desc, String clientPhone, String companyName, String currency, String stripeSecret,
      Function(String) onSuccess) async {

    try {
      Map<String, dynamic> paymentIntent = await createPaymentIntent(amount.toString(), currency, stripeSecret);
      if (paymentIntent == null)
        return false;
      print(paymentIntent.toString());

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          applePay: true,
          googlePay: true,
          style: ThemeMode.dark,
          testEnv: true,
          // merchantCountryCode: 'UK',
          // merchantDisplayName: 'Stripe Store Demo',
          customerId: paymentIntent['customer'],
          paymentIntentClientSecret: paymentIntent['client_secret'],
          // customerEphemeralKeySecret: paymentIntent['ephemeralKey'],
        ),
      );

      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
            clientSecret: paymentIntent['client_secret'],
            confirmPayment: true,
          ));
      print("Payment $currency${amount/100} stripe:${paymentIntent["id"]}");
      onSuccess("Payment $currency${amount/100} stripe:${paymentIntent["id"]}");
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

}