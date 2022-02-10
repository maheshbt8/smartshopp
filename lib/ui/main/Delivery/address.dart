import 'package:flutter/material.dart';

import 'package:google_maps_webservice/places.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/server/addressDelete.dart';
import 'package:shopping/model/server/addressGet.dart';
import 'package:shopping/model/server/addressSave.dart';
import 'package:shopping/ui/main/chat/iinputField2a.dart';
import 'package:shopping/ui/main/map2.dart';
import 'package:shopping/widget/ICard35FileCaching.dart';
import 'package:shopping/widget/easyDialog2.dart';
import 'package:shopping/widget/ibutton3.dart';
import 'package:shopping/widget/iinkwell.dart';
import 'package:shopping/widget/skinRoute.dart';

class AddressScreen extends StatefulWidget {
  AddressScreen({Key key, this.callback}) : super(key: key);
  final Function(String text, double lat, double lng) callback;
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  String apiError = "";
  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  _callbackAddress(String id){
    for (var _data in address) {
      _data.selected = false;
      if (_data.id == id) {
        _data.selected = true;
      }
    }
    setState(() {});
  }

  _dismissAddress(String id){
    print("Dismiss item: $id");
    deleteAddress(id, account.token, (List<AddressData> _data) {
      _waits(false);
      address = _data;
      setState(() {});
    }, _onError);
  }

  _clickAddress(){
    if (editControllerAddress.text.isEmpty)
      return openDialog(strings.get(286)); // Enter address

    var _type = "home";
    if (_checkBoxWork) _type = "work";
    if (_checkBoxOther) _type = "other";
    saveAddress(
        editControllerAddress.text, _deliveryLatitude.toString(), _deliveryLongitude.toString(), _type,
        (_checkBoxDefault) ? "true" : "false",
        account.token, (List<AddressData> _data) {
      _waits(false);
      address = _data;
      setState(() {});
    }, _onError);
  }

  _onBackClick(){
    Navigator.pop(context);
  }

