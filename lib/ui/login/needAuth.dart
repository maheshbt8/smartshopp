import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/widget/ibutton3.dart';

_pressLoginButton(BuildContext context){
  print("User pressed \"LOGIN\" button");
  route.push(context, "/login");
}

_pressDontHaveAccountButton(BuildContext context){
  print("User press \"Don't have account\" button");
  route.push(context, "/createaccount");
}

mustAuthSmarter(double windowWidth, BuildContext context){
  return Center(
    child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UnconstrainedBox(
                child: Container(
                    width: windowWidth*0.4,
                    child: Image.asset("assets/authSmarter.png",
                      fit: BoxFit.contain, color: Colors.black.withAlpha(80),
                    )
                )
            ),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.only(left: windowWidth*0.15, right: windowWidth*0.15),
              child: Text(strings.get(125), textAlign: TextAlign.center, style: theme.text18boldPrimary), // "You must sign-in to access to this section",
            ),
            SizedBox(height: 40,),
            Container(
              margin: EdgeInsets.only(left: windowWidth*0.2, right: windowWidth*0.2),
              child: IButton3(pressButton: (){_pressLoginButton(context);}, text: strings.get(22), // LOGIN
                color: theme.colorPrimary,
                textStyle: theme.text16boldWhite,),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
              child: InkWell(
                  onTap: () {
                    _pressDontHaveAccountButton(context);
                  }, // needed
                  child:Text(strings.get(19),                    // ""Don't have an account? Create",",
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: theme.text14primary
                  )),
            )
          ],
        )
    ),
  );
}

mustAuth(double windowWidth, BuildContext context){
  if (theme.appSkin == "smarter")
    return mustAuthSmarter(windowWidth, context);
  return Center(
    child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UnconstrainedBox(
                child: Container(
                    width: windowWidth/3,
                    child: Image.asset("assets/auth.png",
                      fit: BoxFit.contain, color: Colors.black.withAlpha(80),
                    )
                )
            ),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.only(left: windowWidth*0.15, right: windowWidth*0.15),
              child: Text(strings.get(125), textAlign: TextAlign.center,), // "You must sign-in to access to this section",
            ),
            SizedBox(height: 40,),
            Container(
              margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
              child: IButton3(pressButton: (){_pressLoginButton(context);}, text: strings.get(22), // LOGIN
                color: theme.colorPrimary,
                textStyle: theme.text16boldWhite,),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
              child: InkWell(
                  onTap: () {
                    _pressDontHaveAccountButton(context);
                  }, // needed
                  child:Text(strings.get(19),                    // ""Don't have an account? Create",",
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: theme.text14primary
                  )),
            )
          ],
        )
    ),
  );
}