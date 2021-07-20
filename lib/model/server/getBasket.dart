import 'package:http/http.dart' as http;
import 'package:shopping/config/api.dart';
import 'dart:convert';

import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/utils.dart';

getBasket(String uid, Function(BasketResponse) callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{}';
    var url = "${serverPath}getBasket";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        BasketResponse ret = BasketResponse.fromJson(jsonResult);
        callback(ret);
        //callback(ret.order, ret.orderdetails, ret.currency, ret.defaultTax, ret.fee, ret.percent);
      }else
        callbackError("error=${jsonResult["error"]}");
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class BasketResponse {
  String error;
  String ver;
  String currency;
  double defaultTax;
  OrderData order;
  List<OrderDetailsData> orderdetails;
  double fee;
  String percent;
  String perkm;

  BasketResponse({this.error, this.order, this.orderdetails, this.currency, this.defaultTax, this.fee,
    this.percent, this.ver, this.perkm});
  factory BasketResponse.fromJson(Map<String, dynamic> json){
    var _order;
    if (json['order'] != null)
      _order = OrderData.fromJson(json['order']);
    var _orderdetails;
    if (json['orderdetails'] != null) {
      var items = json['orderdetails'];
      var t = items.map((f)=> OrderDetailsData.fromJson(f)).toList();
      _orderdetails = t.cast<OrderDetailsData>().toList();
    }
    return BasketResponse(
      error: json['error'].toString(),
      defaultTax: toDouble(json['default_tax'].toString()),
      currency: json['currency'].toString(),
      order: _order,
      orderdetails: _orderdetails,
      fee: toDouble(json['fee'].toString()),
      percent: json['percent'].toString(),
      perkm: (json['perkm'] == null) ? "" : json['perkm'].toString(),
      ver: (json['ver'] == null) ? '1' : json['ver'].toString(),
    );
  }
}

class OrderData {
  String id;
  String user;
  String driver;
  String status;
  String pstatus;
  int tax;
  String hint;
  String active;
  String restaurant;
  String method;
  String total;
  String fee;

  OrderData({this.id, this.user, this.driver, this.status, this.pstatus, this.tax,
    this.hint, this.active, this.restaurant, this.method, this.total, this.fee});
  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id : json['id'].toString(),
      user: json['user'].toString(),
      driver: json['driver'].toString(),
      status: json['status'].toString(),
      pstatus: json['pstatus'].toString(),
      tax: toInt(json['tax'].toString()),
      hint: json['hint'].toString(),
      active: json['active'].toString(),
      restaurant: json['restaurant'].toString(),
      method: json['method'].toString(),
      total: json['total'].toString(),
      fee: json['fee'].toString(),
    );
  }
}


class OrderDetailsData {
  String id;
  String order;
  String food;
  int count;
  double foodprice;
  String extras;
  String extrascount;
  String extrasprice;
  String foodid;
  String extrasid;
  String image;
  String category;

  OrderDetailsData({this.id, this.order, this.food, this.count, this.foodprice, this.extras, this.extrascount,
    this.extrasprice, this.foodid, this.extrasid, this.image, this.category});
  factory OrderDetailsData.fromJson(Map<String, dynamic> json) {
    return OrderDetailsData(
      id : json['id'].toString(),
      order : json['order'].toString(),
      food : json['food'].toString(),
      count : toInt(json['count'].toString()),
      foodprice : toDouble(json['foodprice'].toString()),
      extras : json['extras'].toString(),
      extrascount : json['extrascount'].toString(),
      extrasprice : json['extrasprice'].toString(),
      foodid : json['foodid'].toString(),
      extrasid : json['extrasid'].toString(),
      image : json['image'].toString(),
      category : json['category'].toString(),
    );
  }
}


