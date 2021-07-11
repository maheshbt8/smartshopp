import 'package:flutter/material.dart';

class InputFieldArea3 extends StatefulWidget {
  final String hint;
  final Color colorGrey;
  final TextEditingController controller;
  final TextInputType type;
  final Color colorDefaultText;
  final Color colorActivy;
  final Function() callback;
  InputFieldArea3({this.hint, this.controller, this.type, this.colorGrey, this.colorDefaultText, this.colorActivy,
    this.callback });

  @override
  _InputFieldArea3State createState() => _InputFieldArea3State();
}

class _InputFieldArea3State extends State<InputFieldArea3> {

  @override
  Widget build(BuildContext context) {
    Color _colorActivy = Colors.black;
    if (widget.colorActivy != null)
      _colorActivy = widget.colorActivy;

    Color _colorDefaultText = Colors.black;
    if (widget.colorDefaultText != null)
      _colorDefaultText = widget.colorDefaultText;
    Color _colorGrey = Color.fromARGB(255, 209, 210, 205);
    if (widget.colorGrey != null)
      _colorGrey = widget.colorGrey;

    var _sicon = IconButton(
      iconSize: 20,
      icon: Image.asset("assets/send.png",
          fit: BoxFit.contain
      ),
      onPressed: () {
        setState(() {
          if (widget.callback != null)
            widget.callback();
        });
      },
    );

    return (new Container(
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