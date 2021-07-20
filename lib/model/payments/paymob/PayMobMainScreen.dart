import 'dart:core';
import 'package:shopping/widget/easyDialog2.dart';
import 'package:shopping/widget/ibutton3.dart';
import '../../../main.dart';
import 'package:flutter/material.dart';
import '../../homescreenModel.dart';
import 'PayMobPayment.dart';

class PayMobMainScreen extends StatefulWidget {
  final Function onFinish;
  final String userFirstName;
  final String userEmail;
  final String payAmount;
  final String userPhone;
  final String apiKey;
  final String frame;
  final String integrationId;

  PayMobMainScreen({this.onFinish, this.userFirstName, this.userEmail, this.payAmount,
        this.apiKey, this.frame, this.integrationId, this.userPhone});

  @override
  State<StatefulWidget> createState() {
    return PayMobMainScreenState();
  }
}

class PayMobMainScreenState extends State<PayMobMainScreen> {

  var windowWidth;
  var windowHeight;
  final editControllerCity = TextEditingController();
  final editControllerCountry = TextEditingController();
  final editControllerPostalCode = TextEditingController();
  final editControllerState = TextEditingController();
  final editControllerFirstName = TextEditingController();
  final editControllerLastName = TextEditingController();
  final editControllerEmail = TextEditingController();
  final editControllerPhone = TextEditingController();
  final editControllerStreet = TextEditingController();
  final editControllerBuilding = TextEditingController();
  final editControllerFloor = TextEditingController();
  final editControllerApartment = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    editControllerCity.dispose();
    editControllerCountry.dispose();
    editControllerPostalCode.dispose();
    editControllerState.dispose();
    editControllerFirstName.dispose();
    editControllerLastName.dispose();
    editControllerEmail.dispose();
    editControllerPhone.dispose();
    editControllerStreet.dispose();
    editControllerBuilding.dispose();
    editControllerFloor.dispose();
    editControllerApartment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: appBar("PayMob"),
        body: Stack(
          children: <Widget>[

            Container (
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: ListView(
                padding: EdgeInsets.only(top: 0),
                children: _getList(),
              ),),

            IEasyDialog2(setPosition: (double value) {_show = value;}, getPosition: () {return _show;},
              color: theme.colorGrey, body: _dialogBody, backgroundColor: theme.colorBackground,),

          ],
        )
    );
  }

  Widget appBar(title) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=> Navigator.pop(context)),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18.0,
            color: theme.colorDefaultText,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  _getList() {
    List<Widget> list = [];

    list.add(Container(
      alignment: Alignment.center,
      child: Text("Provide the following information for payment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,))
    );

    list.add(SizedBox(height: 20,));

    // editControllerCountry.text = "Egypt";
    list.add(Text("Country",));
    list.add(IInputField2(hint : "Enter country",
      controller : editControllerCountry,
      type : TextInputType.text,
    ));

    list.add(Text("Postal code",));
    list.add(IInputField2(hint : "Enter Postal code",
      controller : editControllerPostalCode,
      type : TextInputType.number,
    ));

    list.add(Text("State",));
    list.add(IInputField2(hint : "Enter State",
      controller : editControllerState,
      type : TextInputType.text,
    ));

    list.add(Text("City",));
    list.add(IInputField2(hint : "Enter city",
        controller : editControllerCity,
        type : TextInputType.text,
    ));

    list.add(Text("Street",));
    list.add(IInputField2(hint : "Enter Street",
      controller : editControllerStreet,
      type : TextInputType.text,
    ));

    list.add(Text("Building",));
    list.add(IInputField2(hint : "Enter building",
      controller : editControllerBuilding,
      type : TextInputType.text,
    ));

    list.add(Text("Floor",));
    list.add(IInputField2(hint : "Enter floor",
      controller : editControllerFloor,
      type : TextInputType.number,
    ));

    list.add(Text("Apartment",));
    list.add(IInputField2(hint : "Enter apartment",
      controller : editControllerApartment,
      type : TextInputType.text,
    ));

    list.add(Text("First Name",));
    list.add(IInputField2(hint : "Enter First Name",
      controller : editControllerFirstName,
      type : TextInputType.text,
    ));

    list.add(Text("Last Name",));
    list.add(IInputField2(hint : "Enter Last Name",
      controller : editControllerLastName,
      type : TextInputType.text,
    ));

    list.add(Text("Email",));
    list.add(IInputField2(hint : "Enter email",
      controller : editControllerEmail,
      type : TextInputType.text,
    ));

    list.add(Text("Phone",));
    list.add(IInputField2(hint : "Enter phone",
      controller : editControllerPhone,
      type : TextInputType.text,
    ));

    list.add(SizedBox(height: 20,));

    list.add(Container(
      alignment: Alignment.center,
      child: IButton3(pressButton: _next,
        text: "Next",
        color: theme.colorPrimary,
        textStyle: theme.text16boldWhite,),
    ),);

    list.add(SizedBox(height: 100,));

    return list;
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
    _dialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155), // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: () {
              setState(() {
                _show = 0;
              });
            }
        ),
      ],
    );

    setState(() {
      _show = 1;
    });
  }

  _next(){
    if (editControllerCountry.text.isEmpty)
      return openDialog("Need enter country");
    if (editControllerPostalCode.text.isEmpty)
      return openDialog("Need enter postal code");
    if (editControllerState.text.isEmpty)
      return openDialog("Need enter State");
    if (editControllerCity.text.isEmpty)
      return openDialog("Need enter City");
    if (editControllerStreet.text.isEmpty)
      return openDialog("Need enter Street");
    if (editControllerBuilding.text.isEmpty)
      return openDialog("Need enter Building");
    if (editControllerFloor.text.isEmpty)
      return openDialog("Need enter Floor");
    if (editControllerApartment.text.isEmpty)
      return openDialog("Need enter Apartment");
    if (editControllerFirstName.text.isEmpty)
      return openDialog("Need enter First Name");
    if (editControllerLastName.text.isEmpty)
      return openDialog("Need enter Last Name");
    if (editControllerEmail.text.isEmpty)
      return openDialog("Need enter Email");
    if (editControllerPhone.text.isEmpty)
      return openDialog("Need enter Phone");
    //
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayMobPayment(
            userFirstName: account.userName,
            userEmail: account.email,
            userPhone: account.phone,
            payAmount: widget.payAmount,
            apiKey: widget.apiKey,
            frame: widget.frame,
            integrationId: widget.integrationId,
            //
            country: editControllerCountry.text,
            postalCode: editControllerPostalCode.text,
            state: editControllerState.text,
            city: editControllerCity.text,
            street: editControllerStreet.text,
            building: editControllerBuilding.text,
            floor: editControllerFloor.text,
            apartment: editControllerApartment.text,
            firstName: editControllerFirstName.text,
            lastName: editControllerLastName.text,
            email: editControllerEmail.text,
            phoneNumber: editControllerPhone.text,
            //
            onFinish: (w){
              widget.onFinish(w);
            }
        ),
      ),
    );
  }

}

