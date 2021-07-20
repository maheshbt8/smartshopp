import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:shopping/ui/main/home/home.dart';

class PayStackModel{

  final plugin = PaystackPlugin();

  handleCheckout(double amount, String email, BuildContext context) async {

    await plugin.initialize(
        publicKey: homeScreen.mainWindowData.payments.payStackKey);

    Charge charge = Charge()
      ..amount = (amount * 100).toInt()
      ..email = email;
    //..card = _getCardFromUI();

//    if (!_isLocal()) {
//      var accessCode = await _fetchAccessCodeFrmServer(_getReference());
//      charge.accessCode = accessCode;
//    } else {
//      charge.reference = _getReference();
//    }
    charge.reference = 'PayStack_${DateTime.now().millisecondsSinceEpoch}';

    CheckoutResponse response = await plugin.checkout(context,
        method: CheckoutMethod.card, charge: charge, fullscreen: true, hideEmail: true);
    if (response.message == 'Success') {
      return response.reference;
    }
    return null;
  }

}

// Map<String, String> requestHeaders = {
//   'Content-type': 'application/json',
//   'Accept': "application/json",
//   'Authorization' : "Bearer pk_test_dadd8b613e4f7cafa9c6b1729ca1b7f78394bbb3",
// };
//
// var body = json.encoder.convert({
//   "amount": basket.getTotal(true),
//   'email': account.email,
//   "currency": "GHS",
//   "mobile_money": {
//     "phone" : account.phone,
//     "provider" : "mtn"
//   }});
//
// var url = "https://api.paystack.co/charge";
// var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));
// dprint('Response status: ${response.statusCode}');
// dprint('Response body: ${response.body}');
//
// if (response.statusCode == 200) {
// var jsonResult = json.decode(response.body);
// if (jsonResult["status"] == true) {
// _onSuccess("paystack");
// }
// }