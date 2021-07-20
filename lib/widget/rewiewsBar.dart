import 'package:flutter/material.dart';
import 'package:shopping/model/server/getRestaurant.dart';
import 'package:shopping/model/server/mainwindowdata.dart';
import '../main.dart';
import 'ReviewsText.dart';
import 'ilist1.dart';

foodsReviews(List<Widget> list, DishesData _this, double windowWidth){
  if (_this.foodsreviews.isEmpty)
    return;
  var _all = 0;
  var _count = 0;
  var _count1 = 0;
  var _count2 = 0;
  var _count3 = 0;
  var _count4 = 0;
  var _count5 = 0;
  var _maxValue = 0;
  var _total = "";
  var _totals = 0.0;
  for (var item in _this.foodsreviews) {
    if (item.userName != "null") {
      _all += item.rate;
      _count ++;
      if (item.rate == 1) _count5++;
      if (item.rate == 2) _count4++;
      if (item.rate == 3) _count3++;
      if (item.rate == 4) _count2++;
      if (item.rate == 5) _count1++;
    }
  }
  if (_count != null) {
    _totals = _all/_count;
    _total = _totals.toStringAsFixed(1);
    if (_count1 > _maxValue) _maxValue = _count1;
    if (_count2 > _maxValue) _maxValue = _count2;
    if (_count3 > _maxValue) _maxValue = _count3;
    if (_count4 > _maxValue) _maxValue = _count4;
    if (_count5 > _maxValue) _maxValue = _count5;
  }
  var star1 = 0.0;
  var star2 = 0.0;
  var star3 = 0.0;
  var star4 = 0.0;
  var star5 = 0.0;
  if (_totals > 1) {
    star1 = 1;
    if (_totals > 2) {
      star2 = 1;
      if (_totals > 3) {
        star3 = 1;
        if (_totals > 4) {
          star4 = 1;
          if (_totals > 5)
            star5 = 1;
          else star5 = _totals-4;
        }else star4 = _totals-3;
      }else star3 = _totals-2;
    }else star2 = _totals-1;
  }else star1 = _totals;

  list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: ListWithIcon(imageAsset: "assets/reviews.png", text: strings.get(77),                                // "Reviews",
          imageColor: theme.colorDefaultText),
      ));

  if (_count != 0) {
    list.add(SizedBox(height: 20,));
    var bwidth = windowWidth * 0.7 - 20;
    var _oneItem = bwidth / _maxValue;
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        width: windowWidth - 20,
        child: Row(
          children: [
            Container(
                width: bwidth,
                child: Column(
                  children: [
                    oneBar("5", bwidth, _oneItem * _count1),
                    SizedBox(height: 10,),
                    oneBar("4", bwidth, _oneItem * _count2),
                    SizedBox(height: 10,),
                    oneBar("3", bwidth, _oneItem * _count3),
                    SizedBox(height: 10,),
                    oneBar("2", bwidth, _oneItem * _count4),
                    SizedBox(height: 10,),
                    oneBar("1", bwidth, _oneItem * _count5),
                  ],
                )
            ),
            Container(
              width: windowWidth * 0.3,
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  FittedBox(
                      child: Text(_total, style: theme.text60,)
                  ),
                  FittedBox(child: Stack(
                    children: [
                      Row(children: [
                        Icon(Icons.star, color: Color(0xffe8eaed),),
                        Icon(Icons.star, color: Color(0xffe8eaed),),
                        Icon(Icons.star, color: Color(0xffe8eaed),),
                        Icon(Icons.star, color: Color(0xffe8eaed),),
                        Icon(Icons.star, color: Color(0xffe8eaed),),
                      ],),
                      Row(children: [
                        _icon(star1),
                        _icon(star2),
                        _icon(star3),
                        _icon(star4),
                        _icon(star5),
                      ],)
                    ],
                  )),
                  Text("${strings.get(297)} : $_count")    // reviews
                ],
              ),
            )
          ],
      )));
    }
    list.add(SizedBox(height: 20,));
    for (var item in _this.foodsreviews) {
      if (item.userName != "null") {
        list.add(Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: ReviewsText(
            color: theme.colorPrimary,
            title: item.userName,
            text: item.desc,
            date: item.createdAt,
            userAvatar: item.image,
            rating: item.rate,
          ),
        ));
      }
    }
}

_icon(double wf){
  return Align(
    alignment: Alignment.center,
    child: ClipRect(
    child: Align(
    alignment: Alignment.centerLeft,
    widthFactor: wf,
    heightFactor: 1.0,
    child: Icon(Icons.star, color: Colors.orangeAccent, ),
  )));
}

