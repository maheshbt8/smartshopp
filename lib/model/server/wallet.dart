import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

getWalletBalance(String uid, Function(double) callback, Function(String) callbackError) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{}';

    var url = "${serverPath}walletgb";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint("walletgb");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == 0) {
        callback(double.parse(jsonResult['balance']));
      }else
        callbackError("error=${jsonResult['error']}");
    } else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

walletTopUp(String uid, String total, String id, Function(double) callback, Function(String) callbackError) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"total" : "$total", "id" : "$id"}';

    dprint('body: $body');
    var url = "${serverPath}walletTopUp";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint("walletTopUp");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == 0) {
        callback(double.parse(jsonResult['balance']));
      }else
        callbackError("error=${jsonResult['error']}");
    } else
      callbackError("statusCode=${response.statusCode}");

  } catch (ex) {
    callbackError(ex.toString());
  }
}

payOnWallet(String uid, String total, Function(String) callback, Function(String) callbackError) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"total" : "$total"}';

    dprint('body: $body');
    var url = "${serverPath}payOnWallet";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint("payOnWallet");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == 0) {
        callback(jsonResult['id']);
      }else
        callbackError(jsonResult['msg']);
    } else
      callbackError("statusCode=${response.statusCode}");

  } catch (ex) {
    callbackError(ex.toString());
  }
}

walletSetId(String uid, String walletId, String orderId, Function() callback, Function(String) callbackError) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"walletId":"$walletId", "orderId":"$orderId"}';

    dprint('body: $body');
    var url = "${serverPath}walletSetId";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint("walletSetId");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == 0) {
        callback();
      }else
        callbackError(jsonResult['msg']);
    } else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

