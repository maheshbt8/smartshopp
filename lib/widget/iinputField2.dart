import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IInputField2 extends StatefulWidget {
  final String hint;
  final IconData icon;
  final IconData iconRight;
  final Function onPressRightIcon;
  final Function(String) onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Color colorDefaultText;
  final int maxLenght;
  final Color colorBackground;
  IInputField2({this.hint, this.icon, this.controller, this.type, this.colorDefaultText, this.colorBackground,
    this.iconRight, this.onPressRightIcon, this.onChangeText, this.maxLenght});

  @override
  _IInputField2State createState() => _IInputField2State();
}

class _IInputField2State extends State<IInputField2> {

  @override
  Widget build(BuildContext context) {

    Color _colorBackground = Colors.white;
    if (widget.colorBackground != null)
      _colorBackground = widget.colorBackground;
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
      decoration: BoxDecoration(
        color: _colorBackground,
        border: Border.all(color: Colors.grey[200]),
        borderRadius: new BorderRadius.circular(5),
      ),
      child: new TextFormField(
        maxLength: widget.maxLenght,
        maxLines: 1,
        keyboardType: widget.type,
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
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: _colorDefaultText,
              fontSize: 16.0),
        ),
      ),
    );
  }
}