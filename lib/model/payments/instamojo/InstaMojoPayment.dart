import 'dart:core';
import '../../../main.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../dprint.dart';
import 'InstaMojoServices.dart';

class InstaMojoPayment extends StatefulWidget {
  final Function onFinish;
  final String userName;
  final String email;
  final String phone;
  final String payAmount;
  final String apiKey;
  final String token;
  final String sandBoxMode;

  InstaMojoPayment({this.onFinish, this.userName, this.email, this.phone, this.payAmount,
        this.apiKey, this.token, this.sandBoxMode});

  @override
  State<StatefulWidget> createState() {
    return InstaMojoPaymentState();
  }
}

class InstaMojoPaymentState extends State<InstaMojoPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  InstaMojoServices services = InstaMojoServices();
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
        accessToken = await services.getAccessToken(widget.userName, widget.payAmount, widget.apiKey,
            widget.token, widget.sandBoxMode, widget.email, widget.phone);
        
        if (accessToken != null) {
          setState(() {
            checkoutUrl = accessToken;
            executeUrl = accessToken;
          });
        }else {
          final snackBar = SnackBar(
            content: Text(services.errorText),
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
        // _scaffoldKey.currentState.showSnackBar(snackBar);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
}
