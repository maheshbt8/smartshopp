import 'dart:convert';
import 'dart:core';
import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../dprint.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


class PayUPayment extends StatefulWidget {
  final Function onFinish;
  final String userName;
  final String email;
  final String phone;
  final String payAmount;
  final String apiKey;
  final String token;
  final String sandBoxMode;

  PayUPayment({this.onFinish, this.userName, this.email, this.phone, this.payAmount,
        this.apiKey, this.token, this.sandBoxMode});

  @override
  State<StatefulWidget> createState() {
    return PayUPaymentState();
  }
}

class PayUPaymentState extends State<PayUPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  var paymentResponse;
  List<String> payResponse = [];

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String cancelURL = 'www.example.com';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await getAccessToken(widget.userName, widget.payAmount, widget.apiKey,
            widget.token, widget.sandBoxMode, widget.email, widget.phone);
        
        if (accessToken != null) {
          setState(() {
            checkoutUrl = accessToken;
            executeUrl = accessToken;
          });
        }else {
          final snackBar = SnackBar(
            content: Text(errorText),
            duration: Duration(seconds: 10),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
          // _scaffoldKey.currentState.showSnackBar(snackBar);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  Widget appBar(title) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=> Navigator.pop(context)),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18.0,
            color: theme.colorDefaultText,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != null) {
      return Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: appBar(strings.get(266)), // "Instamojo",
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            dprint (request.url);
            if (request.url.contains(cancelURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['payment_id'];
              if (payerID != null) {
                widget.onFinish(uri.queryParameters['payment_id']);
                dprint(uri.queryParameters['payment_id']);
                Future.delayed(const Duration(milliseconds: 5000), () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                });
                return NavigationDecision.prevent;
              }
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }


  Future<String> getAccessToken(String userName, String amount, String apiKey, String token, String sandboxMode, String email, String phone) async {
    // https://secure.payu.com/
    // https://secure.snd.payu.com/
    var url = " https://secure.payu.ru/api/v4/payments/authorize";
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        "Content-Type": "application/x-www-form-urlencoded",
        "X-Header-Signature": apiKey,
        "X-Header-Merchant": token,
        "X-Header-Date": token

      };
      Map<String, String> body = {
        "amount": amount, //amount to be paid
        "purpose": "Advertising",
        "buyer_name": userName,
        "email": email,
        "phone": phone,
        "allow_repeated_payments": "true",
        "send_email": "false",
        "send_sms": "false",
        "redirect_url": "https://www.example.com/redirect/",
        // Where to redirect after a successful payment.
        "webhook": "http://www.example.com/webhook/",
      };
      dprint('Response body: $body');
      try {
        var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 10));
        dprint('Response status: ${response.statusCode}');
        dprint('Response body: ${response.body}');
        var jsonResult = json.decode(response.body);
        if (response.statusCode == 201) {
          if (jsonResult['success'] == true)
            return jsonResult["payment_request"]['longurl'];
        }
        errorText = jsonResult['message'].toString();
      } catch (ex) {
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  String errorText = "";
}
