import 'package:http/http.dart' as http;
import 'package:shopping/config/api.dart';
import 'package:shopping/model/dprint.dart';
import 'dart:convert';

import '../utils.dart';

login(String email, String password,
    Function(String name, String password, String avatar, String email, String token, String phone, int unreadNotify, String) callback,
    Function(String) callbackError) async {

  try {
    var body = json.encoder.convert(
        {
          'email': '$email',
          'password': '$password',
        }
    );

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Content-Length': "${body.length}",
      // 'Host' : "madir.com.ng"
    };


    var url = "${serverPath}login";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint("login: $url, $body");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);
      if (ret.error == "0") {
        if (ret.data != null) {
          var path = "";
          if (ret.data.avatar != null && ret.data.avatar.toLowerCase() != "null")
            path = "$serverImages${ret.data.avatar}";
          callback(ret.data.name, password, path, email, ret.accessToken, ret.data.phone, ret.notify, ret.data.typeReg);
        }else
          callbackError("error:ret.data=null");
      }else
        callbackError(ret.error);
    }else
      callbackError("statusCode=${response.statusCode}");

  } catch (ex) {
    callbackError(ex.toString());
  }
}

class Response {
  String error;
  UserData data;
  String accessToken;
  int notify;
  Response({this.error, this.data, this.accessToken, this.notify});
  factory Response.fromJson(Map<String, dynamic> json){
    var a;
    if (json['user'] != null)
      a = UserData.fromJson(json['user']);
    return Response(
      error: json['error'].toString(),
      accessToken: json['access_token'].toString(),
      notify: toInt(json['notify'].toString()),
      data: a,
    );
  }
}

class UserData {
  String name;
  String phone;
  String avatar;
  String typeReg;
  UserData({ this.name, this.avatar, this.phone, this.typeReg});
  factory UserData.fromJson(Map<String, dynamic> json){
    return UserData(
      name: json['name'].toString(),
      avatar: json['avatar'].toString(),
      phone: json['phone'].toString(),
      typeReg: json['typeReg'].toString(),
    );
  }
}

