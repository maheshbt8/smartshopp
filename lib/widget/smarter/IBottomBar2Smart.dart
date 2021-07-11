import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';

class IBottomBar2Smart extends StatefulWidget {
  final Function(int) callback;
  final Color colorBackground;
  final Color colorSelect;
  final Color colorUnSelect;
  final List<IconData> icons;
  final int initialSelect;
  final double radius;
  final Function getItem;
  final int shadow;
  IBottomBar2Smart({this.colorBackground = Colors.white, this.callback, this.colorSelect = Colors.black,
    this.colorUnSelect = Colors.black, this.icons, this.initialSelect = 0, this.getItem, this.radius,
  this.shadow});

  @override
  _IBottomBar2SmartState createState() => _IBottomBar2SmartState();
}

class _IBottomBar2SmartState extends State<IBottomBar2Smart> {

  var windowWidth;
  int _size = 4;

  @override
  void initState() {
    _size = widget.icons.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: windowWidth,
          height: 90,
          child: _bottomBar(),
        ));
  }

  double height = 60;
  double marginTop = 30;

  _bottomBar(){
    return Container(
      child: Stack(
        children: _childs(),
      ),
    );
  }

  _childs(){
    double width = windowWidth/_size;
    double iconSize = width*0.4;
    List<Widget> list = [];
    list.add(_background());
    var index = 0;
    for (var _ in widget.icons) {
      list.add(_button(marginTop, width, height, iconSize, index));
      index++;
    }
    return list;
  }

  _background(){
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      height: height,
      width: windowWidth,
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.only(topLeft: Radius.circular(widget.radius), topRight: Radius.circular(widget.radius)),
        color: widget.colorBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(widget.shadow),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
    );
  }

  _button(double marginTop, double width, double height, double iconSize, int index){
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: width*index, top: marginTop),
          height: height,
          width: width,
          child: _icon(iconSize, index, width),
        ),
        Container(
          margin: EdgeInsets.only(left: width*index, top: marginTop),
          height: height,
          width: width,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  if (widget.getItem() != index) {
                    if (widget.callback != null)
                      widget.callback(index);
                    setState(() {
                      //_select = index;
                    });
                  }
                }, // needed
              )),
        )
      ],
    );
  }

  _icon(double size, int index, double width){
    Color color = widget.colorSelect;
    if (widget.icons == null)
      return;
    if (widget.icons.length-1 < index)
      return;
    IconData icon = widget.icons[index];
    if (index != widget.getItem()) {
      color = widget.colorUnSelect;
      size = size * 0.8;
    }
    if (index == 2){
      return UnconstrainedBox(
          child: Container(
              decoration: BoxDecoration(
                  color: theme.colorPrimary,
                  borderRadius: new BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorPrimary.withAlpha(80),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ]
              ),
              height: size*1.5,
              width: size*1.5,
              child: Icon(icon, color: Colors.white, size: 30,)
          ));
    }
    else
      return UnconstrainedBox(
          child: Container(
              height: size,
              width: size,
              child: Icon(icon , color: color, size: 30,)
          ));
  }
}