  _saveVehicleInformation(){
    for (var _data in address)
        if (_data.selected){
          widget.callback(_data.text, _data.lat, _data.lng);
          Navigator.pop(context);
        }
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  final editControllerAddress = TextEditingController();
  List<AddressData> address;

  @override
  void initState() {
    places =  GoogleMapsPlaces(apiKey: appSettings.mapapikey);
    _waits(true);
    getAddress(account.token, (List<AddressData> _data) {
      _waits(false);
      address = _data;
      setState(() {});
    }, _onError);
    super.initState();
  }

  _onError(String error) {
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  callback(bool reg){
    setState(() {
    });
  }

  @override
  void dispose() {
    editControllerAddress.dispose();
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
                  margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10),
                  child: ListView(
                    padding: EdgeInsets.only(top: 0),
                    children: _getList(),
                  ),)
            ),

            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10),
                child: IInkWell(child: _iconBackWidget(), onPress: _onBackClick,)
            ),

            if (_wait)
              skinWait(context, false),

            IEasyDialog2(setPosition: (double value) {_show = value;}, getPosition: () {return _show;},
              color: theme.colorGrey, body: _dialogBody, backgroundColor: theme.colorBackground,),

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

  GoogleMapsPlaces places;

  _getList() {
    List<Widget> list = [];

    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
      child: Text(strings.get(184), style: theme.text18bold, textAlign: TextAlign.center,), // "Select Address",
    ));
    list.add(SizedBox(height: 15,));
    list.add(Container(height: 1, color: theme.colorGrey,));
    list.add(SizedBox(height: 15,));
    list.add(Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: IInputField2(hint : strings.get(48),  // "Address",
        icon : Icons.location_city,
        controller : editControllerAddress,
        type : TextInputType.text,
        colorDefaultText: theme.colorDefaultText,
        colorBackground: theme.colorBackgroundDialog,
          onChangeText: (String value) async {
            dprint("ok -s $value");
            PlacesSearchResponse response = await places.searchByText(value);
            print("placesdata : ${response.results}");
            if (response.status == "REQUEST_DENIED") {
              apiError = response.errorMessage;
              dprint("Google MAPs API REQUEST_DENIED");
              dprint(apiError);
              setState(() {
              });
            }
            if (response.results.isNotEmpty) {
              for (var item in response.results) {
                _deliveryLatitude = item.geometry.location.lat;
                _deliveryLongitude = item.geometry.location.lng;
               dprint("${item.geometry.location.lat.toString()}  ${item.geometry.location.lng.toString()}");
                setState(() {
                });
                break;
              }
            }
          }
      ),
    ));

    if (apiError != "")
      list.add(Container(
        alignment: Alignment.center,
        child: Text(apiError, style: theme.text16Red, textAlign: TextAlign.center,), // Google Map Error
      ),);

    list.add(Container(
      alignment: Alignment.center,
      child: Text("${strings.get(279)}: $_deliveryLatitude \n${strings.get(280)} $_deliveryLongitude", style: theme.text16,), // Latitude - Longitude
    ),);

    list.add(SizedBox(height: 10,));
    list.add(_checks());
    list.add(SizedBox(height: 10,));

    var _color = theme.colorPrimary;
    if (editControllerAddress.text.isEmpty)
      _color = theme.colorGrey;

    list.add(Container(
      alignment: Alignment.center,
      child: IButton3(pressButton: _clickAddress,
        text: strings.get(278),     // "Add Address",
        color: _color,
        textStyle: theme.text16boldWhite,),
    ),);

    list.add(SizedBox(height: 5,));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
        child: Row(children: [
      Expanded(child: Container(height: 0.3, color: theme.colorDefaultText.withAlpha(120),)),
      Text(strings.get(271), style: theme.text14bold),  // " or "
      Expanded(child: Container(height: 0.3, color: theme.colorDefaultText.withAlpha(120),)),
    ],)));

    list.add(SizedBox(height: 5,));
    list.add(Container(
      alignment: Alignment.center,
      child: IButton3(pressButton: _clickSelectAddressButton,
        text: strings.get(277),     // "Select Address on Map",
        color: theme.colorPrimary,
        textStyle: theme.text16boldWhite,),
    ),);

    list.add(SizedBox(height: 10,));

    list.add(SizedBox(height: 15,));
    list.add(Container(height: 1, color: theme.colorGrey,));
    list.add(SizedBox(height: 15,));

    if (address != null && address.isNotEmpty) {
      for (var _data in address) {
        var _type = strings.get(281); // home
        if (_data.type == "work")
          _type = strings.get(282); // work
        if (_data.type == "other")
          _type = strings.get(283); // Other
        list.add(Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: ICard35FileCaching(
                key: UniqueKey(),
                id: _data.id,
                color: theme.colorGrey.withOpacity(0.1),
                title: _data.text,
                type: _type,
                work: (_data.defaultAddress == "true") ? strings.get(287) : "", // default
                titleStyle: theme.text14bold,
                colorProgressBar: Colors.white,
                text: "${strings.get(279)}: ${_data.lat} ${strings.get(280)} ${_data.lng}", // Latitude - Longitude
                textStyle: theme.text14,
                balloonColor: theme.colorPrimary,
                callbackDelete: _dismissAddress,
                callback: _callbackAddress,
                selected: _data.selected,
            )
        ));
        list.add(SizedBox(height: 10,));
      }

      list.add(SizedBox(height: 30,));

      _color = theme.colorGrey;
      for (var _data in address)
        if (_data.selected)
          _color = theme.colorPrimary;
      list.add(Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: IButton3(
          color: _color,
          text: strings.get(127), // "OK",
          textStyle: theme.text14boldWhite,
          pressButton: _saveVehicleInformation,
        ),
      ));
    }else{
      list.add(Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 50),
          child:
            Text(strings.get(285), style: theme.text14bold, textAlign: TextAlign.center,),  // Addresses not found
          ));
    }

    list.add(SizedBox(height: 100,));
    return list;
  }

  String _deliveryAddress = "";
  double _deliveryLatitude = 0;
  double _deliveryLongitude = 0;

  _clickSelectAddressButton(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapInfoScreen(callback: (double lat, double lng, String addr){
              _deliveryAddress = addr;
              _deliveryLatitude = lat;
              _deliveryLongitude = lng;
              // pref.set(Pref.deliveryAddressInit, "true");
              // pref.set(Pref.deliveryAddress, _deliveryAddress);
              // pref.set(Pref.deliveryLatitude, _deliveryLatitude.toString());
              // pref.set(Pref.deliveryLongitude, _deliveryLongitude.toString());
              editControllerAddress.text = _deliveryAddress;
              editControllerAddress.selection = TextSelection.fromPosition(
                TextPosition(offset: editControllerAddress.text.length),
              );
              setState(() {
              });
            })
        ));
  }

  bool _checkBoxHome = true;
  bool _checkBoxWork = false;
  bool _checkBoxOther = false;
  bool _checkBoxDefault = true;

  _checks(){
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
            SizedBox(
            height: 30.0,
              width: 48.0,
              child: Checkbox(
                value: _checkBoxHome,
                activeColor: theme.colorPrimary,
                checkColor: theme.colorDefaultText,
                onChanged: (bool value){
                  setState(() {
                    _checkBoxHome = value;
                    if (_checkBoxHome){
                      _checkBoxWork = false;
                      _checkBoxOther = false;
                    }
                  });
                },
              )),
              Text(strings.get(281), style: theme.text14bold,), // Home
              Expanded(child: Container()),
            SizedBox(
              height: 30.0,
              width: 48.0,
              child: Checkbox(
                value: _checkBoxDefault,
                activeColor: theme.colorPrimary,
                checkColor: theme.colorDefaultText,
                onChanged: (bool value){
                  setState(() {
                    _checkBoxDefault = value;
                  });
                },
              )),
              Text(strings.get(284), style: theme.text14bold,) // Default
            ],
          ),
          Row(
            children: [
              SizedBox(
              height: 30.0,
              width: 48.0,
              child: Checkbox(
                value: _checkBoxWork,
                activeColor: theme.colorPrimary,
                checkColor: theme.colorDefaultText,
                onChanged: (bool value){
                  setState(() {
                    _checkBoxWork = value;
                    if (_checkBoxWork){
                      _checkBoxHome = false;
                      _checkBoxOther = false;
                    }
                  });
                },
              )),
              Text(strings.get(282), style: theme.text14bold,) // Work
            ],
          ),
          Container(
              child: Row(
            children: [
                SizedBox(
                height: 30.0,
                width: 48.0,
                child: Checkbox(
                value: _checkBoxOther,
                activeColor: theme.colorPrimary,
                checkColor: theme.colorDefaultText,
                onChanged: (bool value){
                  setState(() {
                    _checkBoxOther = value;
                    if (_checkBoxOther){
                      _checkBoxHome = false;
                      _checkBoxWork = false;
                    }
                  });
                },
              )),
              Text(strings.get(283), style: theme.text14bold,) // Other
            ],
          )),

        ],
      )
    );
  }

  bool _wait = true;

  _waits(bool value) {
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
    _waits(false);
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

}

