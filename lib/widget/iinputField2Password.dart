import 'package:flutter/material.dart';

class IInputField2Password extends StatefulWidget {
  final String hint;
  final IconData icon;
  final Function(String) onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Color colorDefaultText;
  final Color colorBackground;
  IInputField2Password({this.hint, this.icon, this.controller, this.type, this.colorDefaultText, this.colorBackground,
    this.onChangeText});

  @override
  _IInputField2PasswordState createState() => _IInputField2PasswordState();
}

class _IInputField2PasswordState extends State<IInputField2Password> {

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {

    Color _colorBackground = Colors.white;
    if (widget.colorBackground != null)
      _colorBackground = widget.colorBackground;
    Color _colorDefaultText = Colors.black;
    if (widget.colorDefaultText != null)
      _colorDefaultText = widget.colorDefaultText;
    var _sicon = Icon(widget.icon, color: _colorDefaultText,);

    var _icon = Icons.visibility_off;
    if (!_obscureText)
      _icon = Icons.visibility;

    var _sicon2 = IconButton(
      iconSize: 20,
      icon: Icon(
        _icon, //_icon,
        color: _colorDefaultText,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );

    return Container(
      decoration: BoxDecoration(
        color: _colorBackground,
        border: Border.all(color: Colors.grey[200]),
        borderRadius: new BorderRadius.circular(20),
      ),
      child: new TextFormField(
        obscureText: _obscureText,
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