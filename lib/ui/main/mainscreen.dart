import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/basket.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/notification.dart';
import 'package:shopping/model/pref.dart';
import 'package:shopping/model/server/changePassword.dart';
import 'package:shopping/model/server/changeProfile.dart';
import 'package:shopping/model/server/uploadavatar.dart';
import 'package:shopping/ui/main/account.dart';
import 'package:shopping/ui/main/favorites.dart';
import 'package:shopping/ui/main/home/home.dart';
import 'package:shopping/ui/main/map.dart';
import 'package:shopping/ui/main/orders/orderdetails.dart';
import 'package:shopping/ui/main/orders/orders.dart';
import 'package:shopping/ui/menu/city.dart';
import 'package:shopping/ui/menu/documents.dart';
import 'package:shopping/ui/menu/help.dart';
import 'package:shopping/ui/menu/language.dart';
import 'package:shopping/ui/menu/menu.dart';
import 'package:shopping/ui/menu/wallet.dart';
import 'package:shopping/widget/IBottomBar2.dart';
import 'package:shopping/widget/easyDialog2.dart';
import 'package:shopping/widget/ibottombar.dart';
import 'package:shopping/widget/ibutton3.dart';
import 'package:shopping/widget/skinRoute.dart';
import 'package:shopping/widget/smarter/IBottomBar2Smart.dart';
import 'package:shopping/widget/smarter/ibottombarSmart.dart';
import 'basket.dart';
import 'chat/chat.dart';
import 'chat/vchat.dart';
import 'notification.dart';

double mainDialogShow = 0;
Widget mainDialogBody = Container();

double mainCurrentDialogShow = 0;
Widget mainCurrentDialogBody = Container();
bool noMain = false;

Basket basket = Basket();
_MainScreenState mainScreenState;
BuildContext mainContext;

