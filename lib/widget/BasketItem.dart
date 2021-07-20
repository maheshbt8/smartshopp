import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/widget/cacheImageWidget.dart';

import '../main.dart';

//      14.03.2021 - skins
//      17.10.2020 - radius shadow
//      19.11

class BasketItem extends StatefulWidget {
  final Color color;
  final Color colorBorder;
  final double width;
  final double height;
  final String title1;
  final String price;
  final String image;
  final Function(String) press;
  final Function(String) delete;
  final Function(String, int) incDec;
  final Function(String) getCount;
  final String id;
  final String heroTag;
  final int count;

  BasketItem({this.color = Colors.grey, this.price = "", this.title1 = "",
    this.press, this.id, this.count = 1, this.colorBorder = Colors.white,
    this.getCount, this.delete,
    this.image, this.width = 100, this.heroTag, this.incDec, this.height = 120,
    });

  @override
  BasketItemState createState() {
    return BasketItemState();
  }
}

class BasketItemState extends State<BasketItem>{

  Widget _image = Container();
  String _heroTag = UniqueKey().toString();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (theme.appSkin == "smarter")
      return _smarter();
    if (widget.image != null)
      _image = ClipRRect(
          borderRadius: new BorderRadius.only(topLeft: Radius.circular(appSettings.radius)),
          child: Container(
              child: cacheImageWidgetCover(widget.image, theme.colorPrimary)
      ));

    if (widget.heroTag != null)
      _heroTag = widget.heroTag;

    return Container(
      child: _item2(),
    );
  }

  _item2(){
    return InkWell(
        onTap: () {
          if (widget.press != null)
            widget.press(widget.id);
        }, // needed
        child:Container(
          child: Row(
            children: <Widget>[
              UnconstrainedBox(
                  child: Container(
                      height: widget.height,
                      width: widget.width*0.30,
                      child: Hero(
                          tag: _heroTag,
                          child: _image)
                  )),

              SizedBox(width: 10,),
              Expanded(child: Container(
                  height: widget.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(child: Text(widget.title1, style: theme.text16bold, maxLines: 3,),       // title,
                           ),
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: UnconstrainedBox(
                                child: Container(
                                    height: 25,
                                    color: theme.colorPrimary.withAlpha(100),
                                    width: 25,
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
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
                                      if (widget.delete != null)
                                        widget.delete(widget.id);
                                    });
                                  }, // needed
                                )),
                          )

                            ],

                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(widget.price, style: theme.text20boldPrimary,)),    // price
                          _plusMinus(),
                          SizedBox(width: 10,)
                        ],
                      )
                    ],
                  )))
            ],
          ),
        ));
  }

  _plusMinus(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: UnconstrainedBox(
                    child: Container(
                        height: 25,
                        color: theme.colorPrimary,
                        width: 25,
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.white,
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
                          if (widget.incDec != null)
                            widget.incDec(widget.id, widget.getCount(widget.id)+1);
                        });
                      }, // needed
                    )),
              )
            ],
          ),

          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(widget.getCount(widget.id).toString(),
                textAlign: TextAlign.left,
                style: theme.text18bold
            ),
          ),

          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: UnconstrainedBox(
                    child: Container(
                        height: 25,
                        color: theme.colorPrimary,
                        width: 25,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
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
                        if (widget.getCount(widget.id) > 1) {
                          setState(() {
                            if (widget.incDec != null)
                              widget.incDec(widget.id, widget.getCount(widget.id)-1);
                          });
                        }
                      }, // needed
                    )),
              )
            ],
          ),
      ],
    );
  }

  _smarter(){
    if (widget.image != null)
      _image = ClipRRect(
          borderRadius: new BorderRadius.all(Radius.circular(appSettings.radius)),
          child: Container(
              child: cacheImageWidgetCover(widget.image, theme.colorPrimary)
          ));

    if (widget.heroTag != null)
      _heroTag = widget.heroTag;

    return InkWell(
        onTap: () {
            widget.press(widget.id);
        }, // needed
        child: Container(
          child: Row(
            children: <Widget>[
              UnconstrainedBox(
                  child: Container(
                      height: widget.height,
                      width: widget.width*0.30,
                      child: Hero(
                          tag: _heroTag,
                          child: _image)
                  )),

              SizedBox(width: 10,),
              Expanded(child: Container(
                  height: widget.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(child: Text(widget.title1, style: theme.text16bold, maxLines: 3,),       // title,
                          ),
                          Stack(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: UnconstrainedBox(
                                    child: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          color: theme.colorPrimary.withAlpha(100),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.delete_outline,
                                          color: Colors.white,
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
                                          if (widget.delete != null)
                                            widget.delete(widget.id);
                                        });
                                      }, // needed
                                    )),
                              )

                            ],

                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(widget.price, style: theme.text20boldPrimary,)),    // price
                          _plusMinusS(),
                          SizedBox(width: 10,)
                        ],
                      )
                    ],
                  )))
            ],
          ),
      ));
  }

  _plusMinusS(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: UnconstrainedBox(
                  child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: theme.colorPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.white,
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
                        if (widget.incDec != null)
                          widget.incDec(widget.id, widget.getCount(widget.id)+1);
                      });
                    }, // needed
                  )),
            )
          ],
        ),

        Container(
          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Text(widget.getCount(widget.id).toString(),
              textAlign: TextAlign.left,
              style: theme.text18bold
          ),
        ),

        Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: UnconstrainedBox(
                  child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: theme.colorPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
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
                      if (widget.getCount(widget.id) > 1) {
                        setState(() {
                          if (widget.incDec != null)
                            widget.incDec(widget.id, widget.getCount(widget.id)-1);
                        });
                      }
                    }, // needed
                  )),
            )
          ],
        ),
      ],
    );
  }
}