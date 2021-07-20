import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/foods.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/server/mainwindowdata.dart';
import 'package:shopping/ui/login/needAuth.dart';
import 'package:shopping/ui/main/home/home.dart';
import 'package:shopping/widget/buttonadd.dart';
import 'package:shopping/widget/iinkwell.dart';
import 'package:shopping/widget/ilist2.dart';
import 'package:shopping/widget/wproducts.dart';

class FavoritesScreen extends StatefulWidget {
  final Function(String) callback;
  final scaffoldKey;
  FavoritesScreen({this.callback, this.scaffoldKey});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

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
    if (account.isAuth())
      return Directionality(
          textDirection: strings.direction,
          child: Stack(
        children: [

          if (userFavorites.isNotEmpty)
          Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+50),
              child: ListView(
                  padding: EdgeInsets.only(top: 0),
                  shrinkWrap: true,
                  children: _children()
              )
          ),

          if (userFavorites.isEmpty)
            Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    UnconstrainedBox(
                        child: Container(
                            height: windowHeight/3,
                            width: windowWidth/2,
                            child: Container(
                              child: Image.asset("assets/noorders.png",
                                fit: BoxFit.contain,
                              ),
                            )
                        )),
                    SizedBox(height: 20,),
                    Text(strings.get(179),    // "Not Have Favorites Food",
                        overflow: TextOverflow.clip,
                        style: theme.text16bold
                    ),
                    SizedBox(height: 50,),
                  ],
                )
            ),

          if (_addToBasketItem != null)
            Container(
              margin: EdgeInsets.only(bottom: 60),
              child: buttonAddToCart(_addToBasketItem, (){setState(() {});}, ( ){_addToBasketItem = null; setState(() {});},
                  widget.scaffoldKey),
            ),
        ],
      ));
    else
      return mustAuth(windowWidth, context);
  }

  bool _selectList = false;

  _children(){
    List<Widget> list = [];

    list.add(SizedBox(height: 10,));

    if (theme.appSkin == "basic"){
      list.add(Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: IList2(imageAsset: "assets/favorites.png",
            text: strings.get(38),                      // "Favorites",
            textStyle: theme.text16bold,
            imageColor: theme.colorDefaultText,
            child1: IInkWell(child: _listIcon(), onPress: _onListIconClick,),
            child2: IInkWell(child: _tileIcon(), onPress: _onTileIconClick,),
          )
      ));
      list.add(SizedBox(height: 20,));
    }
    if (theme.appSkin == "smarter")
      list.add(Container(
          color: appSettings.categoriesTitleColor,
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.favorite, color: appSettings.getIconColorByMode(theme.darkMode),),
              SizedBox(width: 10,),
              Expanded(child: Text(strings.get(38), style: theme.text16bold,)),  // Favorites
              IInkWell(child: _listIconS(), onPress: _onListIconClick,),
              SizedBox(width: 5,),
              IInkWell(child: _tileIconS(), onPress: _onTileIconClick,)
            ],
          )
      ));

    if (!_selectList) {
      if (appSettings.typeFoods == "type2")
        dishList2(list, userFavorites, context, _onItemClick, windowWidth, "", _onAddToCartClick);
      else
        dishList(list, userFavorites, context, _onItemClick, windowWidth, _onAddToCartClick, "");
    }else
      dishListOneInLine(list, userFavorites, _onItemClick, windowWidth, _onAddToCartClick, "");

    list.add(SizedBox(height: 200,));

    return list;
  }

  _onAddToCartClick(String id){
    dprint("add to cart click id=$id");
    _addToBasketItem = loadFood(id);
    _addToBasketItem.count = 1;
    setState(() {
    });
  }

  DishesData _addToBasketItem;

  _redraw(){
    if (mounted)
      setState(() {

      });
  }

  _listIcon(){
    if (_selectList)
      return UnconstrainedBox(
          child: Container(
              height: 30,
              width: 30,
              child: Image.asset("assets/list.png",
                fit: BoxFit.contain, color: theme.colorPrimary,
              )
          ));
    else
      return UnconstrainedBox(
          child: Container(
              height: 20,
              width: 20,
              child: Image.asset("assets/list.png",
                fit: BoxFit.contain, color: theme.colorDefaultText,
              )
          ));
  }

  _tileIcon(){
    if (!_selectList)
      return UnconstrainedBox(
          child: Container(
              height: 30,
              width: 30,
              child: Image.asset("assets/tile.png",
                fit: BoxFit.contain, color: theme.colorPrimary,
              )
          ));
    else
      return UnconstrainedBox(
          child: Container(
              height: 20,
              width: 20,
              child: Image.asset("assets/tile.png",
                fit: BoxFit.contain, color: theme.colorDefaultText,
              )
          ));
  }

  _listIconS(){
    if (_selectList)
      return Icon(Icons.list_alt, color: theme.colorPrimary, size: 40,);
    else
      return Icon(Icons.list_alt, color: Colors.grey, size: 25,);
  }

  _tileIconS(){
    if (!_selectList)
      return Icon(Icons.apps_outlined, color: theme.colorPrimary, size: 40,);
    else
      return Icon(Icons.apps_outlined, color: Colors.grey, size: 25,);
  }

  _onItemClick(String id, String heroId){
    print("User pressed item with id: $id");
    idHeroes = heroId;
    idDishes = id;
    route.setDuration(1);
    route.push(context, "/dishesdetails");
  }

  _onListIconClick(){
    if (!_selectList){
      _selectList = true;
      _redraw();
    }
  }
  _onTileIconClick(){
    if (_selectList){
      _selectList = false;
      _redraw();
    }
  }

}
