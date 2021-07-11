import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

getNotify(String uid, Function(List<Notifications>) callback, Function(String) callbackError) async {

    try {
      var url = "${serverPath}notify";
      var response = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
        'Accept': "application/json",
        'Authorization': 'Bearer $uid',
      }).timeout(const Duration(seconds: 30));

      dprint("api/notify");
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        if (jsonResult['error'] == '0') {
          Response ret = Response.fromJson(jsonResult);
          callback(ret.notify);
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
  List<Notifications> notify;
  Response({this.error, this.notify});
  factory Response.fromJson(Map<String, dynamic> json){
    var m;
    if (json['notify'] != null) {
      var items = json['notify'];
      var t = items.map((f)=> Notifications.fromJson(f)).toList();
      m = t.cast<Notifications>().toList();
    }
    return Response(
      error: json['error'].toString(),
      notify: m,
    );
  }
}

class Notifications {
  String id;
  String date;
  String title;
  String text;
  String image;

  Notifications({this.id, this.date, this.title, this.text, this.image});
  factory Notifications.fromJson(Map<String, dynamic> json){
    return Notifications(
      id: json['id'].toString(),
      date: json['updated_at'].toString(),
      title: json['title'].toString(),
      text: json['text'].toString(),
      image: json['image'].toString(),
    );
  }
}
