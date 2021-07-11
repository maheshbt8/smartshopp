
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';

sMenuItem(int id, String name, IconData iconData, BuildContext context, Function(int) _onMenuClickItem){
  return Stack(
    children: <Widget>[
      ListTile(
        title: Text(name, style: TextStyle(fontSize: theme.sMenuFontSize, color: theme.sMenuColor, fontWeight: FontWeight.w800 ),),
        leading:  UnconstrainedBox(
            child: Container(
                height: 25,
                width: 25,
                child: Icon(iconData,
                  color: theme.sMenuColor,
                )
            )),
      ),
      Positioned.fill(
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.grey[400],
              onTap: () {
                Navigator.pop(context);
                _onMenuClickItem(id);
              }, // needed
            )),
      )
    ],
  );
}
sMenuTitle(BuildContext context){
  if (account.isAuth())
    return Container(
      color: theme.sGreyColor,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top,),
        Container(
          decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(100),
          ),
          child: _avatar(),
          margin: EdgeInsets.only(top: 10, bottom: 10),
        ),
        SizedBox(width: 20,),

        Text(account.userName, style: theme.text18boldPrimary,),
        if (account.typeReg == "email")
          SizedBox(height: 5,),
        if (account.typeReg == "email")
          Text(account.email, style: theme.text14,),
      ],
    )
  );
  // no auth
  return Container(
    height: 80+MediaQuery.of(context).padding.top,
    child: Container(
      padding: EdgeInsets.only(top: 20+MediaQuery.of(context).padding.top),
      color: theme.sGreyColor,
      child: ListTile(
        title: Text(strings.get(310), style: TextStyle(fontSize: theme.sMenuFontSize, color: theme.sMenuColor, fontWeight: FontWeight.w800 ),),
        leading:  Icon(Icons.account_circle, color: theme.colorPrimary, size: 40,)
      ),
    ),
  );
}

_avatar(){
  if (!account.isAuth())
    return Container();
  else
    return Container(
      width: 55,
      height: 55,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(55),
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
    );
}