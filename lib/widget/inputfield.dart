import 'package:flutter/material.dart';

class InputFieldArea extends StatefulWidget {
  final bool obscure;
  final String hint;
  final IconData icon;
  final Color colorGrey;
  final TextEditingController controller;
  final TextInputType type;
  final Color colorDefaultText;
  final Color colorActivy;
  InputFieldArea({this.obscure, this.hint, this.icon, this.controller, this.type, this.colorGrey, this.colorDefaultText, this.colorActivy });

  @override
  _InputFieldAreaState createState() => _InputFieldAreaState();
}

class _InputFieldAreaState extends State<InputFieldArea> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    var _obscure = false;
    if (widget.obscure != null)
      _obscure = widget.obscure;

    Color _colorActivy = Colors.black;
    if (widget.colorActivy != null)
      _colorActivy = widget.colorActivy;

    Color _colorDefaultText = Colors.black;
    if (widget.colorDefaultText != null)
      _colorDefaultText = widget.colorDefaultText;
    Color _colorGrey = Color.fromARGB(255, 209, 210, 205);
    if (widget.colorGrey != null)
      _colorGrey = widget.colorGrey;

    var _icon = Icons.visibility_off;
    if (!_obscureText)
      _icon = Icons.visibility;

    if (!_obscure)
      _icon = null;

    var _sicon = IconButton(
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

    var _obs = _obscureText;
    if (!_obscure)
      _obs = false;

    return (new Container(
      margin: const EdgeInsets.only(
          top: 20.0, right: 0.0, bottom: 0.0, left: 0.0),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            width: 0.5,
            color: Colors.transparent,
          ),
        ),
      ),
      child: new TextFormField(
        keyboardType: widget.type,
        controller: widget.controller,
        onChanged: (String value) async {

        },
        obscureText: _obs,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: _colorDefaultText,
        ),
        decoration: new InputDecoration(
          suffixIcon: _sicon,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _colorGrey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _colorActivy),
          ),
          icon: new Icon(widget.icon, color: _colorGrey),
          //border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: _colorDefaultText,
              fontSize: 13.0),
          contentPadding: const EdgeInsets.only(
              top: 0.0, right: 30.0, bottom: 0.0, left: 5.0),
        ),
      ),
    ));
  }
}