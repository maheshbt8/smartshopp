import 'package:flutter/material.dart';

//
// 02.10.2020 rtl
// 11.10.2020 radius and shadow
//

class ISearch extends StatefulWidget {
  final String hint;
  final IconData icon;
  final IconData iconRight;
  final Function onPressRightIcon;
  final Function(String) onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final TextDirection direction;
  final Color colorDefaultText;
  final Color colorBackground;
  final double radius;
  final int shadow;

  ISearch({this.hint, this.icon, this.controller, this.type, this.colorDefaultText, this.colorBackground,
    this.iconRight, this.onPressRightIcon, this.onChangeText, this.direction,
    this.radius, this.shadow,
  });

  @override
  _ISearchState createState() => _ISearchState();
}

class _ISearchState extends State<ISearch> {

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
        border: Border.all(color: Colors.black.withAlpha(100)),
        borderRadius: new BorderRadius.circular(widget.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(widget.shadow),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(3, 3), // changes position of shadow
          ),
        ],
      ),
      child:  Directionality(
        textDirection: widget.direction,
      child: TextFormField(
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

      ),
      );
  }
}