import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/ui/main/mainscreen.dart';
import 'package:fooddelivery/widget/iinkwell.dart';
import 'ibutton3.dart';

buttonAddToCart(DishesData item, Function redraw, Function onCancel, var _scaffoldKey){

  _onMinusClick(){
    dprint("User click minus button");
    if (item.count > 1)
      item.count--;
    redraw();
  }

  _onPlusClick(){
    dprint("User click plus button");
    item.count++;
    redraw();
  }

  return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
          onTap: () {
            onCancel();
          },
          child: Container(
          height: 40,
          width: 50,
          decoration: BoxDecoration(
            color: theme.colorPrimary,
            borderRadius: new BorderRadius.only(topLeft: Radius.circular(MediaQuery.of(mainContext).size.width*0.08)),
          ),
          child: UnconstrainedBox(
            child: RotationTransition(
                turns: new AlwaysStoppedAnimation(45 / 360),
                child: Container(
              margin: EdgeInsets.only(top: 5, left: 10),
                height: 25,
                width: 25,
                child: Image.asset("assets/add.png",
                    fit: BoxFit.contain, color: Colors.white,
                )
            ))),
        )),
        Container(
            color: theme.colorPrimary,
            width: MediaQuery.of(mainContext).size.width,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(child: IButton3(text: strings.get(90),                           // Add to cart
                    textStyle: theme.text14boldWhite,
                  color: theme.colorPrimary, pressButton: () {
                      dprint("User pressed \"Add to cart\" button. Count = ${item.count}");
                      if (!account.isAuth())
                        return route.push(mainContext, "/login");
                      if (basket.restaurantCheck(item.restaurant)) {
                        if (basket.dishInBasket(item.id))
                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                            content: new Text(strings.get(131)), // "This food already added to cart",
                            duration: Duration(seconds: 3),
                          ));
                        else {
                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                            content: new Text(strings.get(130)), // "This food was added to cart",
                            duration: Duration(seconds: 3),
                          ));
                          basket.add(item);
                          redraw();
                          account.redraw();
                        }
                        onCancel();
                      }else{
                        _openResetDishesDialog(_scaffoldKey, item, onCancel);
                      }
                    }),
                ),
                Flexible(
                    child: FittedBox(child: Text(basket.makePriceString(basket.getItemPrice(item)),
                      style: theme.text20boldWhite,),
                    )),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IInkWell(child: Icon(Icons.remove_circle_outline, color: (item.count == 1) ? Colors.grey : Colors.white, size: 25,), onPress: _onMinusClick,),
                          SizedBox(width: 10,),
                          Text(item.count.toString(), style: theme.text20boldWhite,),
                          SizedBox(width: 10,),
                          IInkWell(child: Icon(Icons.add_circle_outline, color: Colors.white, size: 25,), onPress: _onPlusClick,),
                        ],
                      )
                  )
                )
              ],
            )
        )
      ],
    )
  );
}

_openResetDishesDialog(var _scaffoldKey, DishesData item, Function onCancel){
  if (!noMain) {
    mainDialogBody = _body3(_scaffoldKey, item, onCancel);
    mainDialogShow = 1;
  }else {
    mainCurrentDialogBody = _body3(_scaffoldKey, item, onCancel);
    mainCurrentDialogShow = 1;
  }
  account.redraw();
}

_body3(var _scaffoldKey, DishesData item, Function onCancel){
  return Container(
      width: MediaQuery.of(mainContext).size.width,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Text(strings.get(82), textAlign: TextAlign.center, style: theme.text18boldPrimary,), // "You can add to cart, only dishes from single restaurant. Do you want to reset cart? And add new dishes.",
          SizedBox(height: 50,),
          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(mainContext).size.width/2-45,
                      child: IButton3(
                          color: Colors.red,
                          text: strings.get(83), // Reset
                          textStyle: theme.text14boldWhite,
                          pressButton: (){
                            if (!noMain)
                              mainDialogShow = 0;
                            else
                              mainCurrentDialogShow = 0;
                            account.redraw();
                            _callbackReset(_scaffoldKey, item, onCancel);
                          }
                      )),
                  SizedBox(width: 10,),
                  Container(
                      width: MediaQuery.of(mainContext).size.width/2-45,
                      child: IButton3(
                          color: theme.colorPrimary,
                          text: strings.get(84), // Cancel
                          textStyle: theme.text14boldWhite,
                          pressButton: (){
                            if (!noMain)
                              mainDialogShow = 0;
                            else
                              mainCurrentDialogShow = 0;
                            account.redraw();
                          }
                      )),
                ],
              )),

        ],
      )
  );
}

_callbackReset(var _scaffoldKey, DishesData item, Function onCancel){
  dprint("Reset cart");
  if (!account.isAuth()){
    basket.basket.clear();
    basket.add(item);
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(strings.get(130)), // "This food was added to cart",
      duration: Duration(seconds: 3),
    ));
    account.redraw();
    onCancel();
  }else {
    basket.reset(() {
      basket.add(item);
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(strings.get(130)), // "This food was added to cart",
        duration: Duration(seconds: 3),
      ));
      account.redraw();
      onCancel();
    });
  }
}