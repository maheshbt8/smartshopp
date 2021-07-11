import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/server/getOrders.dart';
import 'package:fooddelivery/ui/main/mainscreen.dart';
import 'package:fooddelivery/widget/itemBasketText.dart';

addOrdersDetails(List<Widget> list, List<OrdersData> _data, String idOrder, double windowWidth){
  list.add(SizedBox(height: 20, ));
  double subtotal = 0;
  for (var item2 in _data)
    if (item2.orderid == idOrder) {
      if (item2.ordersdetails != null)
        for (var item in item2.ordersdetails){
          if (item.count != 0){
            list.add(Container(
              margin: EdgeInsets.only(left: 16, right: 15),
              child: Text("- ${item.food}", style: theme.text16bold),)
            );
            list.add(SizedBox(height: 6, ));
            subtotal += item.foodprice*item.count;
            list.add(Container(
              margin: EdgeInsets.only(left: 16, right: 15),
              child: Text("${basket.makePriceString(item.foodprice)} x ${item.count} = ${basket.makePriceString(item.foodprice*item.count)}",
                  style: theme.text18boldPrimary),
            ));
            list.add(SizedBox(height: 6, ));
          }else{
            list.add(Container(
              margin: EdgeInsets.only(left: 25, right: 15),
              child: Text("+ ${item.extras}", style: theme.text16Companyon),)
            );
            list.add(Container(
              margin: EdgeInsets.only(left: 35, right: 15),
              child: Text("${basket.makePriceString(item.extrasprice)} x ${item.extrascount} = ${basket.makePriceString(item.extrasprice*item.extrascount)}",
                  style: theme.text16Companyon),
            ));
          }
        }

      // tax
      var tax = item2.tax/100*subtotal;
      // fee
      var fee = item2.fee;
      if (item2.percent == '1')
        fee = item2.fee/100*subtotal;

      list.add(SizedBox(height: 20,));
      list.add(itemBasketText("${strings.get(94)}",
            "${basket.makePriceString(fee)}", false));   // "Shopping costs",
      list.add(SizedBox(height: 5,));
      list.add(itemBasketText(strings.get(95), basket.makePriceString(tax), false));  // "Taxes",
      list.add(SizedBox(height: 5,));
      list.add(itemBasketText(strings.get(96), basket.makePriceString(item2.total), true));  // "Total",
    }
}

ordersDivider(){
  var _align = Alignment.centerLeft;
  if (strings.direction == TextDirection.rtl)
    _align = Alignment.centerRight;
  return Align(
    alignment: _align,
      child: Container(
        margin: EdgeInsets.only(left: 35, right: 35, bottom: 3, top: 3),
         width: 1, color: theme.colorDefaultText,
    ),
  );
}

itemTextPastOrder(String leftText, bool _delivery){
  var _icon = Icon(Icons.check_circle, color: theme.colorPrimary, size: 30);
  if (!_delivery)
    _icon = Icon(Icons.history, color: theme.colorGrey, size: 30,);
  return Container(
    margin: EdgeInsets.only(left: 20, right: 20),
    child: Column(
      children: [
        Row(
          children: <Widget>[
            _icon,
            SizedBox(width: 20,),
            Text(leftText, style: theme.text14,),
          ],
        ),
      ],
    )
  );
}

itemOrdersDivider(String text){
  return IntrinsicHeight(child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ordersDivider(),
      Expanded(child: Container(
        height: 25,
        child: Text(text, textAlign: TextAlign.center,)))
    ],
  ));
}