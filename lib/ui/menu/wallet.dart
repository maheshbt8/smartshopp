import 'package:flutter/material.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/payments/flutterwave.dart';
import 'package:shopping/model/payments/instamojo/InstaMojoPayment.dart';
import 'package:shopping/model/payments/paypal/PaypalPayment.dart';
import 'package:shopping/model/payments/paystack.dart';
import 'package:shopping/model/payments/razorpay.dart';
import 'package:shopping/model/payments/stripe.dart';
import 'package:shopping/model/payments/yandex.dart';
import 'package:shopping/model/server/wallet.dart';
import 'package:shopping/model/utils.dart';
import 'package:shopping/ui/login/needAuth.dart';
import 'package:shopping/ui/main/chat/iinputField2a.dart';
import 'package:shopping/ui/main/home/home.dart';
import 'package:shopping/widget/easyDialog2.dart';
import 'package:shopping/widget/ibutton3.dart';
import 'package:shopping/widget/skinRoute.dart';

class WalletScreen extends StatefulWidget {
  final Function(String) onBack;
  WalletScreen({Key key, this.onBack}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  _pressTopUp(){
    dprint("User pressed Top Up");
    setState(() {
      _topUpStart = true;
    });
  }

  var total = 0.0;

  _pressTopUpNow() async {
    dprint("User pressed Top Up Now. num=${editControllerCount.text} _currVal=$_currVal");
    total = 0;
    try{
      total = double.parse(editControllerCount.text);
    }catch(ex){
    }
    if (total == 0)
      return openDialog(strings.get(217)); // Enter the amount

    var razorpayCompanyName = homeScreen.mainWindowData.payments.razName;
    var code = homeScreen.mainWindowData.payments.code;
    if (_currVal == 3) { // razorpay
      RazorpayModel _razorpayModel = RazorpayModel();
      _razorpayModel.init();
      double _total = total * 100;
      var t = _total.toInt();
      _razorpayModel.openCheckout(t.toString(), "", "", razorpayCompanyName, code,
          _onSuccess, _onError
      );
    }
    if (_currVal == 7) { // payStack
      var paystack = PayStackModel();
      var ret = await paystack.handleCheckout(total, account.email, context);
      if (ret != null)
        _onSuccess(ret);
    }
    if (_currVal == 5) { // paypal
      String _total = total.toStringAsFixed(appSettings.symbolDigits);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaypalPayment(
              currency: code,
              userFirstName: "",
              userLastName: "",
              userEmail: "",
              payAmount: _total,
              secret: homeScreen.mainWindowData.payments.payPalSecret,
              clientId: homeScreen.mainWindowData.payments.payPalClientId,
              sandBoxMode: homeScreen.mainWindowData.payments.payPalSandBoxMode,
              onFinish: (w){
                _onSuccess("PayPal: $w");
              }
          ),
        ),
      );
    }
    if (_currVal == 4) { // mastercard
      StripeModel _stripe = StripeModel();
      _waits(true);
      _stripe.init();
      double _total = total * 100;
      var t = _total.toInt();
      try {
        await _stripe.openCheckoutCard(t, "", "", razorpayCompanyName, code,
            homeScreen.mainWindowData.payments.stripeSecretKey, _onSuccess, //_onError
        );
      }catch(ex){
        dprint(ex.toString());
        _onError(ex.toString());
      }
    }
    if (_currVal == 8) { // yandex kassa
      _waits(true);
      var yandex = YandexModel();
      try {
        var t = total;
        var ret = await yandex.handleCheckout(t, account.email, context, "");
        _waits(false);
        if (ret != null)
          _onSuccess("YandexKassa: $ret");
      }catch(ex ){
        _waits(false);
      }
    }
    if (_currVal == 9) { // instamojo
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InstaMojoPayment(
              userName: account.userName,
              email: account.email,
              phone: account.phone,
              payAmount: total.toString(),
              token: homeScreen.mainWindowData.payments.instamojoPrivateToken,
              apiKey: homeScreen.mainWindowData.payments.instamojoApiKey,
              sandBoxMode: homeScreen.mainWindowData.payments.instamojoSandBoxMode,
              onFinish: (w){
                _onSuccess("INSTAMOJO: $w");
              }
          ),
        ),
      );
    }
    if (_currVal == 12) { // FlutterWave
      var ret = await FlutterWaveModel().handleCheckout(toDouble(total.toStringAsFixed(appSettings.symbolDigits)),
          account.email, code, context, account.phone, account.userName, "1");
      if (ret != null)
        _onSuccess("FW: $ret");
    }

  }

  _onError(String err){
    _waits(false);
    if (err == "ERROR: 2")
      return;
    if (err == "cancelled")
      return;
    openDialog("${strings.get(128)} $err"); // "Something went wrong. ",
  }

  _onSuccess(String id){
    walletTopUp(account.token, total.toStringAsFixed(appSettings.symbolDigits),  id, _successTopUp, _error);
  }

  _successTopUp(double balance){
    _waits(false);
    account.walletBalance = balance;
    setState(() {
      _topUpStart = false;
    });
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  bool _topUpStart = false;
  final editControllerCount = TextEditingController();

  @override
  void initState() {
    account.notifyCount = 0;
    account.redraw();
    if (account.isAuth()) {
      getWalletBalance(account.token, _success, _error);
    }
    account.addCallback(this.hashCode.toString(), callback);
    super.initState();
  }

  bool _wait = false;

  _waits(bool value){
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }


  _error(String error){
    _waits(false);
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _success(double _data) {
    _waits(false);
    account.walletBalance = _data;
    setState(() {
    });
  }

  callback(bool reg){
    setState(() {
    });
  }

  @override
  void dispose() {
    route.disposeLast();
    account.removeCallback(this.hashCode.toString());
    account.redraw();
    editControllerCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: theme.colorBackground,
        body:
        Directionality(
        textDirection: strings.direction,
        child:
        Stack(
          children: <Widget>[

          skinHeader(context, widget.onBack, strings.get(206)), // "Wallet",

        if (account.isAuth())(
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: MediaQuery.of(context).padding.top+42),
              child: _body(),
            ))else
              mustAuth(windowWidth, context),

            if (_wait)
              skinWait(context, true),

            IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
                body: _dialogBody, backgroundColor: theme.colorBackground),

          ],
        )
    ));
  }

  _body(){
    return ListView(
      children: _body2(),
    );
  }

  _body2(){
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));

    list.add(Text("${strings.get(10)} ${strings.get(206)}", style: theme.text18bold,));  // Wallet
    list.add(SizedBox(height: 20,));

    list.add(Text(strings.get(207), style: theme.text14,));  // "Top up and enjoy these benefits",
    list.add(SizedBox(height: 20,));

    list.add(_row(strings.get(208), strings.get(209))); //  "Easy payment", - "Order food with 1 click",
    list.add(SizedBox(height: 20,));
    list.add(_row(strings.get(210), strings.get(211))); //  "Cashless delivery", - "Avoid the cash hassle",
    list.add(SizedBox(height: 20,));
    list.add(_row(strings.get(212), strings.get(213))); //  "Instant refunds", - "When you need to cancel an order",
    list.add(SizedBox(height: 30,));

    list.add(Container(height: 0.5, width: windowWidth-20, color: Colors.grey,));

    list.add(SizedBox(height: 30,));

    var _text = (appSettings.rightSymbol == "true") ? "${account.walletBalance.toStringAsFixed(appSettings.symbolDigits)}${appSettings.currency}" :
              "${appSettings.currency}${account.walletBalance.toStringAsFixed(appSettings.symbolDigits)}";
    list.add(Container(
      width: windowWidth/2,
      child: Column(
        children: [
          Text(strings.get(215), style: theme.text14bold,),
          SizedBox(height: 5,),
          Text(_text, style: theme.text20,),
        ],
      ),
    ));
    list.add(SizedBox(height: 30,));
    list.add(Container(height: 0.5, width: windowWidth-20, color: Colors.grey,));

    list.add(SizedBox(height: 30,));
    if (!_topUpStart) {
      list.add(Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              left: windowWidth * 0.1, right: windowWidth * 0.1),
          child: IButton3(text: strings.get(214),                                         // "Top Up",
            color: theme.colorPrimary,
            pressButton: _pressTopUp,
            textStyle: theme.text14boldWhite,
          )
      ));
    }else{
      var _text = (appSettings.rightSymbol == "true") ? "${100.toStringAsFixed(appSettings.symbolDigits)}${appSettings.currency}" :
          "${appSettings.currency}${100.toStringAsFixed(appSettings.symbolDigits)}";

      list.add(Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
        child: IInputField2(
          hint : _text,
          icon : Icons.cached,
          controller : editControllerCount,
          type : TextInputType.number,
          colorDefaultText: theme.colorDefaultText,
          colorBackground: theme.colorBackgroundDialog,
        ),
      ));

      list.add(SizedBox(height: 30,));
      list.add(_row(strings.get(188), strings.get(194))); //  "Payment" - "All transactions are secure and encrypted.",
      list.add(SizedBox(height: 30,));

      if (homeScreen.mainWindowData.payments.stripeEnable == "true") {
        list.add(_item("assets/payment2.png", 4, strings.get(192))); // "Visa, Mastercard",
        list.add(SizedBox(height: 10,));
      }
      if (homeScreen.mainWindowData.payments.razEnable == "true") {
        list.add(_item("assets/payment4.png", 3, strings.get(191))); // razorpay
        list.add(SizedBox(height: 10,));
      }
      if (homeScreen.mainWindowData.payments.payPalEnable == "true") {
        list.add(_item("assets/payment5.png", 5, strings.get(249))); // payPal
        list.add(SizedBox(height: 10,));
      }
      if (homeScreen.mainWindowData.payments.payStackEnable == "true") {
        list.add(_item("assets/payment7.png", 7, strings.get(251))); // payStack
        list.add(SizedBox(height: 10,));
      }
      if (homeScreen.mainWindowData.payments.yandexKassaEnable == "true") {
        list.add(_item("assets/payment8.png", 8, strings.get(265))); // Yandex kassa
        list.add(SizedBox(height: 10,));
      }
      if (homeScreen.mainWindowData.payments.instamojoEnable == "true") {
        list.add(_item("assets/payment9.png", 9, strings.get(266))); // "Instamojo",
        list.add(SizedBox(height: 10,));
      }
      if (homeScreen.mainWindowData.payments.flutterWaveEnable == "true") {
        list.add(_item("assets/payment12.png", 12, "FlutterWave")); // FlutterWave
        list.add(SizedBox(height: 10,));
      }
      list.add(SizedBox(height: 30,));

      list.add(Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              left: windowWidth * 0.1, right: windowWidth * 0.1),
          child: IButton3(text: strings.get(216),                                         // "Top Up Now",
            color: theme.colorPrimary,
            pressButton: _pressTopUpNow,
            textStyle: theme.text14boldWhite,
          )
      ));

      list.add(SizedBox(height: 100,));

    }

    return list;
  }

  var _currVal = 4;

  _item(String image, int index, String text){
    var _align = Alignment.centerLeft;
    if (strings.direction == TextDirection.rtl)
      _align = Alignment.centerRight;

    return Container(
        color: theme.colorBackgroundGray,
        child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Expanded(child: Container(
                    child: RadioListTile(
                      activeColor: theme.colorCompanion,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(text, style: theme.text14,),
                          Container(
                              alignment: _align,
                              child: UnconstrainedBox(
                                  child: Container(
                                    //height: windowWidth*0.1,
                                      width: windowWidth*0.2,
                                      child: Container(
                                        child: Image.asset(image,
                                            fit: BoxFit.contain
                                        ),
                                      )))
                          )
                        ],
                      ),
                      groupValue: _currVal,

                      value: index,
                      onChanged: (val) {
                        setState(() {
                          _currVal = val;
                          //_itemSelect();
                        });
                      },
                    ))),

              ],
            )


        )
    );
  }

  _row(String text1, String text2){
    return Container(
        child: Row(
          children: [
            Icon(Icons.done, color: Colors.green, size: 20,),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text1, style: theme.text14bold,),
                SizedBox(height: 5,),
                Text(text2, style: theme.text14,)
              ],
            )
          ],
        )
    );
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
    _dialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155),              // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: (){
              setState(() {
                _show = 0;
              });
            }
        ),
      ],
    );

    setState(() {
      _show = 1;
    });
  }

}

