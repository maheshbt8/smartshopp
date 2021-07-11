import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/categories.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/widget/basic/search.dart';

sSkinHomeCategory(List<Widget> list, double windowWidth, Function(String id, String heroId, String image) _onCategoriesClick){
  list.add(Container(
    color: appSettings.categoriesTitleColor,
    padding: EdgeInsets.all(10),
    child: Row(
      children: [
        Icon(Icons.category, color: appSettings.getIconColorByMode(theme.darkMode),),
        SizedBox(width: 10,),
        Expanded(child: Text(strings.get(268), style: theme.text16bold,))  // "Food categories",
      ],
    )
  ));
  if (appSettings.categoryCardCircle == "true")
    list.add(_horizontalCategoriesCircle(windowWidth, _onCategoriesClick));
  else
    list.add(_horizontalCategories(windowWidth, _onCategoriesClick));
}

_horizontalCategories(double windowWidth, Function(String id, String hero, String image) _onCategoriesClick){
  List<Widget> list = [];
  list.add(SizedBox(width: 10,));
  var height = windowWidth*appSettings.categoryCardHeight/100;
  for (var item in categories) {
    if (categoriesSearchValue != "0" && item.id != categoriesSearchValue)
      continue;
    if (theme.vendor && item.vendor != '0')
      continue;
    if (item.parent == "0" || item.parent == "-1") {
      list.add(ICard12FileCaching(
        shadow: appSettings.shadow,
        radius: appSettings.radius,
        color: theme.colorBackground,
        colorProgressBar: theme.colorPrimary,
        text: item.name,
        width: windowWidth * appSettings.categoryCardWidth / 100,
        height: height,
        image: item.image,
        id: item.id,
        textStyle: theme.text16,
        callback: _onCategoriesClick,
      ));
      list.add(SizedBox(width: 20,));
    }
  }
  if (list.length == 1)
    return Container();
  return Container(
    color: appSettings.categoriesBackgroundColor,
    padding: EdgeInsets.only(top: 10),
    height: height+20,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list,
    ),
  );
}

class ICard12FileCaching extends StatefulWidget {
  final Color color;
  final Color colorProgressBar;
  final double width;
  final double height;
  final String text;
  final String image;
  final String id;
  final TextStyle textStyle;
  final Function(String id, String hero, String image) callback;
  final double radius;
  final int shadow;

  ICard12FileCaching({this.color = Colors.white, this.width = 100, this.height = 100,
    this.text = "", this.image = "", this.colorProgressBar = Colors.black,
    this.id = "", this.textStyle, this.callback,
    this.radius, this.shadow,
  });

  @override
  _ICard12FileCachingState createState() => _ICard12FileCachingState();
}

class _ICard12FileCachingState extends State<ICard12FileCaching>{

  var _textStyle = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    var cwidth = widget.width;
    // if (widget.height < cwidth)
    //  cwidth = widget.height;
    var radius = widget.radius;
    var borderR = BorderRadius.only(topLeft: Radius.circular(radius), topRight: Radius.circular(radius));
    // if (appSettings.categoryCardCircle == "true") {
    //   radius = 100;
    //   borderR = BorderRadius.all(Radius.circular(radius));
    // }
    var _id = UniqueKey().toString();
    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
    return InkWell(
        onTap: () {
          if (widget.callback != null)
            widget.callback(widget.id, _id, widget.image);
        }, // needed
        child: Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          width: widget.width,
          height: widget.height,
          child: Column(
            children: <Widget>[

              Expanded(child: Hero(
                  tag: _id,
                  child: Container(
                      width: cwidth,
                      height: cwidth,
                      decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: new BorderRadius.circular(radius),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withAlpha(widget.shadow+20),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(2, 2), // changes position of shadow
                            ),
                          ]
                      ),
                      child: ClipRRect(
                        borderRadius: borderR,
                        child: Container(
                          width: cwidth,
                          height: cwidth,
                          color: Colors.white,
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                UnconstrainedBox(child:
                                Container(
                                  alignment: Alignment.center,
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(),
                                )),
                            imageUrl: widget.image,
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
                        ),                  )
                  ))),