/*

"country": "Egypt",
"postal_code": "2",
"state": "2"
"city": "1",

"street": "2",
"building": "2",
"floor": "1",
"apartment": "1",

"first_name": userFirstName,
"last_name": "2",
"email": email,
"phone_number": "$phone",

?????? "shipping_method": "2",
 */

class IInputField2 extends StatefulWidget {
  final String hint;
  final IconData icon;
  final IconData iconRight;
  final Function onPressRightIcon;
  final Function(String) onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final int maxLenght;
  IInputField2({this.hint, this.icon, this.controller, this.type,
    this.iconRight, this.onPressRightIcon, this.onChangeText, this.maxLenght});

  @override
  _IInputField2State createState() => _IInputField2State();
}

class _IInputField2State extends State<IInputField2> {

  @override
  Widget build(BuildContext context) {

    Color _colorDefaultText = theme.colorDefaultText;
    Widget _sicon = Icon(widget.icon, color: _colorDefaultText,);
    if (widget.icon == null)
      _sicon = null;

    var _sicon2;
    if (widget.iconRight != null)
      _sicon2 = InkWell(
          onTap: () {
            if (widget.onPressRightIcon != null)
              widget.onPressRightIcon();
          }, // needed
          child: Icon(widget.iconRight, color: _colorDefaultText,));

    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        margin: EdgeInsets.only(bottom: 10,),
    decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(appSettings.radius),
    ),
    child: Container(
      child: new TextFormField(
        keyboardType: widget.type,
        cursorColor: _colorDefaultText,
        controller: widget.controller,
        onChanged: (String value) async {
          if (widget.onChangeText != null)
            widget.onChangeText(value);
        },
        textAlignVertical: TextAlignVertical.center,
        maxLines: 1,
        maxLength: widget.maxLenght,
        style: TextStyle(
          color: _colorDefaultText,
        ),
        decoration: new InputDecoration(
          prefixIcon: _sicon,
          suffixIcon: _sicon2,
          counterText: "",
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: _colorDefaultText,
              fontSize: 16.0),
        ),
      ),
    ));
  }
}