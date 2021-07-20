
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shopping/config/api.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/server/mainwindowdata.dart';

//
// action - favoritesAdd or favoritesDelete
//
favorites(String uid, String action, String id,
    Function() callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"food" : "$id"}';
    var url = "$serverPath$action";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        //Response ret = Response.fromJson(jsonResult);
        callback();
      }else
        callbackError("error=${jsonResult["error"]}");
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

getFavorites(String uid, Function(List<FavoritesData>, List<DishesData> food, String) callback, Function(String) callbackError) async {

  try {
    var url = "${serverPath}favoritesGet";
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $uid',
    }).timeout(const Duration(seconds: 30));


    dprint("api/favoritesGet");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == '0') {
        Response ret = Response.fromJson(jsonResult);
        callback(ret.favorites, ret.food, ret.currency);
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
  List<FavoritesData> favorites;
  List<DishesData> food;
  Response({this.error, this.favorites, this.food, this.currency});
  factory Response.fromJson(Map<String, dynamic> json){
    var m;
    if (json['favorites'] != null) {
      var items = json['favorites'];
      var t = items.map((f)=> FavoritesData.fromJson(f)).toList();
      m = t.cast<FavoritesData>().toList();
    }
    var _food;
    if (json['food'] != null) {
      var items = json['food'];
      var t = items.map((f)=> DishesData.fromJson(f)).toList();
      _food = t.cast<DishesData>().toList();
    }
    return Response(
      error: json['error'].toString(),
      currency: json['currency'].toString(),
      food: _food,
      favorites: m,
    );
  }
}

class FavoritesData {
  String food;
  FavoritesData({this.food});
  factory FavoritesData.fromJson(Map<String, dynamic> json){
    return FavoritesData(
      food: json['food'].toString(),
    );
  }
}
