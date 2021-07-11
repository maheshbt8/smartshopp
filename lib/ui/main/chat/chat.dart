import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/server/chatGet.dart';
import 'package:fooddelivery/model/server/chatSend.dart';
import 'package:fooddelivery/ui/login/needAuth.dart';
import 'package:fooddelivery/widget/ICard31FileCaching.dart';
import 'package:fooddelivery/widget/InputFieldArea3.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/ibackground4.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/skinRoute.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final Function(String) onBack;
  ChatScreen({Key key, this.onBack}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  bool nonext = false;
  onSendText(){
    if (editController.text.isEmpty || nonext)
      return;
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    var createdAt = formatter.format(DateTime.now());
    _this.add(ChatMessages(id: -1, text: editController.text,
        author: "customer", delivered: "false", read: "false", date: createdAt
    ));
    setState(() {
    });
    var text = editController.text;
    editController.text = "";
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent,);
    });
    print("Send text ${editController.text}");
    nonext = true;
    chatSend(account.token, text, _success, _error);
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  bool _wait = false;
  List<ChatMessages> _this = [];

  @override
  void initState() {
    if (account.isAuth())
      chatGet(account.token, _success, _error);
    account.addCallback(this.hashCode.toString(), callback);
    account.addChatCallback(callbackReload);
    super.initState();
  }

  callbackReload(){
    chatGet(account.token, _success, _error);
  }

  _error(String error){
    _waits(false);
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _waits(bool value){
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  _success(List<ChatMessages> _data) {
    _waits(false);
    nonext = false;
    _this = _data;
    account.chatCount = 0;
    account.redraw();
    setState(() {});
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent,);
    });
  }

  callback(bool reg){
    setState(() {
    });
  }

  @override
  void dispose() {
    account.addChatCallback(null);
    route.disposeLast();
    account.removeCallback(this.hashCode.toString());
    account.redraw();
    super.dispose();
  }

  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    var colorsGradient = [Color(0xff56acdd), Color(0xff48a2d6)];

    return Scaffold(
        backgroundColor: theme.colorBackground,
        body:
        Directionality(
        textDirection: strings.direction,
        child:
        Stack(
          children: <Widget>[

        if (account.isAuth())
            IBackground4(width: windowWidth, colorsGradient: colorsGradient),

        if (account.isAuth())
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                width: windowWidth,
                height: 50,
                color: theme.colorBackgroundDialog,
                child: InputFieldArea3(hint: "Message", callback: onSendText,
                controller : editController, type : TextInputType.text, colorDefaultText: theme.colorDefaultText),
              ),
            ),

        if (account.isAuth())(
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top, bottom: 50),
              child: _body(),
            ))else
              mustAuth(windowWidth, context),

            Container(
              color: theme.colorBackground.withAlpha(150),
              child: skinHeader(context, widget.onBack, ""),
            ),

            if (_wait)
              skinWait(context, false),

            IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
                body: _dialogBody, backgroundColor: theme.colorBackground),

          ],
        )
    ));
  }

  ScrollController _scrollController = new ScrollController();

  _body(){
    return Container(
      alignment: Alignment.bottomCenter,
      child: ListView(
        controller: _scrollController,
        shrinkWrap: true,
        children: _body2(),
      ),
    );
  }

  _body2(){
    List<Widget> list = [];
    var last = "";

    for (var _data in _this) {
      var now = _data.date.substring(0, 11);
      if (now != last) {
        list.add(SizedBox(height: 10,));
        list.add(Text(
            now, style: theme.text14boldWhite, textAlign: TextAlign.center),);
        list.add(SizedBox(height: 10,));
        last = now;
      }
      list.add(
          ICard31FileCaching(
              key: UniqueKey(),
              id: _data.id,
              colorLeft: theme.colorBackgroundDialog,
              colorRight: Color(0xFFcbecff),
              text: _data.text,
              textStyle: theme.text14bold,
              balloonColor: theme.colorPrimary,
              date: _data.date.substring(11,16),
              dateStyle: theme.text12bold,
              positionLeft: (_data.author == "manager"),
              delivered: (_data.delivered == "true"),
              read: (_data.read == "true")
          )
      );
    }
    list.add(SizedBox(height: 10,));
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
            text: strings.get(155),              // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: (){
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

