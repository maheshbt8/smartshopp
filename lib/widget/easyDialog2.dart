import 'package:flutter/material.dart';

//
// v 1.0 - 29/09/2020
// v 1.2 - 01/10/2020
//

class IEasyDialog2 extends StatefulWidget {
  final Color color;
  final Color backgroundColor;
  final Function(double) setPosition;
  final Function getPosition;
  final Widget body;

  IEasyDialog2({this.color = Colors.black, this.setPosition, this.getPosition, this.body,
    this.backgroundColor,
  });

  @override
  _IEasyDialog2State createState() {
    return _IEasyDialog2State();
  }
}

class _IEasyDialog2State extends State<IEasyDialog2>{

  DragUpdateDetails _detailsStart;
  DragUpdateDetails _detailsEnd;

  final ValueNotifier<double> _rowHeight = ValueNotifier<double>(-1);
  double height = 0;

  @override
  void initState(){
    _needRedraw = true;
    super.initState();
  }

  final GlobalKey _rowKey = GlobalKey();
  bool _needRedraw = true;
  Widget _lastBody;

  @override
  Widget build(BuildContext context) {
    if (widget.getPosition() == 1){
      _needRedraw = true;
      height = 0;
    }
    if (_lastBody != widget.body) {
      _lastBody = widget.body;
      Future.delayed(Duration.zero, () =>
      {
        if (_rowKey.currentContext != null){
          _needRedraw = true,
          _rowHeight.value = _rowKey.currentContext.size.height,
        }
      });
    }

    double windowWidth = MediaQuery
        .of(context)
        .size
        .width;
    double windowHeight = MediaQuery
        .of(context)
        .size
        .height;
    return WillPopScope(
        onWillPop: () async {
          if (widget.getPosition() != 0){
            setState(() {
              widget.setPosition(0);
            });
            return false;
          }
          return true;
        },
        child: Stack(
          children: [

            if (widget.getPosition() != 0)
              Container(
                width: windowWidth,
                height: windowHeight,
                color: Colors.black.withOpacity(0.5),
              ),

            ValueListenableBuilder<double>(
                valueListenable: _rowHeight,
                builder: (BuildContext context, double h, Widget child) {
                  if (_needRedraw && _rowHeight.value != -1) {
                    if (widget.getPosition() != 0) {
                      widget.setPosition(_rowHeight.value + 100);
                      height = _rowHeight.value + 100;
                      _needRedraw = false;
                      Future.delayed(const Duration(milliseconds: 100), () {
                        setState(() {});
                      });
                    }
                  }

                  return Container();
                }),

            AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                height: widget.getPosition(),
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  width: windowWidth,
                  child: Container(
                      child: ListView(
                        padding: EdgeInsets.only(top: 0),
                        children: <Widget>[
                          GestureDetector(
                              onVerticalDragStart: (DragStartDetails details) {
                                setState(() {
                                  widget.setPosition(-(details.localPosition.dy - height));
                                });
                              },
                              onVerticalDragUpdate: (DragUpdateDetails details) {
                                _detailsStart = _detailsEnd;
                                _detailsEnd = details;
                                widget.setPosition(-(details.localPosition.dy - height));
                                setState(() {});
                              },
                              onVerticalDragEnd: (DragEndDetails details) {
                                var pos = 0.0;
                                if (_detailsStart != null)
                                  if (_detailsStart.localPosition != null)
                                    if (_detailsStart.localPosition.dy > _detailsEnd?.localPosition?.dy)
                                      pos = height;
                                widget.setPosition(pos);
                                setState(() {});
                                if (pos == 0)
                                  Future.delayed(const Duration(milliseconds: 100), (){
                                    _needRedraw = true;
                                    height = 0;
                                  });
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: 40,
                                    width: windowWidth,
                                    decoration: BoxDecoration(
                                      color: widget.color,
                                      borderRadius: new BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    margin : EdgeInsets.only( top: 2),
                                    width: windowWidth,
                                    decoration: BoxDecoration(
                                      color: widget.backgroundColor,
                                      borderRadius: new BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 7),
                                        width: 100,
                                        child: Column(
                                          children: [
                                            Container(height: 2, color: widget.color,),
                                            SizedBox(height: 2,),
                                            Container(height: 2, color: widget.color,),
                                            SizedBox(height: 2,),
                                            Container(height: 2, color: widget.color,),
                                          ],
                                        ),
                                      )),
                                ],

                              )),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              key: _rowKey,
                              child: widget.body,
                            ),
                          )

                        ],
                      )
                  ),
                )
            )

          ],
        ));
  }
}