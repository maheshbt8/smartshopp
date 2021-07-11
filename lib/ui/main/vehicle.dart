import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/iinkwell.dart';
import 'package:fooddelivery/widget/iinputField2.dart';

// ignore: must_be_immutable
class VehicleScreen extends StatefulWidget {
  VehicleScreen({Key key, this.callback}) : super(key: key);
  Function(String) callback;
  @override
  _VehicleScreenState createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {

  ///////////////////////////////////////////////////////////////////////////////
  //
  //

  _onBackClick(){
    Navigator.pop(context);
  }

  _saveVehicleInformation(){
    if (_selectVehicleId.isEmpty || _selectColorId.isEmpty )
      return;
    widget.callback("${strings.get(245)}: $_selectVehicleId, ${strings.get(246)}: "
        "$_selectColorId, ${strings.get(293)}: ${editControllerNumber.text}"); // Vehicle Type // "Vehicle Color", // Vehicle Number
    Navigator.pop(context);
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  final editControllerNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  callback(bool reg){
    setState(() {
    });
  }

  @override
  void dispose() {
    editControllerNumber.dispose();
    route.disposeLast();
    account.removeCallback(this.hashCode.toString());
    account.redraw();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: theme.colorBackground,
        body:
        Directionality(
        textDirection: strings.direction,
        child:
        Stack(
          children: <Widget>[

            Align(
                child: Container (
                  margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: ListView(
                    children: _getList(),
                  ),)
            ),

            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10),
                child: IInkWell(child: _iconBackWidget(), onPress: _onBackClick,)
            ),

          ],
        )
    ));
  }

  _iconBackWidget(){
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
      child: UnconstrainedBox(
          child: Container(
              height: 25,
              width: 25,
              child: Image.asset("assets/back.png",
                fit: BoxFit.contain, color: theme.colorDefaultText,
              )
          )),
    );
  }

  _getList() {
    List<Widget> list = [];

    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
      child: Text(strings.get(225), style: theme.text18bold, textAlign: TextAlign.center,), // "Enter Vehicle Information",
    ));
    list.add(SizedBox(height: 15,));
    list.add(Container(height: 1, color: theme.colorGrey,));
    list.add(SizedBox(height: 25,));
    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Text(strings.get(226), style: theme.text14, textAlign: TextAlign.center,), // "Help us locate your vehicle when you arrive.",
    ));
    list.add(SizedBox(height: 30,));
    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Text(strings.get(227), style: theme.text14, textAlign: TextAlign.start,), // "Select Vehicle Type:",
    ));
    list.add(SizedBox(height: 20,));
    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: _vehicles(),
    ));

    list.add(SizedBox(height: 20,));
    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: _vehicles2(),
    ));

    list.add(SizedBox(height: 30,));
    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Text(strings.get(228), style: theme.text14, textAlign: TextAlign.start,), // "Select Vehicle Color",
    ));

    list.add(SizedBox(height: 30,));
    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: _colors(),
    ));

    list.add(SizedBox(height: 30,));
    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: _colors2(),
    ));

    list.add(SizedBox(height: 30,));

    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Text("${strings.get(292)}:", style: theme.text14, textAlign: TextAlign.start,), // "Enter Vehicle Number",
    ));

    list.add(Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: IInputField2(hint : strings.get(293),                      // Vehicle Number",
        icon : Icons.chat,
        controller : editControllerNumber,
        type : TextInputType.text,
        colorDefaultText: theme.colorDefaultText,
        colorBackground: theme.colorBackgroundDialog,
      ),
    ));

    list.add(SizedBox(height: 30,));

    var _color = theme.colorPrimary;
    if (_selectVehicleId.isEmpty || _selectColorId.isEmpty )
      _color = theme.colorGrey;

    list.add(Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: IButton3(
              color: _color,
              text: strings.get(244),              // "Save Vehicle Information",
              textStyle: theme.text14boldWhite,
              pressButton: _saveVehicleInformation,
          ),
    ));
    list.add(SizedBox(height: 100,));

    return list;
  }

  _vehicles(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _oneCar("assets/suv.png", strings.get(229)), // SUV
          _oneCar("assets/sedan.png", strings.get(230)), // "Sedan",
          _oneCar("assets/coupe.png", strings.get(231)), // "Coupe",
        ],
      ),
    );
  }

  _vehicles2(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _oneCar("assets/truck.png", strings.get(232)), // "Track"
          _oneCar("assets/byke.png", strings.get(233)),  // "Bike"
          _oneCar("assets/other.png", strings.get(234)), // "Other"
        ],
      ),
    );
  }

  String _selectVehicleId = "";

  _oneCar(String image, String name){
    var _select = Colors.transparent;
    if (_selectVehicleId == name)
      _select = Colors.red;
    return InkWell(
        onTap: () {
          _selectVehicleId = name;
          setState(() {
          });
        },
        child: Container(
          width: windowWidth/3.5+10,
          padding: EdgeInsets.only(top: 5, bottom: 5),
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(10),
          border: Border.all(color: _select),
          ),
        child: UnconstrainedBox(
            child: Container(
            width: windowWidth/3.5,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black.withAlpha(130)),
              borderRadius: new BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(3, 3),
                ),
              ],
            ),
        child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Image.asset(image,
                  fit: BoxFit.contain,
                ),
                Text(name),
                SizedBox(height: 5,)
              ],
            )
        )))));
  }

  _colors(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _color(Colors.black, strings.get(235)), // Black
          _color(Colors.red, strings.get(236)), // "Red"
          _color(Colors.white, strings.get(237)), // White
          _color(Colors.grey, strings.get(238)), // Gray
          _color(Colors.grey.withAlpha(100), strings.get(239)), // Silver
        ],
      ),
    );
  }

  _colors2(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _color(Colors.green, strings.get(240)), // Green
          _color(Colors.blue, strings.get(241)), // Blue
          _color(Colors.brown, strings.get(242)), // Brown
          _color(Colors.yellow, strings.get(243)), // Gold
          _color(Colors.cyanAccent, strings.get(234)), // Other
        ],
      ),
    );
  }

  String _selectColorId = "";

  _color(Color _color, String text){
    var _select = Colors.transparent;
    if (_selectColorId == text)
      _select = Colors.red;
    return InkWell(
        onTap: () {
          _selectColorId = text;
          setState(() {
          });
    },
    child: Column(
      children: [
        Container(
          width: windowWidth/7+10,
          height: windowWidth/7+10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _select),
          ),
          child: UnconstrainedBox(
            child: Container(
            width: windowWidth/7,
            height: windowWidth/7,
            decoration: BoxDecoration(
              color: _color,
              border: Border.all(color: Colors.black.withAlpha(130)),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(3, 3),
                ),
              ],
            ),
          ),
        )),
        SizedBox(height: 5,),
        Text(text)
      ],
    ));
  }
}

