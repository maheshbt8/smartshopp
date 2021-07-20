import 'package:flutter/material.dart';
import 'package:shopping/main.dart';
import 'package:shopping/widget/iboxCircle.dart';


class IBottomBarSmart extends StatefulWidget {
  final Function(int) callback;
  final Color colorBackground;
  final Color colorSelect;
  final Color colorUnSelect;
  final List<IconData> icons;
  final int initialSelect;
  final Function getItem;
  IBottomBarSmart({this.colorBackground = Colors.white, this.callback, this.colorSelect = Colors.black,
    this.colorUnSelect = Colors.black, this.icons, this.initialSelect = 0, this.getItem});

  @override
  _IBottomBarSmartState createState() => _IBottomBarSmartState();
}

class _IBottomBarSmartState extends State<IBottomBarSmart> {

  var windowWidth;

  @override
  void initState() {
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

  _bottomBar(){
    double height = 60;
    double marginTop= 30;
    double width = windowWidth/5;
    double iconSize = width*0.4;
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: marginTop),
            height: height,
            width: windowWidth,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: widget.colorUnSelect.withAlpha(30))),
              color: widget.colorBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),

          _button(marginTop, width, height, iconSize, 0),
          _button(marginTop, width, height, iconSize, 1),
          _centerButton(marginTop, width, height, iconSize, 2),
          _button(marginTop, width, height, iconSize, 3),
          _button(marginTop, width, height, iconSize, 4),

        ],
      ),
    );
  }

  _centerButton(double marginTop, double width, double height, double iconSize, int index){
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: width*index),
          height: width-10,
          width: width-10,
          decoration: BoxDecoration(
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
          child: IBoxCircle(child: Icon(Icons.home , color: Colors.white, size: 30,), color: theme.colorPrimary,),
          // _icon(iconSize, index)
        ),
        Container(
          margin: EdgeInsets.only(left: width*index-10),
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

  _button(double marginTop, double width, double height, double iconSize, int index){
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: width*index, top: marginTop),
          height: height,
          width: width,
          child: _icon(iconSize, index),
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

  _icon(double size, int index){
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
    return Container(
          height: size,
          width: size,
          child: Icon(icon , color: color, size: 30,)
      );
  }
}
