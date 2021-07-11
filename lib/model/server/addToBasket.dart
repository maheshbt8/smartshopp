import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'mainwindowdata.dart';

addToBasket(List<DishesData> basket, String uid, String tax, String hint, String restaurant, String method,  // method = Cash on Delivery
    String fee, String send, String address, String phone, double total, String lat, String lng, String curbsidePickup,
    String couponName,
    Function(String id, String, String, String) callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    var first = true;
    var data = "[";
    for (var item in basket) {
      if (!item.delivered) {
        if (!first) data += ',';
        data += item.toJSON();
        if (first) first = false;
      }
    }
    data += ']';

    var _total = total.toStringAsFixed(2).toString();
    String body = '{"total": "$_total", "address": ${json.encode(address)}, "phone": "$phone", "pstatus": "Waiting for client", '
        '"lat" : "$lat", "lng" : "$lng", "curbsidePickup" : "$curbsidePickup", '
        '"send": "$send", "tax": "$tax", "hint": ${json.encode(hint)}, "couponName" : ${json.encode(couponName)}, "restaurant": ${json.encode(restaurant)}, '
        '"method": "$method", "fee": "$fee", "data": $data}';

    dprint('body: $body');
    var url = "${serverPath}addToBasket";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint("addToBasket");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        var perkm = "";
        if (jsonResult["perkm"] != null)
          perkm = jsonResult["perkm"].toString();
        callback(jsonResult["orderid"].toString(), jsonResult["fee"].toString(), jsonResult["percent"].toString(), perkm);
      }else
        callbackError("error=${jsonResult["error"]}");
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}


