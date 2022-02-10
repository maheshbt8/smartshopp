import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/server/login.dart';
import 'package:shopping/model/server/register.dart';
import 'package:shopping/model/social/apple.dart';
import 'package:shopping/model/social/facebook.dart';
import 'package:shopping/model/social/google.dart';
import 'package:shopping/model/utils.dart';
import 'package:shopping/widget/easyDialog2.dart';
import 'package:shopping/widget/iappBar.dart';
import 'package:shopping/widget/ibackground4.dart';
import 'package:shopping/widget/ibutton3.dart';
import 'package:shopping/widget/ibutton4.dart';
import 'package:shopping/widget/iinputField2PasswordA.dart';
import 'package:shopping/widget/iinputField2a.dart';
import 'package:shopping/widget/skinRoute.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'otp.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FaceBookLogin facebookLogin = FaceBookLogin();
  GoogleLogin googleLogin = GoogleLogin();
  AppleLogin appleLogin = AppleLogin();

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  _pressLoginButton() {
    print("User pressed \"LOGIN\" button");
    print("Login: ${editControllerName.text}, password: ${editControllerPassword
        .text}");
    if (editControllerName.text.isEmpty)
      return openDialog(strings.get(172)); // "Enter Login",
    if (!validateEmail(editControllerName.text))
      return openDialog(strings.get(174)); // "Login or Password in incorrect"
    if (editControllerPassword.text.isEmpty)
      return openDialog(strings.get(173)); // "Enter Password",
    _waits(true);
    _socialEnter = false;
    login(editControllerName.text, editControllerPassword.text, _okUserEnter,
        _error);
  }

  var _socialEnter = false;
  var _socialId = "";
  var _socialType = "";
  var _socialName = "";
  var _socialPhoto = "";

  _login(String type, String id, String name, String photo) {
    _socialEnter = true;
    _socialId = id;
    _socialType = type;
    _socialName = name;
    _socialPhoto = photo;
    login("$id@$type.com", id, _okUserEnter, _error);
  }

  _pressDontHaveAccountButton() {
    print("User press \"Don't have account\" button");
    route.push(context, "/createaccount");
  }

  _pressForgotPasswordButton() {
    print("User press \"Forgot password\" button");
    route.push(context, "/forgot");
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerName = TextEditingController();
  final editControllerPassword = TextEditingController();
  bool _wait = false;
  ScrollController _scrollController = ScrollController();

  _waits(bool value) {
    _wait = value;
    if (mounted)
      setState(() {});
  }

  _error(String error) {
    _waits(false);
    if (error == "login_canceled")
      return;
    if (error == "1") {
      if (_socialEnter) {
        if (appSettings.otp == "true")
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OTPScreen(
                      name: _socialName,
                      email: "$_socialId@$_socialType.com",
                      type: _socialType,
                      password: _socialId,
                      photo: _socialPhoto
                  ),
            ),
          );
        return register(
            "$_socialId@$_socialType.com",
            _socialId,
            _socialName,
            _socialType,
            _socialPhoto,
            _okUserEnter2,
            _error);
      }
      return openDialog(strings.get(174)); // "Login or Password in incorrect"
    }
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _okUserEnter2(String name, String password, String avatar, String email,
      String token, String typeReg) {
    _waits(false);
    account.okUserEnter(
        name,
        password,
        avatar,
        email,
        token,
        "",
        0,
        typeReg);
    route.pushToStart(context, "/main");
  }

  _okUserEnter(String name, String password, String avatar, String email,
      String token, String _phone, int i, String typeReg) {
    _waits(false);
    account.okUserEnter(
        name,
        password,
        avatar,
        email,
        token,
        _phone,
        i,
        typeReg);
    route.pop(context);
  }

  @override
  void initState() {
    _initiOS();
    initApp();

    super.initState();
  }

  _initiOS() {
    if (Platform.isIOS) {
      TheAppleSignIn.onCredentialRevoked.listen((_) {
        dprint("Credentials revoked");
      });
    }
  }

  _buttoniOS() {
    if (Platform.isIOS) {
      return FutureBuilder<bool>(
          future: _isAvailableFuture,
          builder: (context, isAvailableSnapshot) {
            if (!isAvailableSnapshot.hasData) {
              return Container();
            }
            return isAvailableSnapshot.data
                ? Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: IButton4(
                    color: Color(0xff000000),
                    text: strings.get(298),
                    textStyle: theme.text14boldWhite,
                    // "Log In with Apple",
                    icon: "assets/apple.png",
                    pressButton: () {
                      _waits(true);
                      appleLogin.login(_login, _error);
                    }))
                : Container(); // 'Sign in With Apple not available. Must be run on iOS 13+
          });
    } else {
      return Container();
    }
  }

  final Future<bool> _isAvailableFuture = TheAppleSignIn.isAvailable();

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerPassword.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery
        .of(context)
        .size
        .width;
    windowHeight = MediaQuery
        .of(context)
        .size
        .height;
    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent,);
    });
    return Scaffold(
        backgroundColor: theme.colorBackground,

        body: Directionality(
          textDirection: strings.direction,
          child: Stack(
            children: <Widget>[

              if (theme.appSkin == "basic")
                IBackground4(
                    width: windowWidth, colorsGradient: theme.colorsGradient),
              if (theme.appSkin == "smarter")
                Container(
                  width: windowWidth,
                  height: windowHeight,
                  color: theme.colorPrimary,
                ),

              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                width: windowWidth,
                child: _body(),
              ),

              if (_wait)
                skinWait(context, true),

              IEasyDialog2(
                setPosition: (double value) {
                  _show = value;
                },
                getPosition: () {
                  return _show;
                },
                color: theme.colorGrey,
                body: _dialogBody,
                backgroundColor: theme.colorBackground,),

              IAppBar(context: context, text: "", color: Colors.white),

            ],
          ),
        ));
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
    _waits(false);
    _dialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155), // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: () {
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

  _body() {
    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      children: <Widget>[

        Container(
          width: windowWidth * 0.4,
          height: windowWidth * 0.4,
          child: Image.asset("assets/logo.png", fit: BoxFit.contain),
        ),

        SizedBox(height: 20,),

        SizedBox(height: 15,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2a(
                hint: strings.get(15),
                // "Login"
                icon: Icons.alternate_email,
                colorDefaultText: Colors.white,
                controller: editControllerName,
                type: TextInputType.emailAddress
            )
        ),
        SizedBox(height: 5,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),
        SizedBox(height: 5,),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2PasswordA(
              hint: strings.get(16), // "Password"
              icon: Icons.vpn_key,
              colorDefaultText: Colors.white,
              controller: editControllerPassword,
            )),

        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),
        SizedBox(height: 30,),

        Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: IButton3(
                color: theme.colorCompanion,
                text: strings.get(22),
                textStyle: theme.text14boldWhite,
                // LOGIN
                pressButton: () {
                  _pressLoginButton();
                })),

        SizedBox(height: 25,),

        if (appSettings.googleLogin == "true" ||
            appSettings.facebookLogin == "true")
          Container(child: Row(children: [
            Expanded(
                child: Container(height: 0.3, color: theme.colorBackground,)),
            Text(strings.get(271), style: theme.text14boldWhite), // " or "
            Expanded(
                child: Container(height: 0.3, color: theme.colorBackground,)),
          ],)),

        if (appSettings.googleLogin == "true")
          Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: IButton4(
                  color: Color(0xffd9534f),
                  text: strings.get(273),
                  textStyle: theme.text14boldWhite,
                  // "Log In with Google",
                  icon: "assets/google.png",
                  pressButton: () async {
                    _waits(true);
                     googleLogin.login(_login, _error);
                   //  signInWithGoogle();
                   //  GoogleSignIn().signIn();
                  })),

        if (appSettings.facebookLogin == "true")
          Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: IButton4(
                  color: Color(0xff428bca),
                  text: strings.get(274),
                  textStyle: theme.text14boldWhite,
                  // Log In with Facebook
                  icon: "assets/facebook.png",
                  pressButton: () {
                    _waits(true);
                    facebookLogin.login(_login, _error);
                  })),

        if (appSettings.googleLogin == "true" ||
            appSettings.facebookLogin == "true")
          _buttoniOS(),

        SizedBox(height: 30,),

        InkWell(
            onTap: () {
              _pressDontHaveAccountButton();
            }, // needed
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 0),
              child: Text(
                  strings.get(19), // ""Don't have an account? Create",",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: theme.text16boldWhite
              ),
            )),
        InkWell(
            onTap: () {
              _pressForgotPasswordButton();
            }, // needed
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text(strings.get(17), // "Forgot password",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: theme.text16boldWhite
              ),
            ))

      ],
    );
  }

  void initApp() async {
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    // immediately check whether the user is signed in
  }


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}