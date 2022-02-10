import 'package:http/http.dart' as http;
import 'package:shopping/config/api.dart';
import 'package:shopping/model/dprint.dart';
import 'dart:convert';

import 'mainwindowdata.dart';

loadSecondStep(Function(SecondStepData) callback, Function(String) callbackError) async {

    try {
      var url = "${serverPath}getSecondStep";
      var response = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
        'Accept': "application/json",
        // 'Host' : "madir.com.ng"
      }).timeout(const Duration(seconds: 30));

      dprint(url);
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        callback(SecondStepData.fromJson(jsonResult));
      } else
        callbackError("statusCode=${response.statusCode}");
    } on Exception catch (ex) {
      callbackError(ex.toString());
    }

}

class SecondStepData {
  String error;
  List<BannerData> banner1;
  List<BannerData> banner2;
  List<DishesData> foods;
  SecondStepData({this.error, this.banner1, this.foods, this.banner2, });
  factory SecondStepData.fromJson(Map<String, dynamic> json){
    var _banner1;
    if (json['banner1'] != null) {
      var items = json['banner1'];
      var t = items.map((f)=> BannerData.fromJson(f)).toList();
      _banner1 = t.cast<BannerData>().toList();
    }
    var _banner2;
    if (json['banner2'] != null) {
      var items = json['banner2'];
      var t = items.map((f)=> BannerData.fromJson(f)).toList();
      _banner2 = t.cast<BannerData>().toList();
    }
    var _foods;
    if (json['foods'] != null) {
      var items = json['foods'];
      var t = items.map((f)=> DishesData.fromJson(f)).toList();
      _foods = t.cast<DishesData>().toList();
    }
    return SecondStepData(
      error: json['error'].toString(),
      foods: _foods,
      banner1: _banner1,
      banner2: _banner2,
    );
  }
}

class BannerData {
  String id;
  String image;
  String type;
  String details;
  String position;
  BannerData({this.id, this.image, this.type, this.details, this.position});

  factory BannerData.fromJson(Map<String, dynamic> json){
    return BannerData(
      id: json['id'].toString(),
      image: "$serverImages${json['image'].toString()}",
      type: json['type'].toString(),
      details: json['details'].toString(),
      position: json['position'].toString(),
    );
  }
}