              InkWell(
                  onTap: () {
                    if (widget.callback != null)
                      widget.callback(widget.id, _id, widget.image);
                  }, // needed
                  child: Container(
                    width: widget.width,
                    margin: EdgeInsets.only(top: 5),
                    child: Text(widget.text, style: _textStyle, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
                  )),

            ],
          ),
        ));
  }
}

_horizontalCategoriesCircle(double windowWidth, Function(String id, String hero, String image) _onCategoriesClick){
  List<Widget> list = [];
  list.add(SizedBox(width: 10,));
  var height = windowWidth*appSettings.categoryCardHeight/100;
  for (var item in categories) {
    if (categoriesSearchValue != "0" && item.id != categoriesSearchValue)
      continue;
    if (theme.vendor && item.vendor != '0')
      continue;
    if (item.parent == "0" || item.parent == "-1") {
      list.add(ICard12FileCachingC(
        shadow: appSettings.shadow,
        radius: appSettings.radius,
        color: theme.colorBackground,
        colorProgressBar: theme.colorPrimary,
        text: item.name,
        width: windowWidth * appSettings.categoryCardWidth / 100,
        height: height,
        image: item.image,
        id: item.id,
        textStyle: theme.text16,
        callback: _onCategoriesClick,
      ));
      list.add(SizedBox(width: 10,));
    }
  }
  if (list.length == 1)
    return Container();
  return Container(
    color: appSettings.categoriesBackgroundColor,
    padding: EdgeInsets.only(top: 10),
    height: height+20,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list,
    ),
  );
}

class ICard12FileCachingC extends StatefulWidget {
  final Color color;
  final Color colorProgressBar;
  final double width;
  final double height;
  final String text;
  final String image;
  final String id;
  final TextStyle textStyle;
  final Function(String id, String hero, String image) callback;
  final double radius;
  final int shadow;

  ICard12FileCachingC({this.color = Colors.white, this.width = 100, this.height = 100,
    this.text = "", this.image = "", this.colorProgressBar = Colors.black,
    this.id = "", this.textStyle, this.callback,
    this.radius, this.shadow,
  });

  @override
  _ICard12FileCachingCState createState() => _ICard12FileCachingCState();
}

class _ICard12FileCachingCState extends State<ICard12FileCachingC>{

  var _textStyle = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    // var cwidth = widget.width;
    // if (widget.height < cwidth)
    //  cwidth = widget.height;
    // var radius = widget.radius;
    // var borderR = BorderRadius.only(topLeft: Radius.circular(radius), topRight: Radius.circular(radius));
    // if (appSettings.categoryCardCircle == "true") {
    //   radius = 100;
    //   borderR = BorderRadius.all(Radius.circular(radius));
    // }
    var _id = UniqueKey().toString();
    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
    return InkWell(
        onTap: () {
          if (widget.callback != null)
            widget.callback(widget.id, _id, widget.image);
        }, // needed
        child: Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          width: widget.width,
          height: widget.height,
          child: Column(
            children: <Widget>[

              Expanded(child: Hero(
                  tag: _id,
                  child: Container(
                      // width: cwidth,
                      // height: cwidth,
                      decoration: BoxDecoration(
                          color: widget.color,
                          shape: BoxShape.circle,
                          // borderRadius: new BorderRadius.circular(radius),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withAlpha(widget.shadow+20),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(2, 2), // changes position of shadow
                            ),
                          ]
                      ),
                      child: Container(
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                UnconstrainedBox(child:
                                Container(
                                  alignment: Alignment.center,
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(),
                                )),
                            imageUrl: widget.image,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            errorWidget: (context,url,error) => new Icon(Icons.error),
                          ),
                        ),                  )
                  )),

