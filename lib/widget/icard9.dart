import 'package:flutter/material.dart';
import 'package:fooddelivery/widget/ibox.dart';

class ICard9 extends StatefulWidget {
  final Color color;
  final Color colorArrows;
  final Color colorBorder;
  @required final double width;
  final String title1;
  final TextStyle title1Style;
  final TextStyle title2Style;
  final String price;
  final TextStyle priceTitleStyle;
  final String image;
  final Function(String) press;
  final Function(String, int) incDec;
  final String id;
  final String heroTag;
  final int count;

  ICard9({this.color = Colors.grey, this.price = "", this.priceTitleStyle, this.title1 = "", this.title1Style,
    this.title2Style, this.press, this.id, this.count, this.colorArrows = Colors.black, this.colorBorder = Colors.white,
    this.image, this.width = 100, this.heroTag, this.incDec});

  @override
  _ICard9State createState() => _ICard9State();
}

class _ICard9State extends State<ICard9>{

  Widget _image = Container();
  var _title1Style = TextStyle(fontSize: 16);
  var _title2Style = TextStyle(fontSize: 16);
  var _priceTitleStyle = TextStyle(fontSize: 16);

  String _heroTag = UniqueKey().toString();
  int _count = 1;

  @override
  Widget build(BuildContext context) {

    if (widget.title1Style != null)
      _title1Style = widget.title1Style;
    if (widget.title2Style != null)
      _title2Style = widget.title2Style;
    if (widget.priceTitleStyle != null)
      _priceTitleStyle = widget.priceTitleStyle;
    if (widget.image != null)
      _image = Image.asset(widget.image,
          fit: BoxFit.cover
      );

    if (widget.heroTag != null)
      _heroTag = widget.heroTag;

    return IBox(child: _item2(),
//      width: widget.width-40,
//      height: 140,
    );
  }

  _item2(){
    return InkWell(
        onTap: () {
          if (widget.press != null)
            widget.press(widget.id);
        }, // needed
        child:Container(
          decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(color: widget.colorBorder),
            borderRadius: new BorderRadius.circular(10),
          ),
          child: Row(
            children: <Widget>[
              UnconstrainedBox(
                  child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: 120,
                      width: widget.width*0.30,
                      child: Hero(
                          tag: _heroTag,
                          child: _image)
                  )),
              Container(
                  width: widget.width*0.53,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.title1, style: _title1Style,),                          // title
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(margin: EdgeInsets.only(right: 10),
                            child: Text(widget.price, style: _priceTitleStyle,),    // price
                          )
                      ),
                      Container(
                        width: widget.width*0.55,
                        child: Stack(
                          children: <Widget>[
                            _plusMinus()

                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }

  _plusMinus(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          child: Container(
            height: 30,
            width: 100,
            child: Row(
              children: <Widget>[


                Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      //margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: UnconstrainedBox(
                          child: Container(
                              height: 25,
                              width: 25,
                              child: Icon(
                                Icons.keyboard_arrow_up,
                                color: widget.colorArrows,
                                size: 20,
                              )
                          )),
                    ),
                    Positioned.fill(
                      child: Material(
                          color: Colors.transparent,
                          shape: CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            splashColor: Colors.grey[400],
                            onTap: (){
                              setState(() {
                                _count++;
                                if (widget.incDec != null)
                                  widget.incDec(widget.id, _count);
                              });
                            }, // needed
                          )),
                    )
                  ],
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Text(_count.toString(),
                      textAlign: TextAlign.left,
                      style: _title2Style
                  ),
                ),


                Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: UnconstrainedBox(
                          child: Container(
                              height: 25,
                              width: 25,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: widget.colorArrows,
                                size: 20,
                              )
                          )),
                    ),
                    Positioned.fill(
                      child: Material(
                          color: Colors.transparent,
                          shape: CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            splashColor: Colors.grey[400],
                            onTap: (){
                              if (_count > 0) {
                                setState(() {
                                  _count--;
                                  if (widget.incDec != null)
                                    widget.incDec(widget.id, _count);
                                });
                              }
                            }, // needed
                          )),
                    )
                  ],
                ),


              ],
            ),
          ),
        ),
      ],
    );
  }
}