// ignore: must_be_immutable
class MainScreen extends StatefulWidget  {
  @override
  _MainScreenState createState() {
    mainScreenState = _MainScreenState();
    return mainScreenState;
  }
  route(String value){
    mainScreenState.routes(value);
  }
  onBack(String value){
    mainScreenState.onBack(value);
  }
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {

  var windowWidth;
  var windowHeight;
  bool wait = false;
  String _currentState = "";
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _callbackChange(){
    print("User pressed Change password");
    print("Old password: ${editControllerOldPassword.text}, New password: ${editControllerNewPassword1.text}, "
        "New password 2: ${editControllerNewPassword2.text}");
    if (editControllerNewPassword1.text != editControllerNewPassword2.text)
      return _openDialogError(strings.get(167)); // "Passwords don't equals",
    if (editControllerNewPassword1.text.isEmpty || editControllerNewPassword2.text.isEmpty)
      return _openDialogError(strings.get(170)); // "Enter New Password",
    changePassword(account.token, editControllerOldPassword.text, editControllerNewPassword1.text,
        _successChangePassword, _errorChangePassword);
  }

  _errorChangePassword(String error){
    if (error == "1")
      return _openDialogError(strings.get(168)); // Old password is incorrect
    if (error == "2")
      return _openDialogError(strings.get(169)); // The password length must be more than 5 chars
    _openDialogError("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _successChangePassword(){
    _openDialogError(strings.get(166)); // "Password change",
    pref.set(Pref.userPassword, editControllerNewPassword1.text);
  }

  _callbackSave(){
    print("User pressed Save profile");
    print("User Name: ${editControllerName.text}, E-mail: ${editControllerEmail.text}, Phone: ${editControllerPhone.text}");
    changeProfile(account.token, editControllerName.text, editControllerEmail.text, editControllerPhone.text,
        _successChangeProfile, _errorChangeProfile);
  }

  _errorChangeProfile(String error){
    _openDialogError("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _successChangeProfile(){
    _openDialogError(strings.get(171)); // "User Profile change",
    account.userName = editControllerName.text;
    account.phone = editControllerPhone.text;
    account.email = editControllerEmail.text;
    setState(() {
    });
  }

  _bottonBarChange(int index){
    print("User pressed bottom bar button with index: $index");
    setState(() {
      _currentPage = index;
    });
  }

  _openMenu(){
    print("Open menu");
    if (strings.direction == TextDirection.rtl)
      _scaffoldKey.currentState.openEndDrawer();
      else
      _scaffoldKey.currentState.openDrawer();
    setState(() {

    });
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////

  var _currentPage = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final editControllerName = TextEditingController();
  final editControllerEmail = TextEditingController();
  final editControllerPhone = TextEditingController();
  final editControllerOldPassword = TextEditingController();
  final editControllerNewPassword1 = TextEditingController();
  final editControllerNewPassword2 = TextEditingController();

  @override
  void initState() {
    account.addCallback(this.hashCode.toString(), callback);
    // startCityTimer();
    Future.delayed(Duration(milliseconds: 100), () async {
      await firebaseGetToken(context);
    });
    super.initState();
  }

  callback(bool reg){
    setState(() {
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    route.disposeLast();
    editControllerName.dispose();
    editControllerEmail.dispose();
    editControllerPhone.dispose();
    editControllerOldPassword.dispose();
    editControllerNewPassword1.dispose();
    editControllerNewPassword2.dispose();
    super.dispose();
  }

  var _cityScreenOpen = false;

  Timer _timer;
  void startCityTimer() {
    _timer = new Timer.periodic(Duration(seconds: 1),
          (Timer timer) {
            if (homeScreen.mainWindowData == null || _cityScreenOpen)
              return;
            timer.cancel();
            if (homeScreen.mainWindowData.settings.city.isNotEmpty){
              var city = pref.get(Pref.city);
              if (city.isNotEmpty)
                return;
              if (pref.get(Pref.allCity) == "true")
                return;
              if (city.isEmpty)
                _cityScreenOpen = true;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectCityScreen(),
                ),
              );
            }

      },);
  }

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    //
    String _headerText = strings.get(47); // "Map",
    switch(_currentPage){
      case 1:
        _headerText = strings.get(36); // "My Orders",
        break;
      case 2:
        _headerText = strings.get(33); // "Home",
        break;
      case 3:
        _headerText = strings.get(37); // "Account",
        break;
      case 4:
        _headerText = strings.get(38); // "Favorites",
        break;
    }

    var _ordersIcon = "assets/orders3.png";
    if (theme.appTypePre == "restaurants")
      _ordersIcon = "assets/orders.png";

    return WillPopScope(
        onWillPop: () async {
          if (wait) {
            wait = false;
            setState(() {
            });
            return false;
          }
          if (_currentState == "about" || _currentState == "delivery" || _currentState == "privacy"
              || _currentState == "terms" || _currentState == "refund" || _currentState == "faq"
              || _currentState == "language" || _currentState == "chat" || _currentState == "notify"
              || _currentState == "wallet" || _currentState == "order_details" || _currentState == "basket") {
            _currentState = "";
            setState(() {});
            return false;
          }
          _openDialogExit();
          return false;
        },
    child: Scaffold(
      key: _scaffoldKey,
      drawer: Menu(context: context, callback: routes,),
      endDrawer: Menu(context: context, callback: routes,),
      backgroundColor: theme.colorBackground,
      body: Stack(
        children: <Widget>[

          if (_currentPage == 0)
            MapScreen(),
          if (_currentPage == 1)
            OrdersScreen(onErrorDialogOpen: _openDialogError, onBack: onBack),
          if (_currentPage == 2)
            HomeScreen(onErrorDialogOpen: _openDialogError, redraw: (){setState(() {});}, callback: routes, scaffoldKey: _scaffoldKey),
          if (_currentPage == 3)
            AccountScreen(onDialogOpen: _openDialogs),
          if (_currentPage == 4)
            FavoritesScreen(scaffoldKey: _scaffoldKey),

      skinHeaderMenu(context, onBack, _headerText),

      if (appSettings.bottomBarType == "type1" && theme.appSkin == "basic")
          IBottomBar(colorBackground: appSettings.bottomBarColor, colorSelect: theme.colorPrimary,
                colorUnSelect: theme.colorDefaultText.withAlpha(100), callback: _bottonBarChange, initialSelect: _currentPage,
              getItem: (){return _currentPage;},
              icons: ["assets/map.png", _ordersIcon, "assets/home.png", "assets/account.png", "assets/favorites.png"]
          ),

      if (appSettings.bottomBarType == "type1" && theme.appSkin == "smarter")
          IBottomBarSmart(colorBackground: appSettings.bottomBarColor, colorSelect: theme.colorPrimary,
              colorUnSelect: theme.colorDefaultText.withAlpha(100), callback: _bottonBarChange, initialSelect: _currentPage,
              getItem: (){return _currentPage;},
              icons: [Icons.map, Icons.list_alt, Icons.home, Icons.account_circle, Icons.favorite]
          ),

      if (appSettings.bottomBarType == "type2" && theme.appSkin == "basic")
          IBottomBar2(colorBackground: appSettings.bottomBarColor, colorSelect: theme.colorPrimary,
              colorUnSelect: theme.colorDefaultText.withAlpha(100), callback: _bottonBarChange, initialSelect: _currentPage,
              radius: appSettings.radius, shadow: appSettings.shadow,
              getItem: (){return _currentPage;},
              icons: ["assets/map.png", _ordersIcon, "assets/home.png", "assets/account.png", "assets/favorites.png"]
          ),

      if (appSettings.bottomBarType == "type2" && theme.appSkin == "smarter")
        IBottomBar2Smart(colorBackground: appSettings.bottomBarColor, colorSelect: theme.colorPrimary,
            colorUnSelect: theme.colorDefaultText.withAlpha(100), callback: _bottonBarChange, initialSelect: _currentPage,
            radius: appSettings.radius, shadow: appSettings.shadow,
            getItem: (){return _currentPage;},
            icons: [Icons.map, Icons.list_alt, Icons.home, Icons.account_circle, Icons.favorite]
        ),

          if (_currentState == "about" || _currentState == "delivery" || _currentState == "privacy"
              || _currentState == "terms" || _currentState == "refund")
            DocumentsScreen(doc: _currentState, onBack: onBack),
          if (_currentState == "faq")
            HelpScreen(onBack: onBack),
          // chat
          if (_currentState == "chat" && !theme.vendor)
            ChatScreen(onBack: onBack),
          if (_currentState == "chat" && theme.vendor)
            VendorChatScreen(callback: onBack),

          if (_currentState == "language")
            LanguageScreen(onBack: onBack, redraw: (){setState(() {});},),
          if (_currentState == "notify")
            NotificationScreen(onBack: onBack),
          if (_currentState == "wallet")
            WalletScreen(onBack: onBack),
          if (_currentState == "order_details")
            OrderDetailsScreen(onBack: onBack),
          if (_currentState == "basket")
            BasketScreen(onBack: onBack),

          if (wait)
            skinWait(context, true),

          IEasyDialog2(setPosition: (double value){mainDialogShow = value;}, getPosition: () {return mainDialogShow;}, color: theme.colorGrey,
              body: mainDialogBody, backgroundColor: theme.colorBackground),

          IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
            body: _dialogBody, backgroundColor: theme.colorBackground,),

        ],
      ),
    ));
  }

  onBack(String route){
    if (route == "open_menu")
      return _openMenu();
    _currentState = "";
    if (route == "account")
      _currentPage = 3;
    if (route == "chat")
      _currentState = "chat";
    if (route == "notify")
      _currentState = "notify";
    if (route == "basket") {
      while(Navigator.canPop(context))
        Navigator.pop(context);
      _currentState = "basket";
    }
    if (route == "home") {
      while(Navigator.canPop(context))
        Navigator.pop(context);
      _currentPage = 2;
    }
    if (route == "orders") {
      while(Navigator.canPop(context))
        Navigator.pop(context);
      _currentPage = 1;
    }
    if (route == "order_details")
      _currentState = "order_details";
    setState(() {});
  }

  routes(String route){
    if (route == "map")
      setState(() {
        _currentPage = 0;
      });
    if (route == "orders")
      setState(() {
        _currentPage = 1;
      });
    if (route == "home")
      setState(() {
        _currentPage = 2;
      });
    if (route == "account")
      setState(() {
        _currentPage = 3;
      });
    if (route == "favorites")
      setState(() {
        _currentPage = 4;
      });
    if (route == "redraw")
      print ("mainscreen redraw");
      setState(() {
      });
    if (route == "about" || route == "delivery" || route == "privacy"
        || route == "terms" || route == "refund" || route == "faq" || route == "language"
        || route == "chat" || route == "notify" || route == "wallet" || route == "order_details"){
      _currentState = route;
    }
  }

  _openDialogExit(){
    _dialogBody = Directionality(
        textDirection: strings.direction,
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: Text(strings.get(306), textAlign: TextAlign.center, style: theme.text18boldPrimary,) // Do you really want to exit?
              ), // "Reason to Reject",
              SizedBox(height: 20,),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: windowWidth/2-45,
                          child: IButton3(
                              color: Colors.redAccent,
                              text: strings.get(307),                  // Exit
                              textStyle: theme.text14boldWhite,
                              pressButton: (){
                                if (Platform.isAndroid) {
                                  SystemNavigator.pop();
                                } else if (Platform.isIOS) {
                                  exit(0);
                                }
                              }
                          )),
                      SizedBox(width: 10,),
                      Container(
                          width: windowWidth/2-45,
                          child: IButton3(
                              color: theme.colorPrimary,
                              text: strings.get(257),              // Back to shop
                              textStyle: theme.text14boldWhite,
                              pressButton: (){
                                setState(() {
                                  _show = 0;
                                });
                              }
                          )),
                    ],
                  )),

            ],
          ),
        ));

    setState(() {
      _show = 1;
    });
  }

  _openDialogs(String name){
    if (name == "EditProfile")
      _openEditProfileDialog();
    if (name == "makePhoto")
      getImage();
    if (name == "changePassword")
      _pressChangePasswordButton();
  }

  double _show = 0;
  Widget _dialogBody = Container();

  _openEditProfileDialog(){

    editControllerName.text = account.userName;
    editControllerEmail.text = account.email;
    editControllerPhone.text = account.phone;

    _dialogBody = Directionality(
        textDirection: strings.direction,
        child: Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Text(strings.get(156), textAlign: TextAlign.center, style: theme.text18boldPrimary,) // "Edit profile",
          ), // "Reason to Reject",
          SizedBox(height: 20,),
          Text("${strings.get(157)}:", style: theme.text12bold,),  // "User Name",
          _edit(editControllerName, strings.get(158), false),                //  "Enter your User Name",
          SizedBox(height: 20,),
          if (account.typeReg == "email")
            Text("${strings.get(159)}:", style: theme.text12bold,),  // "E-mail",
          if (account.typeReg == "email")
            _edit(editControllerEmail, strings.get(160), false),                //  "Enter your User E-mail",
          if (account.typeReg == "email")
            SizedBox(height: 20,),
          if (appSettings.otp != "true")
            Text("${strings.get(106)}:", style: theme.text12bold,),  // Phone
          if (appSettings.otp != "true")
            _edit(editControllerPhone, strings.get(161), false),                //  "Enter your User Phone",

          SizedBox(height: 30,),
          Container(
            width: windowWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: windowWidth/2-45,
                      child: IButton3(
                      color: theme.colorPrimary,
                      text: strings.get(162),                  // Change
                      textStyle: theme.text14boldWhite,
                      pressButton: (){
                        setState(() {
                          _show = 0;
                        });
                        _callbackSave();
                      }
                  )),
                  SizedBox(width: 10,),
              Container(
                width: windowWidth/2-45,
                child: IButton3(
                      color: theme.colorPrimary,
                      text: strings.get(155),              // Cancel
                      textStyle: theme.text14boldWhite,
                      pressButton: (){
                        setState(() {
                          _show = 0;
                        });
                      }
                  )),
                ],
              )),

        ],
      ),
    ));

    setState(() {
      _show = 1;
    });
  }

  _edit(TextEditingController _controller, String _hint, bool _obscure){
    return Container(
      height: 30,
      child: Directionality(
        textDirection: strings.direction,
        child: TextFormField(
        controller: _controller,
        onChanged: (String value) async {
        },
        cursorColor: theme.colorDefaultText,
        style: theme.text14,
        cursorWidth: 1,
        obscureText: _obscure,
        maxLines: 1,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: _hint,
            hintStyle: theme.text14
        ),
      ),
    ));
  }

  _pressChangePasswordButton(){
    _dialogBody = Directionality(
        textDirection: strings.direction,
        child: Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Text(strings.get(147), textAlign: TextAlign.center, style: theme.text18boldPrimary,) // "Change password",
          ), // "Reason to Reject",
          SizedBox(height: 20,),
          Text("${strings.get(148)}:", style: theme.text12bold,),  // "Old password",
          _edit(editControllerOldPassword, strings.get(149), true),                //  "Enter your old password",
          SizedBox(height: 20,),
          Text("${strings.get(150)}:", style: theme.text12bold,),  // "New password",
          _edit(editControllerNewPassword1, strings.get(152), true),                //  "Enter your new password",
          SizedBox(height: 20,),
          Text("${strings.get(153)}:", style: theme.text12bold,),  // "Confirm New password",
          _edit(editControllerNewPassword2, strings.get(154), true),                //  "Enter your new password",
          SizedBox(height: 30,),
          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Container(
              width: windowWidth/2-45,
                child: IButton3(
                      color: theme.colorPrimary,
                      text: strings.get(162),                  // Change
                      textStyle: theme.text14boldWhite,
                      pressButton: (){
                        setState(() {
                          _show = 0;
                        });
                        _callbackChange();
                      }
                  )),
                  SizedBox(width: 10,),
              Container(
                width: windowWidth/2-45,
                child: IButton3(
                      color: theme.colorPrimary,
                      text: strings.get(155),              // Cancel
                      textStyle: theme.text14boldWhite,
                      pressButton: (){
                        setState(() {
                          _show = 0;
                        });
                      }
                  )),
                ],
              )),

        ],
      ),
    ));

    setState(() {
      _show = 1;
    });
  }

  final picker = ImagePicker();

  getImage(){
    _dialogBody = Column(
      children: [
        InkWell(
            onTap: () {
              getImage2(ImageSource.gallery);
              setState(() {
                _show = 0;
              });
            }, // needed
            child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                height: 40,
                color: theme.colorBackgroundGray,
                child: Center(
                  child: Text(strings.get(163)), // "Open Gallery",
                )
            )),
        InkWell(
            onTap: () {
              getImage2(ImageSource.camera);
              setState(() {
                _show = 0;
              });
            }, // needed
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              margin: EdgeInsets.only(bottom: 10),
              height: 40,
              color: theme.colorBackgroundGray,
              child: Center(
                child: Text(strings.get(164)), //  "Open Camera",
              ),
            )),
        SizedBox(height: 20,),
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

  waits(bool value){
    wait = value;
    if (mounted)
      setState(() {
      });
  }

  Future getImage2(ImageSource source) async {
    waits(true);
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null && pickedFile.path != null) {
      print("Photo file: ${pickedFile.path}");
      waits(true);
      uploadAvatar(pickedFile.path, account.token, (String avatar) {
        account.setUserAvatar(avatar);
        waits(false);
        setState(() {
        });
      }, (String error) {
        waits(false);
        _openDialogError("${strings.get(128)} $error"); // "Something went wrong. ",
      });
    }else
      waits(false);
  }

  _openDialogError(String _text) {
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

