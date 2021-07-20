import 'package:http/http.dart' as http;
import 'package:shopping/config/api.dart';
import 'package:shopping/model/dprint.dart';
import 'dart:convert';

import '../utils.dart';

getAddress(String uid, Function(List<AddressData>) callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{}';

    var url = "${serverPath}getAddress";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint("getAddress");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        Response ret = Response.fromJson(jsonResult);
        callback(ret.address);
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
  List<AddressData> address;
  Response({this.error, this.address});
  factory Response.fromJson(Map<String, dynamic> json){
    var _address;
    if (json['address'] != null){
      var items = json['address'];
      var t = items.map((f)=> AddressData.fromJson(f)).toList();
      _address = t.cast<AddressData>().toList();
    }
    return Response(
      error: json['error'].toString(),
      address: _address,
    );
  }
}

class AddressData {
  String id;
  String updatedAt;
  String text;
  double lat;
  double lng;
  String type;
  String defaultAddress;
  //
  bool selected;

  AddressData({this.id, this.updatedAt, this.text, this.lat, this.lng, this.type,
    this.defaultAddress, this.selected = false});
  factory AddressData.fromJson(Map<String, dynamic> json) {
    return AddressData(
      id : json['id'].toString(),
      updatedAt: json['updated_at'].toString(),
      text: json['text'].toString(),
      lat: toDouble(json['lat'].toString()),
      lng: toDouble(json['lng'].toString()),
      type: json['type'].toString(),
      defaultAddress: json['default'].toString(),
    );
  }
}
