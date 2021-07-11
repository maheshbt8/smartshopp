import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/ui/login/needAuth.dart';
import 'package:fooddelivery/widget/iAvatarWithPhotoFileCaching.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/ibutton5.dart';
import 'package:fooddelivery/widget/ilist4.dart';
import 'package:fooddelivery/widget/skinRoute.dart';

class AccountScreen extends StatefulWidget {
  final Function(String) onDialogOpen;
  AccountScreen({Key key, this.onDialogOpen}) : super(key: key);
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  ///////////////////////////////////////////////////////////////////////////////
  //

  _makePhoto(){
    print("Make photo");
    widget.onDialogOpen("makePhoto");
  }

  _onChangePassword(){
    widget.onDialogOpen("changePassword");
  }

  _pressEditProfileButton(){
    print("User pressed Edit profile");
    widget.onDialogOpen("EditProfile");
  }

  _pressLogOutButton(){
    print("User pressed Log Out");
    account.logOut();
  }

  ///////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;

  @override
  void initState() {
    account.addCallback(this.hashCode.toString(), callback);
    super.initState();
  }

  callback(bool reg){
    setState(() {
    });
  }

  @override
  void dispose() {
    account.removeCallback(this.hashCode.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Directionality(
        textDirection: strings.direction,
        child: Stack(
        children: <Widget>[

          if (account.isAuth())(
          Container(
            child: Container(
                child: ListView(
                  padding: EdgeInsets.only(top: 0),
                  shrinkWrap: true,
                  children: _getList(),
                )
            ),
          ))else
              mustAuth(windowWidth, context),

        ],

    ));
  }

  _getList() {
    List<Widget> list = [];

    skinAccountHeader1(list, windowWidth, context);

    list.add(
        Stack(
          children: [
            skinAccountHeader2(windowWidth, windowHeight),
            IAvatarWithPhotoFileCaching(
              avatar: account.userAvatar,
              color: theme.colorPrimary,
              colorBorder: theme.colorGrey,
              callback: _makePhoto,
            ),
            //_logoutWidget(),
          ],
        ));
    list.add(SizedBox(height: 10,));

    list.add(Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      // color: theme.colorBackgroundGray,
      child: _userInfo(),
    ));

    list.add(SizedBox(height: 30,));

    list.add(Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        child: _editProfile()
    ));

    list.add(SizedBox(height: 15,));

    if (account.typeReg == "email")
      list.add(Container(
          margin: EdgeInsets.only(left: 30, right: 30),
          child: _changePassword()
      ));

    list.add(SizedBox(height: 15,));

    list.add(Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        child: _logout()
    ));

    list.add(SizedBox(height: 100,));

    return list;
  }

  _editProfile(){
    return Container(
      alignment: Alignment.center,
      child: IButton3(
          color: theme.colorPrimary,
          text: strings.get(146),                           // Edit Profile
          textStyle: theme.text14boldWhite,
          pressButton: _pressEditProfileButton
      ),
    );
  }

  _changePassword(){
    return Container(
      alignment: Alignment.center,
      child: IButton3(
          color: theme.colorPrimary,
          text: strings.get(145),                           // Change password
          textStyle: theme.text14boldWhite,
          pressButton: _onChangePassword
      ),
    );
  }

  _logout(){
    return Container(
      alignment: Alignment.center,
      child: IButton3(
          color: theme.colorPrimary,
          text: strings.get(132),                           // Sign Out
          textStyle: theme.text14boldWhite,
          pressButton: _pressLogOutButton
      ),
    );
  }


  _userInfo(){
    return Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[

            IList4(text: "${strings.get(57)}:", // "Username",
              textStyle: theme.text14bold,
              text2: account.userName,
              textStyle2: theme.text14bold,
            ),
            SizedBox(height: 10,),
            if (account.typeReg == "email")
              IList4(text: "${strings.get(58)}:", // "E-mail",
                textStyle: theme.text14bold,
                text2: account.email,
                textStyle2: theme.text14bold,
              ),
            if (account.typeReg == "google")
              Row(children: [
                Expanded(child: Text(strings.get(273), style: theme.text14bold,)), // "Log In with Google",
                Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 100,
                    child: IButton5(
                        color: Color(0xffd9534f), text: "", textStyle: theme.text14boldWhite,
                        icon: "assets/google.png",),
                )
              ],),
            if (account.typeReg == "facebook")
              Row(children: [
                Expanded(child: Text(strings.get(274), style: theme.text14bold,)), // "Log In with Facebook",
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 100,
                  child: IButton5(
                    color: Color(0xff428bca), text: "", textStyle: theme.text14boldWhite,
                    icon: "assets/facebook.png",),
                )
              ],),
            SizedBox(height: 10,),
            IList4(text: "${strings.get(106)}:", // "Phone",
              textStyle: theme.text14bold,
              text2: account.phone,
              textStyle2: theme.text14bold,
            ),
            SizedBox(height: 10,),

          ],
        )

    );
  }

}

