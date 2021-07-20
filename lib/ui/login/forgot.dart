import 'package:flutter/material.dart';

import 'package:shopping/main.dart';
import 'package:shopping/model/server/forgot.dart';
import 'package:shopping/widget/easyDialog2.dart';
import 'package:shopping/widget/iappBar.dart';
import 'package:shopping/widget/ibackground4.dart';
import 'package:shopping/widget/ibutton3.dart';
import 'package:shopping/widget/iinputField2a.dart';
import 'package:shopping/widget/skinRoute.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen>
    with SingleTickerProviderStateMixin {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _pressSendButton(){
    print("User pressed \"SEND\" button");
    print("E-mail: ${editControllerEmail.text}");
    if (editControllerEmail.text.isEmpty)
      return openDialog(strings.get(176)); // "Enter your E-mail"
    if (!_validateEmail(editControllerEmail.text))
      return openDialog(strings.get(178)); // "You E-mail is incorrect"

    _waits(true);
    forgotPassword(editControllerEmail.text, _success, _error) ;
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerEmail = TextEditingController();
  bool _wait = false;

  _error(String error){
    _waits(false);
    if (error == "5000")
      return openDialog(strings.get(136)); //  "User with this Email was not found!",
    if (error == "5001")
      return openDialog(strings.get(137)); //  "Failed to send Email. Please try again later.",
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  _success(){
    _waits(false);
    openDialog(strings.get(135)); // "A letter with a new password has been sent to the specified E-mail",
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    route.disposeLast();
    editControllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: theme.colorBackground,

      body: Directionality(
        textDirection: strings.direction,
        child: Stack(
        children: <Widget>[

          if (theme.appSkin == "basic")
            IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),
          if (theme.appSkin == "smarter")
            Container(
              width: windowWidth,
              height: windowHeight,
              color: theme.colorPrimary,
            ),

           IAppBar(context: context, text: "", color: Colors.white),

           Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  width: windowWidth,
                  child: _body(),
                  )
           ),

          if (_wait)
            skinWait(context, true),

          IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
            body: _dialogBody, backgroundColor: theme.colorBackground,),

        ],
      ),
    ));
  }

  _body(){
    return Column(
      children: <Widget>[

        Expanded(
            child: Container(
              width: windowWidth*0.4,
              height: windowWidth*0.4,
              child: Image.asset("assets/logo.png", fit: BoxFit.contain),
            )
        ),

        Container(
          width: windowWidth,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Text(strings.get(20),                        // "Forgot password"
              style: theme.text20boldWhite, textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: 20,),

        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:
            IInputField2a(
              hint: strings.get(21),            // "E-mail address"
              icon: Icons.alternate_email,
              colorDefaultText: Colors.white,
              controller: editControllerEmail,
            )
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 25,),

        Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: IButton3(
                color: theme.colorCompanion, text: strings.get(23), textStyle: theme.text14boldWhite,  // SEND
                pressButton: (){
                  _pressSendButton();
                })),

        SizedBox(height: 25,),
      ],

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

  bool _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }
}