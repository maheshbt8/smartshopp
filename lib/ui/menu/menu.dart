import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/ui/main/home/home.dart';
import 'package:shopping/widget/iline.dart';
import 'package:shopping/widget/skinRoute.dart';

import 'city.dart';

class Menu extends StatelessWidget {
  @required final BuildContext context;
  final Function(String) callback;
  Menu({this.context, this.callback});

  _onMenuClickItem(int id){
    print("User click menu item: $id");
    switch(id){
      case 1:   // home
        callback("home");
        break;
      case 2:   // notifications
        callback("notify");
        break;
      case 3:   // My Orders
        callback("orders");
        break;
      case 4:   // Wish List
        callback("favorites");
        break;
      case 12:   // Chat
        callback("chat");
        break;
      case 13:   // Wallet
        callback("wallet");
        break;
      case 7:   // Help - faq
        callback("faq");
        break;
      case 8:   // Settings
        callback("account");
        break;
      case 9:   // Language
        callback("language");
        break;
      case 10:   // dark & light mode
        theme.changeDarkMode();
        callback("redraw");
        break;
      case 11:   // sign out
        account.logOut();
        break;
      case 20:   // about
        callback("about");
        break;
      case 21:   // delivery
        callback("delivery");
        break;
      case 22:   // privacy
        callback("privacy");
        break;
      case 23:   // terms
        callback("terms");
        break;
      case 24:   // refund
        callback("refund");
        break;
      case 30:   // share this app
        _share();
        break;
      case 31:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectCityScreen(),
          ),
        );
        break;

    }
  }

  _share() async {
    var code = "";
    if(Platform.isIOS)
      code = homeScreen.mainWindowData.settings.shareAppAppStore;
    if(Platform.isAndroid)
      code = homeScreen.mainWindowData.settings.shareAppGooglePlay;
    final RenderBox box = context.findRenderObject();
    await Share.share(code,
        subject: strings.get(314), // Share This App,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  _shareMenuItem() {
    var code = "";
    if(Platform.isIOS)
      code = homeScreen.mainWindowData.settings.shareAppAppStore;
    if(Platform.isAndroid)
      code = homeScreen.mainWindowData.settings.shareAppGooglePlay;
    if (code.isNotEmpty)
      return skinMenuItem(30, strings.get(314), context, _onMenuClickItem); // Share This App
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: strings.direction,
        child: Drawer(
        child: Container(
          color: theme.colorBackground,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              skinMenuTitle(context),
              //
              skinMenuItem(1, strings.get(33), context, _onMenuClickItem), // 'Home'
              skinMenuItem(3, strings.get(36), context, _onMenuClickItem),  // 'My orders'
              skinMenuItem(4, strings.get(38), context, _onMenuClickItem), // "Favorites",
              if (appSettings.walletEnable == "true")
                skinMenuItem(13, strings.get(206), context, _onMenuClickItem), // "Wallet",
              ILine(),
              skinMenuItem(2, strings.get(35), context, _onMenuClickItem),  // Notifications
              skinMenuItem(12, strings.get(205), context, _onMenuClickItem), // Chat
              skinMenuItem(8, strings.get(37), context, _onMenuClickItem), // "Account",
              if (homeScreen.mainWindowData != null  && homeScreen.mainWindowData.settings.city.isNotEmpty)
                skinMenuItem(31, strings.get(318), context, _onMenuClickItem), // Select city
              skinMenuItem(9, strings.get(62), context, _onMenuClickItem), // Languages

              _shareMenuItem(),  // Share This App

              if (appSettings.faq == "true" || appSettings.about == "true" || appSettings.delivery == "true" ||
                  appSettings.privacy == "true" || appSettings.terms == "true" || appSettings.refund == "true")
                ILine(),
              if (appSettings.faq == "true")
                skinMenuItem(7, strings.get(51), context, _onMenuClickItem), // Help & Support
              if (appSettings.about == "true")
                skinMenuItem(20, (appSettings.aboutTextName == null) ? "" : appSettings.aboutTextName, context, _onMenuClickItem),
              if (appSettings.delivery == "true")
                skinMenuItem(21, (appSettings.deliveryTextName == null) ? "" : appSettings.deliveryTextName, context, _onMenuClickItem),
              if (appSettings.privacy == "true")
                skinMenuItem(22, (appSettings.privacyTextName == null) ? "" : appSettings.privacyTextName, context, _onMenuClickItem),
              if (appSettings.terms == "true")
                skinMenuItem(23, (appSettings.termsTextName == null) ? "" : appSettings.termsTextName, context, _onMenuClickItem),
              if (appSettings.refund == "true")
                skinMenuItem(24, (appSettings.refundTextName == null) ? "" : appSettings.refundTextName, context, _onMenuClickItem),

              if (account.isAuth())
                ILine(),
              if (account.isAuth())
                skinMenuItem(11, strings.get(132), context, _onMenuClickItem), // "Sign Out",

            ],
          ),
        )
    ));
  }
}