oneBar(String text, double width, double selectWidth){
  width -= 20;
  return Container(
      height: 15,
    child: Stack(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: 20,
          child: Text(text),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, top: 4, bottom: 1),
          width: width,
          decoration: BoxDecoration(
            color: Color(0xffe8eaed),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, top: 4, bottom: 1),
          width: selectWidth,
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(10),
          ),
        )
      ],
    ),
  );
}

marketReviews(List<Widget> list, ResponseRestaurant _this, double windowWidth){
  if (_this == null)
    return;
  var _all = 0;
  var _count = 0;
  var _count1 = 0;
  var _count2 = 0;
  var _count3 = 0;
  var _count4 = 0;
  var _count5 = 0;
  var _maxValue = 0;
  var _total = "";
  var _totals = 0.0;
  for (var item in _this.restaurantsreviews) {
    if (item.name != "null") {
      _count++;
      _all += item.rate;
      if (item.rate == 1) _count5++;
      if (item.rate == 2) _count4++;
      if (item.rate == 3) _count3++;
      if (item.rate == 4) _count2++;
      if (item.rate == 5) _count1++;
    }
  }
  if (_count != null) {
    _totals = _all/_count;
    _total = _totals.toStringAsFixed(1);
    if (_count1 > _maxValue) _maxValue = _count1;
    if (_count2 > _maxValue) _maxValue = _count2;
    if (_count3 > _maxValue) _maxValue = _count3;
    if (_count4 > _maxValue) _maxValue = _count4;
    if (_count5 > _maxValue) _maxValue = _count5;
  }
  var star1 = 0.0;
  var star2 = 0.0;
  var star3 = 0.0;
  var star4 = 0.0;
  var star5 = 0.0;
  if (_totals > 1) {
    star1 = 1;
    if (_totals > 2) {
      star2 = 1;
      if (_totals > 3) {
        star3 = 1;
        if (_totals > 4) {
          star4 = 1;
          if (_totals > 5)
            star5 = 1;
          else star5 = _totals-4;
        }else star4 = _totals-3;
      }else star3 = _totals-2;
    }else star2 = _totals-1;
  }else star1 = _totals;

  list.add(Container(
    margin: EdgeInsets.only(left: 10, right: 10),
    child: ListWithIcon(imageAsset: "assets/reviews.png", text: strings.get(77),                                // "Reviews",
        imageColor: theme.colorDefaultText),
  ));

  if (_count != 0) {
    list.add(SizedBox(height: 20,));
    var bwidth = windowWidth * 0.7 - 20;
    var _oneItem = bwidth / _maxValue;
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        width: windowWidth - 20,
        child: Row(
          children: [
            Container(
                width: bwidth,
                child: Column(
                  children: [
                    oneBar("5", bwidth, _oneItem * _count1),
                    SizedBox(height: 10,),
                    oneBar("4", bwidth, _oneItem * _count2),
                    SizedBox(height: 10,),
                    oneBar("3", bwidth, _oneItem * _count3),
                    SizedBox(height: 10,),
                    oneBar("2", bwidth, _oneItem * _count4),
                    SizedBox(height: 10,),
                    oneBar("1", bwidth, _oneItem * _count5),
                  ],
                )
            ),
            Container(
              width: windowWidth * 0.3,
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  FittedBox(
                      child: Text(_total, style: theme.text60,)
                  ),
                  FittedBox(child: Stack(
                    children: [
                      Row(children: [
                        Icon(Icons.star, color: Color(0xffe8eaed),),
                        Icon(Icons.star, color: Color(0xffe8eaed),),
                        Icon(Icons.star, color: Color(0xffe8eaed),),
                        Icon(Icons.star, color: Color(0xffe8eaed),),
                        Icon(Icons.star, color: Color(0xffe8eaed),),
                      ],),
                      Row(children: [
                        _icon(star1),
                        _icon(star2),
                        _icon(star3),
                        _icon(star4),
                        _icon(star5),
                      ],)
                    ],
                  )),
                  Text("${strings.get(297)} : $_count")    // reviews
                ],
              ),
            )
          ],
        )));
  }
  list.add(SizedBox(height: 20,));
  for (var item in _this.restaurantsreviews) {
    if (item.name != "null") {
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ReviewsText(
          color: theme.colorPrimary,
          title: item.name,
          text: item.desc,
          date: item.updatedAt,
          userAvatar: item.image,
          rating: item.rate,
        ),
      ));
    }
  }
}
