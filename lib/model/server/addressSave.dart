import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'addressGet.dart';

saveAddress(
      String text, String lat, String lng, String type, String defaultAddress,
    String uid, Function(List<AddressData>) callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    var body = json.encoder.convert({
      'text': '$text',
      'lat': '$lat',
      'lng': '$lng',
      'type': '$type',
      'default': '$defaultAddress',
    });

    dprint('body: $body');
    var url = "${serverPath}saveAddress";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint("saveAddress");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        Response ret = Response.fromJson(jsonResult);
        callback(ret.address);
      }else
        callbackError("error=${jsonResult["error"]}");
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

