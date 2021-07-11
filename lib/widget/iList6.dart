import 'package:flutter/material.dart';

import '../main.dart';

class IList6 extends StatefulWidget {
  final bool initState;
  final Widget leading;
  final String title;
  final String subtitle;
  final String text;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final TextStyle textStyle;
  final String id;
  final Function(String, bool) callback;
  IList6({this.initState = true, this.leading, this.title = "", this.subtitle = "",
    this.text = "", this.textStyle, this.titleStyle, this.subtitleStyle, this.id,
    this.callback
  });

  @override
  _IList6State createState() => _IList6State();
}

class _IList6State extends State<IList6> {

  bool _select;

  @override
  void initState() {
    _select = widget.initState;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _width = 0.0;
    var _height = 0.0;
    if (_select) {
      _width = 30;
      _height = 30;
    }
    var windowWidth = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: () {
          setState(() {
            _select = !_select;
          });
          if (widget.callback != null)
            widget.callback(widget.id, _select);
        },
        child: ListTile(
            leading: widget.leading == null ? Container() : widget.leading,
            title: Text(widget.title, style: widget.titleStyle == null ? TextStyle() : widget.titleStyle),
            subtitle: (widget.subtitle.isNotEmpty) ? Text(widget.subtitle, style: widget.subtitleStyle == null ? TextStyle() : widget.subtitleStyle) : null,
            trailing: Container(
              width: windowWidth*0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AnimatedContainer(
                    width: _width,
                    height: _height,
                    duration: Duration(milliseconds: 400),
                    child: CircleAvatar(
                      backgroundColor: theme.colorBackground,
                        backgroundImage: AssetImage("assets/iconok.png"), radius: 15),
                  ),
                  Text(widget.text, style: widget.textStyle == null ? TextStyle() : widget.textStyle),
                ],
              ),
            )
        ));
  }
}
