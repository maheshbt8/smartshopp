import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import '../ibackground4.dart';
import '../iline.dart';


bMenuItem(int id, String name, String imageAsset, BuildContext context, Function(int) _onMenuClickItem){
  return Stack(
    children: <Widget>[
      ListTile(
        title: Text(name, style: theme.text16bold,),
        leading:  UnconstrainedBox(
            child: Container(
                height: 25,
                width: 25,
                child: Image.asset(imageAsset,
                  fit: BoxFit.contain,
                  color: theme.colorPrimary,
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

bMenuTitle(BuildContext context){
  if (account.isAuth())
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top,),
        Container(
            height: 100,
            child: Row(
              children: <Widget>[
                UnconstrainedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: _avatar(),
                      margin: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
                    )
                ),
                SizedBox(width: 20,),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(account.userName, style: theme.text18boldPrimary,),
                      if (account.typeReg == "email")
                        Text(account.email, style: theme.text16,),
                    ],
                  ),
                ),

              ],

            )
        ),
        if (account.isAuth())
          ILine(),
      ],
    );
  // no auth
  return Container(
    height: 100+MediaQuery.of(context).padding.top,
    child: IBackground4(colorsGradient: theme.colorsGradient),
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