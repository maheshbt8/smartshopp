import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:shopping/ui/main/home/home.dart';

/*

  https://pub.dev/packages/mercadopago_sdk/example

 */

class MercadoPagoModel {

  String error = "";

  handleCheckout(double amount, String email, String currencyCode) async {
// var mp = MP("6838333386915542", "p75GLxYxMPSTd2XLpJZ0LYkJJ91rN8zD");
    var mp = MP.fromAccessToken(
        //"TEST-6838333386915542-031815-40efe1228836302e5aad1897e586b9a3-140010600" // test
      //"APP_USR-6838333386915542-031815-b6287b830b6ef673da0168fc9a7de80a-140010600" // production
        homeScreen.mainWindowData.payments.mercadoPagoAccessToken
    );

    var preference = {
      "items": [
        {
          "title": "Products",
          "quantity": 1,
          "currency_id": homeScreen.mainWindowData.payments.code, //"USD",
          "unit_price": amount
        }
      ],
      "payer": {
    // "email": "payer@email.com"
        "email": email
      }
    };

    var result = await mp.createPreference(preference);
    var t = result["response"];
    if (t["status"] == 400) {
      error = t["message"];
      return null;
    }
    var id = t["id"];
    print(id);

    PaymentResult f = await MercadoPagoMobileCheckout.startCheckout(
      //"APP_USR-3eb03bbc-c34e-40bc-aa39-6ba354a329c6", // publicKey - production
      // "TEST-6e047891-69e8-4963-a7e4-9a368812b2a3", // publicKey - test
      homeScreen.mainWindowData.payments.mercadoPagoPublicKey,
      id,
    );
    if (f.result == "done")
      return f.id;
    return null;
  }
}
