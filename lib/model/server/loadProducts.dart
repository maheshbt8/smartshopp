import 'package:http/http.dart' as http;
import 'package:shopping/config/api.dart';
import 'package:shopping/model/dprint.dart';
import 'dart:convert';
import 'mainwindowdata.dart';

loadProducts(List<String> need, Function(List<DishesData>) callback, Function(String) callbackError) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': "application/json",
      };

      var body = json.encoder.convert({
        'need': need
      });

      dprint('body: $body');
      var url = "${serverPath}getFoods";
      var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

      dprint(url);
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        var ret = ResponseData.fromJson(jsonResult);
        callback(ret.foods);
      } else
        callbackError("statusCode=${response.statusCode}");
    } on Exception catch (ex) {
      callbackError(ex.toString());
    }
}

class ResponseData {
  String error;
  List<DishesData> foods;
  ResponseData({this.error, this.foods });
  factory ResponseData.fromJson(Map<String, dynamic> json){
    var _foods;
    if (json['foods'] != null) {
      var items = json['foods'];
      var t = items.map((f)=> DishesData.fromJson(f)).toList();
      _foods = t.cast<DishesData>().toList();
    }
    return ResponseData(
      error: json['error'].toString(),
      foods: _foods,
    );
  }
}
