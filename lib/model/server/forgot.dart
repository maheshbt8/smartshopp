import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

forgotPassword(String email, Function() callback, Function(String) callbackError) async {
  try {

    var url = "${serverPath}forgot?email=$email";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': "application/json",
    }).timeout(const Duration(seconds: 30));

    dprint('$url');
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    var jsonResult = json.decode(response.body);
    if (response.statusCode == 500)
      return callbackError(jsonResult["message"].toString());

    if (response.statusCode == 200) {
      if (jsonResult["error"] == "0")
        callback();
      else
        callbackError(jsonResult["error"]);
    }else
      callbackError("statusCode=${response.statusCode}");

  } catch (ex) {
    callbackError(ex.toString());
  }
}

