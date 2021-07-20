import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart';
import 'package:shopping/config/api.dart';
import 'package:shopping/model/dprint.dart';

uploadAvatar(String _avatarFile, String uid, Function(String) callback, Function(String) callbackError) async {

  //
  // resize image
  //
  try{
    Image image = decodeImage(File(_avatarFile).readAsBytesSync());
    dprint("uploadAvatar decodeImage");
    Image thumbnail = copyResize(image, width: 300);
    File(_avatarFile)
      ..writeAsBytesSync(encodeJpg(thumbnail));

    Map<String, String> requestHeaders = {
      'Accept': "application/json",
      'Content-type': 'application/json',
      'Authorization': "Bearer $uid"
    };
    var url = "${serverPath}uploadAvatar";
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll(requestHeaders);
    var pic = await http.MultipartFile.fromPath("file", _avatarFile);
    request.files.add(pic);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    dprint("uploadAvatar $request");
    dprint(responseString);
    var jsonResult = json.decode(responseString);
    Response ret = Response.fromJson(jsonResult);
    if (ret.ret == "true") {
      var path = "";
      if (ret.filename != null)
        path = "$serverImages${ret.filename}";
      callback(path);
    }
    else
      callbackError(ret.filename);
  } catch (ex) {
    callbackError(ex.toString());
  }

}

class Response {
  String ret;
  String filename;
  Response({this.ret, this.filename});
  factory Response.fromJson(Map<String, dynamic> json){
    return Response(
      ret: json['ret'].toString(),
      filename: json['avatar'],
    );
  }
}
