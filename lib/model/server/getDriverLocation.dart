import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/model/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

getDriverLocation(String id, Function(double lat, double lng) callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    var body = json.encoder.convert({
      'driver': id,
    });
    var url = "${serverPath}getDriverLocation";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Send body: $body');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        callback(toDouble(jsonResult["lat"]), toDouble(jsonResult["lng"]));
      }else
        callbackError("error=${jsonResult["error"]}");
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    dprint(ex.toString());
    callbackError(ex.toString());
  }
}
