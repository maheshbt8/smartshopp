import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Category {

  get(String id, Function(List<DishesData>, String, String, String, String) callback,
      Function(String) callbackError) async {

    try {

      var url = "${serverPath}category?category=$id";
      var response = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
        'Accept': "application/json",
      }).timeout(const Duration(seconds: 30));

      dprint("api/category");
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        if (jsonResult['error'] == '0') {
          Response ret = Response.fromJson(jsonResult);
          callback(ret.foods, ret.currency, ret.desc, "$serverImages${ret.image}", ret.name);
        } else
          callbackError("error=${jsonResult['error']}");
      } else
        callbackError("statusCode=${response.statusCode}");
    } catch (ex) {
      callbackError(ex.toString());
    }
  }
}

class Response {
  String error;
  String desc;
  String name;
  String image;
  String currency;
  List<DishesData> foods;
  Response({this.error, this.foods, this.currency, this.desc, this.name, this.image});
  factory Response.fromJson(Map<String, dynamic> json){
    var m;
    if (json['foods'] != null) {
      var items = json['foods'];
      var t = items.map((f)=> DishesData.fromJson(f)).toList();
      m = t.cast<DishesData>().toList();
    }
    return Response(
        error: json['error'].toString(),
        currency: json['currency'].toString(),
        foods: m,
        desc: json['desc'].toString(),
        name: json['name'].toString(),
        image: json['image'].toString(),
    );
  }
}

