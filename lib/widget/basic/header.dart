import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/pref.dart';
import 'package:fooddelivery/ui/main/mainscreen.dart';
import 'package:fooddelivery/widget/basic/search.dart';

bHeaderMenuWidget(var context, Function(String) callback, Color _color, String title){
  return _headerWidget2(context, callback, _color, title, _buttonMenu(callback, _color));
}

bHeaderWidget(var context, Function(String) callback, Color _color, String title){
  return _headerWidget2(context, callback, _color, title, _buttonBack(callback, _color));
}

bHeaderBackButtonWithBasket(var context, Function(String) callback, Color _color){
  return Container(
      height: 40,
      color: Colors.black.withAlpha(50),
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            _buttonBack((String _){Navigator.pop(context);}, _color),
            Expanded(child: Container()),
            _shopping(callback, _color),
          ],
        ),
      ));
}

bHeaderBackButton(var context, Color _color){
  return Container(
      height: 40,
      color: Colors.black.withAlpha(50),
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            _buttonBack((String _){Navigator.pop(context);}, _color)
          ],
        ),
      ));
}

_headerWidget2(var context, Function(String) callback, Color _color, String title, Widget firstIcon){
  var _userAuth = account.isAuth();
  return
    Container(
        color: appSettings.titleBarColor,
        child: Container(
          height: 40,

          margin: EdgeInsets.only(left: 10, right: 10, top: 5+MediaQuery.of(context).padding.top),
          child: Row(
            children: [
              firstIcon,
              SizedBox(width: 20,),
              Expanded(child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    textDirection: strings.direction,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: theme.text16bold,
                  ),
                  Text(pref.get(Pref.city),
                    textDirection: strings.direction,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: theme.text12bold,
                  ),
                ],
              ))),
              if (restaurantSearchValue != "0" || categoriesSearchValue != "0")
                UnconstrainedBox(
                    child: Container(
                        height: 30,
                        width: 30,
                        child: Image.asset("assets/filter2.png",
                            fit: BoxFit.contain
                        )
                    )),
              if (_userAuth)
                _chat(callback, _color),
              if (_userAuth)
                _notify(callback, _color),
              _shopping(callback, _color),
              if (_userAuth)
                _avatar(callback, _color),
            ],
          ),
        ));
}

headerBackButtonWithBasket(var context, Function(String) callback, Color _color){
  return Container(
      height: 40,
      color: Colors.black.withAlpha(50),
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            _buttonBack((String _){Navigator.pop(context);}, _color),
            Expanded(child: Container()),
            _shopping(callback, _color),
          ],
        ),
      ));
}

_buttonMenu(Function(String) callback, Color _color){
  return Stack(
    children: <Widget>[
      UnconstrainedBox(
          child: Container(
              height: 25,
              width: 25,
              child: Image.asset("assets/menu.png",
                fit: BoxFit.contain, color: _color,
              )
          )),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  callback("open_menu");
                }, // needed
              ))),
    ],
  );
}


_buttonBack(Function(String) callback, Color _color){
  return Stack(
    children: <Widget>[
      UnconstrainedBox(
          child: Container(
              height: 25,
              width: 25,
              child: Image.asset("assets/back.png",
                fit: BoxFit.contain, color: _color,
              )
          )),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  callback("");
                }, // needed
              ))),
    ],
  );
}


_avatar(Function(String) callback, Color _color){
  return Stack(
    children: <Widget>[
      UnconstrainedBox(
          child: _avatar2()),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  callback("account");
                }, // needed
              ))),
    ],
  );
}

_avatar2(){
  if (account.userAvatar == null)
    return Container();
  if (account.userAvatar.isEmpty)
    return Container();
  return Container(
    margin: EdgeInsets.only(right: 5, left: 5),
    child: Container(
      width: 25,
      height: 25,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          child: CachedNetworkImage(
            placeholder: (context, url) =>
                CircularProgressIndicator(),
            imageUrl: account.userAvatar,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            errorWidget: (context,url,error) => new Icon(Icons.error),
          ),
        ),
      ),
    ),
  );
}


_shopping(Function(String) callback, Color _color){
  return Stack(
    children: <Widget>[
      UnconstrainedBox(
          child: _shopping2(_color)),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  callback("basket");
                }, // needed
              ))),
    ],
  );
}

_shopping2(Color _color){
  return UnconstrainedBox(
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        height: 25,
        width: 30,
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: UnconstrainedBox(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      height: 25,
                      width: 30,
                      child: Image.asset("assets/shop.png",
                        fit: BoxFit.contain, color: _color,
                      )
                  )),
            ),

            if (basket.inBasket() != 0)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: theme.colorPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(basket.inBasket().toString(), style: theme.text10white),
                  ),
                ),
              )

          ],
        ),
      )
  );
}


_chat(Function(String) callback, Color _color){
  return Stack(
    children: <Widget>[
      UnconstrainedBox(
          child: _chat2(_color)),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  callback("chat");
                }, // needed
              ))),
    ],
  );
}

_chat2(Color _color){
  return UnconstrainedBox(
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        height: 25,
        width: 30,
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: UnconstrainedBox(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      height: 25,
                      width: 30,
                      child: Image.asset("assets/chat.png",
                        fit: BoxFit.contain, color: _color,
                      )
                  )),
            ),

            if (account.chatCount != 0)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: theme.colorPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(account.chatCount.toString(), style: theme.text10white),
                  ),
                ),
              )

          ],
        ),
      )
  );
}


_notify(Function(String) callback, Color _color){
  return Stack(
    children: <Widget>[
      UnconstrainedBox(
          child: _notify2(_color)),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  callback("notify");
                }, // needed
              ))),
    ],
  );
}

_notify2(Color _color){
  return UnconstrainedBox(
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        height: 25,
        width: 30,
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: UnconstrainedBox(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      height: 25,
                      width: 30,
                      child: Image.asset("assets/notifyicon.png",
                        fit: BoxFit.contain, color: _color,
                      )
                  )),
            ),

            if (account.notifyCount != 0)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: theme.colorPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(account.notifyCount.toString(), style: theme.text10white),
                  ),
                ),
              )

          ],
        ),
      )
  );
}
