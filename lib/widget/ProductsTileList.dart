import 'package:flutter/material.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/widget/widgets.dart';
import '../main.dart';
import 'cacheImageWidget.dart';

class ProductsTileList extends StatefulWidget {
  final Color color;
  final double width;
  final double height;
  final String text;
  final String price;
  final String discountprice;
  final String text3;
  final String image;
  final String id;
  final Function(String id, String heroId) callback;
  final String discount;
  final Function(String) onAddToCartClick;
  final bool needAddToCart;

  ProductsTileList({this.color = Colors.white, this.width = 100, this.height = 100,
    this.text = "", this.image = "", this.price = "",
    this.id = "", this.callback,
    this.text3 = "", this.onAddToCartClick, this.discountprice, this.discount, this.needAddToCart = true
  });

  @override
  _ProductsTileListState createState() => _ProductsTileListState();
}

class _ProductsTileListState extends State<ProductsTileList>{

  @override
  Widget build(BuildContext context) {

    if (theme.appSkin == "smarter")
      return _smarter();

    var _id = UniqueKey().toString();

    Widget _favorites = Container();
    if (account.isAuth())
      _favorites = Container(
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 5, right: 5),
        child: Stack(
          children: <Widget>[
            Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Icon((account.getFavoritesState(widget.id)) ? Icons.favorite : Icons.favorite_border, color: theme.colorPrimary, size: 20,),
                  ],
                )
            ),
            Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.grey[400],
                    onTap: (){
                      account.revertFavoriteState(widget.id);
                    }, // needed
                  )),
            )
          ],
        ),
      );

    Widget _sale = Container();
    if (widget.discountprice != null && widget.discountprice.isNotEmpty) {
      var t = widget.width;
      if (t == MediaQuery.of(context).size.width)
        t /= 2;
      _sale = saleSticker(t, widget.discount, widget.discountprice, widget.price);
    }

    return InkWell(
        onTap: () {
      if (widget.callback != null)
        widget.callback(widget.id, _id);
    }, // needed
    child: Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          width: widget.width,
          height: widget.height-20,
          decoration: BoxDecoration(
              color: widget.color,
              border: Border.all(color: Colors.black.withAlpha(100)),
              borderRadius: new BorderRadius.circular(appSettings.radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(appSettings.shadow),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ]
          ),
          child: Stack(
            children: [

              Column(
                children: <Widget>[
                  Expanded(child:
                      Stack(
                          children: [
                            Hero(
                                tag: _id,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(appSettings.radius), topRight: Radius.circular(appSettings.radius)),
                                  child: Container(
                                      width: widget.width,
                                      height: widget.height-20,
                                      child: cacheImageWidgetCover(widget.image, theme.colorPrimary)
                                  ),
                                )
                            ),

                        if (widget.needAddToCart)
                            Container(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                onTap: () {
                                  widget.onAddToCartClick(widget.id);
                                },
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: theme.colorPrimary.withAlpha(220),
                                    border: Border.all(color: theme.colorPrimary),
                                    borderRadius: new BorderRadius.only(topLeft: Radius.circular(30)),
                                  ),
                                  child: UnconstrainedBox(
                                      child: Container(
                                          margin: EdgeInsets.only(top: 10, left: 10),
                                          height: 30,
                                          width: 30,
                                          child: Image.asset("assets/addtocart.png",
                                            fit: BoxFit.contain, color: Colors.white,
                                          )
                                      )),
                                ))),



                        ],
                      )
                      ),

                  InkWell(
                      onTap: () {
                        if (widget.callback != null)
                          widget.callback(widget.id, _id);
                      },
                      child: Container(
                        width: widget.width,
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(widget.text, style: theme.text18boldPrimaryUI, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,),
                            Row(
                              children: [
                                Expanded(child: Text(widget.text3, style: theme.text16UI, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)),
                                Text(widget.price, style: theme.text18boldPrimaryUI, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,),
                              ],
                            ),
                            SizedBox(height: 5,)
                          ],
                        ),
                      )),

                ],
              ),

              _favorites,
              _sale,



            ],
          ),
    ));
  }

  _smarter(){
    var _id = UniqueKey().toString();

    Widget _favorites = Container();
    if (account.isAuth())
      _favorites = Container(
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 5, right: 5),
        child: Stack(
          children: <Widget>[
            Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Icon((account.getFavoritesState(widget.id)) ? Icons.favorite : Icons.favorite_border, color: theme.colorPrimary, size: 20,),
                  ],
                )
            ),
            Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.grey[400],
                    onTap: (){
                      account.revertFavoriteState(widget.id);
                    }, // needed
                  )),
            )
          ],
        ),
      );

    Widget _sale = Container();
    if (widget.discountprice != null && widget.discountprice.isNotEmpty) {
      var t = widget.width;
      if (t == MediaQuery.of(context).size.width)
        t /= 2;
      _sale = Container(
        alignment: Alignment.bottomLeft,
        child: saleSticker(t, widget.discount, widget.discountprice, widget.price),
      );
    }

    return InkWell(
        onTap: () {
          if (widget.callback != null)
            widget.callback(widget.id, _id);
        }, // needed
        child: Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          width: widget.width,
          height: widget.height-20,
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: new BorderRadius.circular(appSettings.radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(appSettings.shadow),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ]
          ),
          child: Stack(
            children: [

              Column(
                children: <Widget>[
                  Expanded(child:
                  Stack(
                    children: [
                      Hero(
                          tag: _id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(appSettings.radius)),
                            child: Container(
                                width: widget.width+10,
                                height: widget.height,
                                child: cacheImageWidgetCover(widget.image, theme.colorPrimary)
                            ),
                          )
                      ),

                      if (widget.needAddToCart)
                        Container(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                                onTap: () {
                                  widget.onAddToCartClick(widget.id);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: theme.colorPrimary.withAlpha(220),
                                    border: Border.all(color: theme.colorPrimary),
                                    borderRadius: new BorderRadius.only(topLeft: Radius.circular(30)),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Icon(Icons.add_shopping_cart_sharp, color: Colors.white,),
                                  )
                                ))),

                      //
                      // PRICE
                      //
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorPrimary,
                          borderRadius: new BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Text((widget.discountprice.isNotEmpty) ? widget.discountprice : widget.price,
                          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w800),
                          overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,),
                      ),

                      _sale,
                    ],
                  )
                  ),

                  InkWell(
                      onTap: () {
                        if (widget.callback != null)
                          widget.callback(widget.id, _id);
                      },
                      child: Container(
                        width: widget.width,
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(widget.text, style: theme.text18boldPrimaryUI, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
                            Text(widget.text3, style: theme.text16UI, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
                            // Row(
                            //   children: [
                            //     Expanded(child: Text(widget.text3, style: _textStyle3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)),
                            //     Text(widget.price, style: _textStyle2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,),
                            //   ],
                            // ),
                            SizedBox(height: 5,)
                          ],
                        ),
                      )),

                ],
              ),

              _favorites,

            ],
          ),
        ));
  }
}