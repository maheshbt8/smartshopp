
import 'package:http/http.dart' as http;
import 'package:shopping/config/api.dart';
import 'package:shopping/model/dprint.dart';
import 'dart:convert';

import 'package:shopping/model/server/mainwindowdata.dart';

String _lastSearch = "";

getSearch(String search, Function(List<DishesData>, String) callback, Function(String) callbackError) async {
  _lastSearch = search;
  try {
      var url = "${serverPath}search?search=$search";
      var response = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
        'Accept': "application/json",
      }).timeout(const Duration(seconds: 30));

      dprint("api/search");
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        if (jsonResult['error'] == '0') {
          Response ret = Response.fromJson(jsonResult);
          if (_lastSearch == ret.search)
            callback(ret.foods, ret.currency);
        }else
          callbackError("error=${jsonResult['error']}");
      } else
        callbackError("statusCode=${response.statusCode}");
    } catch (ex) {
      callbackError(ex.toString());
    }
}

class Response {
  String error;
  String currency;
  String search;
  List<DishesData> foods;
  Response({this.error, this.foods, this.currency, this.search});
  factory Response.fromJson(Map<String, dynamic> json){
    var m;
    if (json['foods'] != null) {
      var items = json['foods'];
      var t = items.map((f)=> DishesData.fromJson(f)).toList();
      m = t.cast<DishesData>().toList();
    }
    return Response(
      error: json['error'].toString(),
      search: json['search'].toString(),
      currency: json['currency'].toString(),
      foods: m,
    );
  }
}
