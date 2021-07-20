import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping/model/server/mainwindowdata.dart';
import 'package:shopping/widget/ilist1.dart';

import '../../../main.dart';
import '../mainscreen.dart';

variants(List<Widget> list, DishesData _this, Function redraw){

  if (_this.variants == null || _this.variants.isEmpty)
    return;

  list.add(Container(
    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
    child: ListWithIcon(imageAsset: "assets/add.png",
        text: strings.get(295),                // Variants
        imageColor: theme.colorDefaultText),
  ));
  list.add(SizedBox(height: 20,));

  for (var item in _this.variants) {

    var _dPrice = "";
    var _price = "";
    if (item.price != 0)
      _price = basket.makePriceString(item.price);
    if (item.dprice != 0) {
      _price = basket.makePriceString(item.dprice);
      _dPrice = basket.makePriceString(item.price);
    }

    list.add(InkWell(
        onTap: () {
          item.select = !item.select;
          for (var item2 in _this.variants) {
            item2.select = false;
            if (item2.id == item.id) {
              item2.select = true;
              _this.price = item2.price;
              _this.discountprice = item2.dprice;
            }
          }
          redraw();
        },
        child: Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(children: [
        if (item.select)
          UnconstrainedBox(
              child: Container(
                  height: 20,
                  width: 20,
                  child: Image.asset("assets/radio_on.png",
                      fit: BoxFit.contain, color: theme.colorPrimary,
                  )
              )),
        if (!item.select)
          UnconstrainedBox(
              child: Container(
                  height: 20,
                  width: 20,
                  child: Image.asset("assets/radio_off.png",
                    fit: BoxFit.contain, color: theme.colorDefaultText.withAlpha(120),
                  )
              )),
        SizedBox(width: 20,),
        if (item.image != null)
          Container(
            width: 40,
            height: 40,
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(0),
              child: Container(
                child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      UnconstrainedBox(child:
                      Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(backgroundColor: theme.colorPrimary, ),
                      )),
                  imageUrl: item.image,
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
        SizedBox(width: 20,),
        Expanded(child: Text(item.name, style: theme.text16bold,)),
        if (_dPrice.isNotEmpty)
          Text(_dPrice, style: theme.text16Ubold,),
        if (_dPrice.isNotEmpty)
          SizedBox(width: 5,),
        Text(_price, style: theme.text18boldPrimary,),
      ],),
    )));
  }
  list.add(SizedBox(height: 20,));
}