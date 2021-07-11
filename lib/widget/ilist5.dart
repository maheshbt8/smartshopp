import 'package:flutter/material.dart';

class IList5 extends StatefulWidget {
  final Widget icon;
  final String text;
  final TextStyle textStyle;
  final Function(bool) press;
  final Color iconColor;
  final bool initState;
  final Color activeColor;
  final Color inactiveTrackColor;
  IList5({this.text = "", this.icon, this.textStyle,
      this.press, this.iconColor = Colors.black,
      this.initState = false, this.activeColor, this.inactiveTrackColor
  });

  @override
  _IList5State createState() => _IList5State();
}

class _IList5State extends State<IList5> {

  bool _notify = false;

  @override
  void initState() {
    _notify = widget.initState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget _icon = Container();
    if (widget.icon != null)
      _icon = widget.icon;
    TextStyle _textStyle = TextStyle();
    if (widget.textStyle != null)
      _textStyle = widget.textStyle;

    return Stack(
      children: <Widget>[
        ListTile(
            leading: _icon,
            trailing: Switch(
              onChanged: (bool value){
                setState(() {
                  _notify = value;
                });
                if (widget.press != null)
                  widget.press(value);
              },
              activeColor: widget.activeColor,
              inactiveTrackColor: widget.inactiveTrackColor,
              value: _notify,
            ),
            title: Text(widget.text,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.start,
                style: _textStyle)
        ),

      ],
    );
  }

}