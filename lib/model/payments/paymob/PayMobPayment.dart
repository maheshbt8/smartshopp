import 'dart:core';
import '../../../main.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'PayMobServices.dart';

class PayMobPayment extends StatefulWidget {
  final String id;
  final Function onFinish;
  final String userFirstName;
  final String userLastName;
  final String userEmail;
  final String payAmount;
  final String userPhone;
  final String apiKey;
  final String frame;
  final String integrationId;
  //
  final String country;
  final String postalCode;
  final String state;
  final String city;
  final String street;
  final String building;
  final String floor;
  final String apartment;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  PayMobPayment({this.onFinish, this.userFirstName, this.userLastName, this.userEmail, this.payAmount,
    this.apiKey, this.frame, this.integrationId, this.userPhone, this.id, this.country,
    this.postalCode, this.state, this.city, this.street, this.building, this.floor,
    this.apartment, this.firstName, this.lastName, this.email, this.phoneNumber});

  @override
  State<StatefulWidget> createState() {
    return PayMobPaymentState();
  }
}

class PayMobPaymentState extends State<PayMobPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String accessToken;
  var services = PayMobServices();
  var paymentResponse;
  List<String> payResponse = [];

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.authentication(widget.apiKey);
        if (accessToken == null)
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Check apiKey")));
        await services.createOrder(widget.payAmount, "215");//widget.id);
        checkoutUrl = await services.executePayment(
            widget.integrationId, widget.frame,
            widget.country, widget.postalCode, widget.state, widget.city, widget.street,
            widget.building, widget.floor, widget.apartment, widget.firstName,
            widget.lastName, widget.userEmail, widget.phoneNumber);
        if (checkoutUrl == null)
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("executePayment fails")));

        setState(() {
        });

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

  int quantity = 1;

  // Map<String, dynamic> getOrderParams(userFirstName, userLastName, itemName, itemPrice, String currency) {
  //   Map<String, dynamic> params = ;
  //   return params;
  // }

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
        appBar: appBar("PayMob"),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            print(request.url);
            if (request.url.contains("txn_response_code=APPROVED")) {
              final uri = Uri.parse(request.url);
              // final payerID = uri.queryParameters['id'];
              // if (payerID != null) {
                // services.executePayment(payerID, widget.userFirstName, widget.userPhone, widget.userEmail)
                //     .then((List<String> ls) {
                //    print("paymentMethod: " + payerID+"  "+ accessToken + " " +ls[0]);
                //    setState(() {
                //      payResponse = ls;
                //    });
                widget.onFinish(uri.queryParameters['id']);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                // });
              // } else
              //   Navigator.of(context).pop();
            }
            // if (request.url.contains(cancelURL)) {
            //   Navigator.of(context).pop();
            // }
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
