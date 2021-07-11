import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IInputField2a extends StatefulWidget {
  final String hint;
  final IconData icon;
  final IconData iconRight;
  final Function onPressRightIcon;
  final Function(String) onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Color colorDefaultText;
  IInputField2a({this.hint, this.icon, this.controller, this.type, this.colorDefaultText,
    this.iconRight, this.onPressRightIcon, this.onChangeText});

  @override
  _IInputField2aState createState() => _IInputField2aState();
}

class _IInputField2aState extends State<IInputField2a> {

  @override
  Widget build(BuildContext context) {

    Color _colorDefaultText = Colors.black;
    if (widget.colorDefaultText != null)
      _colorDefaultText = widget.colorDefaultText;
    var _sicon = Icon(widget.icon, color: _colorDefaultText,);

    var _sicon2;
    if (widget.iconRight != null)
      _sicon2 = InkWell(
      onTap: () {
        if (widget.onPressRightIcon != null)
          widget.onPressRightIcon();
      }, // needed
      child: Icon(widget.iconRight, color: _colorDefaultText,));

    return Container(
      child: new TextFormField(
        keyboardType: widget.type,
        cursorColor: _colorDefaultText,
        controller: widget.controller,
        onChanged: (String value) async {
          if (widget.onChangeText != null)
            widget.onChangeText(value);
        },
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: _colorDefaultText,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp("[\"]")),
        ],
        decoration: new InputDecoration(
          prefixIcon: _sicon,
          suffixIcon: _sicon2,
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: _colorDefaultText,
              fontSize: 16.0),
        ),
      ),
    );
  }
}