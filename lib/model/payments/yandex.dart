
import 'package:flutter/material.dart';
// import 'package:fooddelivery/ui/main/home.dart';
// // import 'package:yandex_kassa/models/amount.dart';
// // import 'package:yandex_kassa/models/payment_parameters.dart';
// // import 'package:yandex_kassa/yandex_kassa.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../dprint.dart';

// для тестирования
// 4111111111111111	Visa - успешный платеж
// 5555555555554626	invalid_csc - неуспешный платеж

class YandexModel{

  final idempotenceKey = 'key' + DateTime.now().microsecondsSinceEpoch.toString();
  //var shopId = '715664';
  //var clientAppKey = 'test_NzE1NjY0vIzdhz23Bw3p0l6iqPDk7oBRwzRjZKSKK88';
  //var secretKey = 'test_Tjly3V5cTMrS8u-eN5FJEyYDCaHLgnvs3M1y9BL9GdE';

  handleCheckout(double amount, String email, BuildContext context, String name) async {

//     var shopId = homeScreen.mainWindowData.payments.yandexKassaShopId;
//     var clientAppKey = homeScreen.mainWindowData.payments.yandexKassaClientAppKey;
//     var secretKey = homeScreen.mainWindowData.payments.yandexKassaSecretKey;
//
//     final paymentParameters = PaymentParameters(
//         amount: Amount(amount),
//         purchaseName: "",
//         purchaseDescription: name,
//         clientApplicationKey: clientAppKey,
//         iosColorScheme: IosColorScheme.redOrange,
//         paymentMethods: [PaymentMethod.bankCard, PaymentMethod.sberbank],
//         applePayMerchantIdentifier: "merchant.ru.yandex.mobile.msdk.debug",
//         androidColorScheme: IosColorScheme.redOrange,
// //        iosTestModeSettings: IosTestModeSettings(charge: Amount(102.14)),
//         googlePayParameters: GooglePayCardNetwork.values,
//         shopId: shopId,
//         //returnUrl: 'https://your.return/url',
// //        androidTestModeSettings: AndroidTestModeSettings(
// //            mockConfiguration: AndroidMockConfiguration(
// //                serviceFee: Amount(102.14),
// //                paymentAuthPassed: true,
// //                completeWithError: false,
// //                linkedCardsCount: 3))
//     );
//
//     final result = await YandexKassa.startCheckout(paymentParameters);
//
//     TokenizationResult  tokenizationResult = result;
//
//     Map<String, String> requestHeaders = {
//       'Content-type': 'application/json',
//       'Idempotence-Key': idempotenceKey,
//       'Authorization': "Basic " + base64Encode(utf8.encode("$shopId:$secretKey")),
//     };
//     var body = json.encoder.convert({
//       'payment_token': tokenizationResult.paymentData.token,
//       'amount': paymentParameters.amount.jsonIso4217,
//         "confirmation": {
//             "type": "redirect",
//             "return_url":
//             "https://4081d9747ee2.ngrok.io/v1.3/verifications/yandex_checkout"
//           },
//       "metadata": {"my_key": "my_val"},
//       "description": paymentParameters.purchaseDescription
//     });
//
//     var url = "https://payment.yandex.net/api/v3/payments";
//     var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 10));
//
//     dprint(url);
//     dprint('Response status: ${response.statusCode}');
//     dprint('Response body: ${response.body}');
//
//     var jsonResult = json.decode(response.body);
//
//     if (jsonResult["paid"] == true)
//       return jsonResult["id"];

    return null;
  }

}

