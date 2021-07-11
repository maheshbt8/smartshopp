import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

docLoad(String doc, Function(String) callback, Function() callbackError) async {

  try {
    var url = "${serverPath}getDocuments?doc=$doc";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': "application/json",
    }).timeout(const Duration(seconds: 30));

    dprint("api/getDocuments");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"].toString() == "0")
        return callback(jsonResult["doc"].toString());
    }
    callbackError();
  } catch (ex) {
    callbackError();
  }
}
