import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/widget/ibutton3.dart';

import 'widgets.dart';

class DeliveryDate{
  String dateArrived = "";
  bool dateArrivedInit = false;

  changeDeliveryDate(List<Widget> list, double windowWidth,
      Function(double) _redrawD, Function(Widget) setBody){
    if (dateArrived.isEmpty)
      _buildDateString(DateTime.now());
    var _time = "${strings.get(308)} $dateArrived"; // Arriving date
    list.add(SizedBox(height: 20,));
    list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: row2(_time, strings.get(220), (){openDialogDate(windowWidth, _redrawD, setBody);}) // Change >
    ));
  }

  _buildDateString(DateTime picked){
    var d = picked.day.toString();
    if (d.length == 1)
      d = "0$d";
    var m = picked.month.toString();
    if (m.length == 1)
      m = "0$m";
    dateArrived = "$d.$m";
    dprint("$dateArrived");
  }

  openDialogDate(double windowWidth, Function(double) _redrawD, Function(Widget) setBody) {
    _buildDateString(DateTime.now().add(Duration(days: 1)));
    var widget = CupertinoDatePicker(
        key: UniqueKey(),
      onDateTimeChanged: (DateTime picked) {
        _buildDateString(picked);
      },
      //use24hFormat: true,
      initialDateTime: DateTime.now().add(Duration(days: 1)),
      // minuteInterval: 10,
      // maximumDate: DateTime(2018, 12, 30, 13, 0),
      minimumDate: DateTime.now(),
     minimumYear: DateTime.now().year,
     maximumYear: DateTime.now().year,
//      minuteInterval: 1,
      mode: CupertinoDatePickerMode.date,
    );


    var _dialogBody = Column(
      children: [
        Row(
          children: [
            Container(
                width: windowWidth/2-25,
                child: IButton3(
                    color: theme.colorBackgroundGray,
                    text: strings.get(221),              // Now
                    textStyle: theme.text14,
                    pressButton: (){
                      _redrawD(0);
                    }
                )),
            SizedBox(width: 10,),
            Container(
                width: windowWidth/2-25,
                child: IButton3(
                    color: theme.colorPrimary,
                    text: strings.get(222),              // Later
                    textStyle: theme.text14boldWhite,
                    pressButton: (){
                      _redrawD(0);
                    }
                )),
          ],
        ),
        SizedBox(height: 30,),
        Container(
          width: windowWidth,
          height: 200,
          child: widget,
        ),
        SizedBox(height: 30,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(223),              // Confirm
            textStyle: theme.text14boldWhite,
            pressButton: (){
              dateArrivedInit = true;
              _redrawD(0);
              // _timeArrivedInit = true;
            }
        ),
      ],
    );

    setBody(_dialogBody);
    _redrawD(1);
  }

}