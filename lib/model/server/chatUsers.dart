import 'package:http/http.dart' as http;
import 'package:shopping/config/api.dart';
import 'dart:convert';
import '../dprint.dart';
import '../utils.dart';

chatUsers(String uid, Function(List<ChatUsers>, int) callback, Function(String) callbackError) async {

    try {
      var url = "${serverPath}chatUsers2";
      var response = await http.get(Uri.parse(url), headers: {
          'Authorization': 'Bearer $uid',
      }).timeout(const Duration(seconds: 30));

      dprint("api/chatUsers");
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        if (jsonResult['error'] == '0') {
          Response ret = Response.fromJson(jsonResult);
          callback(ret.users, ret.unread);
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
  List<ChatUsers> users;
  int unread;
  Response({this.error, this.users, this.unread});
  factory Response.fromJson(Map<String, dynamic> json){
    var m;
    if (json['users'] != null) {
      var items = json['users'];
      var t = items.map((f)=> ChatUsers.fromJson(f)).toList();
      m = t.cast<ChatUsers>().toList();
    }
    var _unread = 0;
    if (m != null)
      for (var item in m)
        _unread += item.unread;
    return Response(
      error: json['error'].toString(),
      users: m,
      unread: _unread,
    );
  }
}

class ChatUsers {
  String id;
  String name;
  String image;
  String count;
  int unread;
  String text;

  ChatUsers({this.id, this.name, this.image, this.count, this.unread, this.text});
  factory ChatUsers.fromJson(Map<String, dynamic> json){
    return ChatUsers(
      id: json['id'].toString(),
      name: json['name'].toString(),
      image: json['image'].toString(),
      count: json['count'].toString(),
      unread: toInt(json['unread'].toString()),
      text: json['text'].toString(),
    );
  }

  // int compareTo(ChatUsers b){
  //   if (unread > b.unread)
  //     return -1;
  //   if (unread < b.unread)
  //     return 1;
  //   return 0;
  // }
}