              InkWell(
                  onTap: () {
                    if (widget.callback != null)
                      widget.callback(widget.id, _id, widget.image);
                  }, // needed
                  child: Container(
                    width: widget.width,
                    margin: EdgeInsets.only(top: 5),
                    child: Text(widget.text, style: _textStyle, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
                  )),

            ],
          ),
        ));
  }
}

//
// sCategoryDetails(List<Widget> list, double windowWidth, Function (String id, String heroId) callback, Function _onAddToCartClick){
//   for (var item in categories) {
//     if (item.parent != "0" && item.parent != "-1")
//       continue;
//     if (categoriesSearchValue != "0" && item.id != categoriesSearchValue)
//       continue;
//     if (theme.vendor && item.vendor != '0')
//       continue;
//     var t = categoryDetailsHorizontal(item.id, windowWidth, callback, _onAddToCartClick);
//     if (t == null) {
//       for (var item2 in categories) {
//         if (item2.parent == item.id){
//           t = categoryDetailsHorizontal(item2.id, windowWidth, callback, _onAddToCartClick);
//           if (t != null)
//             break;
//         }
//       }
//       if (t == null)
//         continue;
//     }
//
//     list.add(Container(
//         margin: EdgeInsets.all(10),
//         width: windowWidth,
//         height: 40,
//         child: Row(children: [
//           Container(
//               width: 40,
//               height: 40,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(5),
//                 child: Container(
//                   child: CachedNetworkImage(
//                     placeholder: (context, url) =>
//                         UnconstrainedBox(child:
//                         Container(
//                           alignment: Alignment.center,
//                           width: 40,
//                           height: 40,
//                           child: CircularProgressIndicator(),
//                         )),
//                     imageUrl: item.image,
//                     imageBuilder: (context, imageProvider) =>
//                         Container(
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: imageProvider,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                     errorWidget: (context, url, error) =>
//                     new Icon(Icons.error),
//                   ),
//                 ),
//               )),
//           SizedBox(width: 10,),
//           Expanded(child: Text(item.name, style: theme.text14, textAlign: TextAlign.center,))
//         ],)));
//
//     list.add(t);
//     //
//   }
//   list.add(SizedBox(height: 20,));
// }
//
// categoryDetailsHorizontal(String categoryId, double windowWidth, Function (String id, String heroId) callback,
//     Function _onAddToCartClick){
//   List<Widget> list = [];
//   list.add(SizedBox(width: 10,));
//   var height = windowWidth*appSettings.restaurantCardHeight/100;
//   for (var item in foodsAll) {
//     if (item.category != categoryId)
//       continue;
//     if (restaurantSearchValue != "0" && item.restaurant != restaurantSearchValue)
//       continue;
//     if (categoriesSearchValue != "0" && item.category != categoriesSearchValue)
//       continue;
//     list.add(ProductsTileListV2(
//       radius: appSettings.radius,
//       shadow: appSettings.shadow,
//       colorProgressBar: theme.colorPrimary,
//       color: theme.colorBackground,
//       getFavoriteState: account.getFavoritesState,
//       revertFavoriteState: account.revertFavoriteState,
//       text: item.name,
//       enableFavorites: account.isAuth(),
//       width: windowWidth*0.6,
//       height: height,
//       image: "$serverImages${item.image}",
//       id: item.id,
//       text3: (theme.multiple) ? item.restaurantName : getCategoryName(item.category),
//       discount: item.discount,
//       discountprice: basket.makePriceString(item.discountprice),
//       price: basket.makePriceString(item.price),
//       callback: callback,
//       onAddToCartClick: _onAddToCartClick,
//     ));
//     list.add(SizedBox(width: 20,));
//   }
//   if (list.length == 1)
//     return null;
//   return Container(
//     color: appSettings.restaurantBackgroundColor,
//     height: height+10,
//     child: ListView(
//       scrollDirection: Axis.horizontal,
//       children: list,
//     ),
//   );
// }