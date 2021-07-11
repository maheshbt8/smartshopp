import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

changeProfile(String uid, String name, String email, String phone,
    Function() callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"name" : ${json.encode(name)}, "email": ${json.encode(email)}, "phone": ${json.encode(phone)}}';
    var url = "${serverPath}changeProfile";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        callback();
      }else
        callbackError(jsonResult["error"]);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}
