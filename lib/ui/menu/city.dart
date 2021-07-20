import 'package:flutter/material.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/pref.dart';
import 'package:shopping/ui/main/home/home.dart';
import 'package:shopping/widget/easyDialog2.dart';
import 'package:shopping/widget/ibutton3.dart';
import 'package:shopping/widget/skinRoute.dart';

class SelectCityScreen extends StatefulWidget {
  // final Function redraw;
  // final Function(String) onBack;
  SelectCityScreen({Key key}) : super(key: key);

  @override
  _SelectCityScreenState createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> with SingleTickerProviderStateMixin{

  double windowWidth = 0.0;
  double windowHeight = 0.0;
  String _selectedCity = "";

  @override
  void initState() {
    _selectedCity = pref.get(Pref.city);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: theme.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[
            Container(
              width: windowWidth,
              height: windowHeight,
              color: theme.colorBackgroundGray,
            ),

            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+30),
              child: _body(),
            ),

            skinHeader(context, (String str){
                Navigator.pop(context);
                account.redraw();
            }, strings.get(318)), // Select city

            IEasyDialog2(setPosition: (double value) {_show = value;}, getPosition: () {return _show;},
              color: theme.colorGrey, body: _dialogBody, backgroundColor: theme.colorBackground,),

          ],
        )
    ));
  }

  _body(){
    return ListView(
      children: _body2(),
    );
  }

  _body2(){
    List<Widget> list = [];
    list.add(Container(
      color: theme.colorBackgroundDialog,
      child: ListTile(
        leading: UnconstrainedBox(
      child: Container(
      height: 35,
          width: 35,
          child: Image.asset("assets/city.png",
              fit: BoxFit.contain, color: theme.colorDefaultText,
          ))),
        title: Text(strings.get(315), style: theme.text20bold,),  // Select your city
      ),
    ));

    list.add(SizedBox(height: 15,));

    if (homeScreen.mainWindowData != null){
      if (homeScreen.mainWindowData.settings.city.isNotEmpty){
        List<String> cities = homeScreen.mainWindowData.settings.city.split(',');
        cities.insert(0, strings.get(319)); // All cities
        for (var city in cities){
          if (city.isEmpty)
            continue;
          list.add(InkWell(
              onTap: () {
                _selectedCity = city;
                if (city == strings.get(319)) { // All cities
                  city = "";
                  pref.set(Pref.allCity, "true");
                }else{
                  pref.set(Pref.allCity, "false");
                }
                pref.set(Pref.city, city);
                setState(() {
                });
              },
              child: Container(
            color: theme.colorBackground,
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(children: [
              Expanded(child: Text(city, style: theme.text16bold,)),
              if (_selectedCity == city)
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: theme.colorPrimary,
                    shape: BoxShape.circle,
                  ),
                ),

            ],),
          )));
          list.add(SizedBox(height: 10,));
        }
      }
    }

    list.add(SizedBox(height: 50,));

    list.add(IButton3(
        color: theme.colorPrimary,
        text: strings.get(316),              // Save
        textStyle: theme.text14boldWhite,
        pressButton: (){
          if (_selectedCity.isEmpty && pref.get(Pref.allCity) != "true") {
            openDialog(strings.get(317));  // Please select your city
          }else
            account.redraw();
            Navigator.pop(context);
        }
    ));

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
}

