import 'package:http/http.dart' as http;
import 'package:shopping/config/api.dart';
import 'package:shopping/model/dprint.dart';
import 'dart:convert';

import 'mainwindowdata.dart';

reviewsFoodAdd(String uid, String food, String rate, String desc,
    Function(String, List<FoodsReviews>) callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"food": "$food", "rate": "$rate", "desc": "$desc"}';
    var url = "${serverPath}foodReviewsAdd";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        Response ret = Response.fromJson(jsonResult);
        callback(ret.date, ret.reviews);
      }else
        callbackError("error=${jsonResult["error"]}");
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class Response {
  String error;
  String date;
  List<FoodsReviews> reviews;
  Response({this.error, this.date, this.reviews});
  factory Response.fromJson(Map<String, dynamic> json){
    var n;
    if (json['reviews'] != null) {
      var items = json['reviews'];
      var t = items.map((f) => FoodsReviews.fromJson(f)).toList();
      n = t.cast<FoodsReviews>().toList();
    }
    return Response(
      error: json['error'].toString(),
      date: json['date'].toString(),
      reviews: n
    );
  }
}

reviewsRestaurantAdd(String uid, String restaurant, String rate, String desc,
    Function(String, List<RestaurantsReviewsData>) callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"restaurant": "$restaurant", "rate": "$rate", "desc": "$desc"}';
    var url = "${serverPath}restaurantReviewsAdd";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        var ret = ResponseR.fromJson(jsonResult);
        callback(ret.date, ret.reviews);
      }else
        callbackError("error=${jsonResult["error"]}");
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class ResponseR {
  String error;
  String date;
  List<RestaurantsReviewsData> reviews;
  ResponseR({this.error, this.date, this.reviews});
  factory ResponseR.fromJson(Map<String, dynamic> json){
    var n;
    if (json['reviews'] != null) {
      var items = json['reviews'];
      var t = items.map((f) => RestaurantsReviewsData.fromJson(f)).toList();
      n = t.cast<RestaurantsReviewsData>().toList();
    }
    return ResponseR(
        error: json['error'].toString(),
        date: json['date'].toString(),
        reviews: n
    );
  }
}
