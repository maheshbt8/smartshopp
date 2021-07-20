
import 'package:flutter/material.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/server/faq.dart';
import 'package:shopping/widget/ibackground4.dart';
import 'package:shopping/widget/icard7.dart';
import 'package:shopping/widget/skinRoute.dart';

class HelpScreen extends StatefulWidget {
  final Function(String) onBack;
  HelpScreen({Key key, this.onBack}) : super(key: key);
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

Faq faq = Faq();
List<Data> _faqList;

class _HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin{

  var windowWidth;
  var windowHeight;

  error(String error){
    _waits(false);
    dprint(error);
  }

  faqLoad(List<Data> _data){
    _faqList = _data;
    _waits(false);
  }

  bool _wait = false;

  _waits(bool value){
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  @override
  void initState() {
    if (_faqList != null)
      faqLoad(_faqList);
    else {
      _waits(true);
      faq.get(faqLoad, error);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                  height: 45+MediaQuery.of(context).padding.top,
                  child: IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient)
              ),

              skinHeader(context, widget.onBack, ""),

              Container(
                margin: EdgeInsets.only(top: 45+MediaQuery.of(context).padding.top),
                child: ListView(
                  children: _getList(),
                ),
              ),

              if (_wait)
                skinWait(context, false),

            ],
          ),
        ));
  }


  List<Widget> _getList(){
    List<Widget> list = [];

    list.add(Row(
      children: <Widget>[
        SizedBox(width: 20,),
        Icon(Icons.help_outline),
        SizedBox(width: 10,),
        Text(strings.get(51), style: theme.text20bold),   // "Help & support",
      ],
    ));

    list.add(SizedBox(height: 25,));
    if (_faqList != null)
      for (var item in _faqList)
        list.add(_item(item.question, item.answer));

    list.add(SizedBox(height: 200,));
    return list;
  }

  _item(String _title, String _body){
    return ICard7(
      color: theme.colorPrimary,
      title: _title, titleStyle: theme.text14,
      body: _body, bodyStyle: theme.text14,
    );
  }

}
