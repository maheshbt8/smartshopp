import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping/model/server/mainwindowdata.dart';

// v2.0 18.10.2020

class IPromotion extends StatefulWidget {
  final List<Restaurants> dataPromotion;
  final double width;
//  final Color colorBackground;
  final Color colorProgressBar;
  final double height;
  final Color colorGrey;
  final Color colorActivy;
  final TextStyle style;
  final double radius;
  final int shadow;
  final Function(String id, String heroId, String image) callback;
  final int seconds;
  IPromotion(this.dataPromotion, {this.width = 100, this.height = 100, this.colorGrey, this.colorActivy, this.style,
    this.callback, this.seconds, this.colorProgressBar = Colors.black,
    this.radius, this.shadow});

  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<IPromotion> {

  int realCountPaget = 0;
  var t = 0;
  var _currentPage = 1000;
  Color _colorActivy = Colors.black;
  Color _colorGrey = Color.fromARGB(255, 180, 180, 180);
  var _seconds = 3;

  Timer _timer;
  void startTimer() {
    _timer = new Timer.periodic(Duration(seconds: _seconds),
          (Timer timer) {
              int _page = _currentPage+1;
              _controller.animateToPage(_page, duration: Duration(seconds: 1), curve: Curves.ease);
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.seconds != null)
      _seconds = widget.seconds;
    realCountPaget = widget.dataPromotion.length;
    startTimer();
    super.initState();
  }

  _getT(int itemIndex){
    if (widget.dataPromotion.length == 0)
      return;
    if (itemIndex > 1000){
      t = itemIndex-1000;
      while(t >= realCountPaget){
        t -= realCountPaget;
      }
    }
    if (itemIndex < 1000){
      t = 1000-itemIndex;
      var r = realCountPaget;
      do{
        if (r == 0)
          r = realCountPaget;
        r--;
        t--;
      }while(t > 0);
      t = r;
    }
  }

  var _controller = PageController(initialPage: 1000, keepPage: false, viewportFraction: 1);

  _promotion(){
    return Stack(
      children: <Widget>[
        Container(height: widget.height,
          child: PageView.builder(
            itemCount: 10000,
            onPageChanged: (int page){
              _getT(page);
              setState(() {
              });
              _currentPage = page;
            },
            controller: _controller,
            itemBuilder: (BuildContext context, int itemIndex) {
              _getT(itemIndex);
              if (t < 0 || t > realCountPaget || widget.dataPromotion.length == 0)
                return Container();
              if (t > widget.dataPromotion.length-1)
                return Container();
              var item = widget.dataPromotion[t];
              return Container(
                decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(widget.radius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(widget.shadow),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(2, 2), // changes position of shadow
                      ),
                    ]
                ),
                margin: EdgeInsets.all(10),
                width: widget.width, height: widget.height,
                child: _sale2(item, t),
              );
            },
          ),
        ),


        Container(
            height: widget.height,
            child:Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    margin: EdgeInsets.only(bottom: 25, right: 25),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _lines(),
                    )
                )
            )),
      ],
    );
  }

  _sale2(Restaurants item, int index){
    var _id = UniqueKey().toString();

    return InkWell(
        onTap: () {
      if (widget.callback != null)
        widget.callback(item.id, _id, item.image);
    }, // needed
    child: Stack(
      children: <Widget>[
        Container(
          width: widget.width,
          height: widget.height,
          child:
          Hero(
              tag: _id,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                child:Container(
                child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        UnconstrainedBox(child:
                        Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(),
                        )),
                    imageUrl: item.image,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context,url,error) => new Icon(Icons.error),
                  ),
                ),
              )
          )
        ),

        ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(widget.radius), topRight: Radius.circular(widget.radius)),
            child:Container(
                height: 20,
                color: Colors.black.withAlpha(140),
                width: widget.width,
                child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text(item.name, textAlign: TextAlign.start, style: widget.style,)
                )
            )),

    ],
    ));
  }

  _lines(){
    List<Widget> lines = [];
    for (int i = 0; i < realCountPaget; i++){
      if (i == t)
        lines.add(Container(width: 15, height: 3,
          decoration: BoxDecoration(
            color: _colorActivy,
            border: Border.all(color: _colorActivy),
            borderRadius: new BorderRadius.circular(10),
          ),
        ));
      else
        lines.add(Container(width: 15, height: 3,
          decoration: BoxDecoration(
            color: _colorGrey,
            border: Border.all(color: _colorGrey),
            borderRadius: new BorderRadius.circular(10),
          ),
        ));
      lines.add(SizedBox(width: 5,),);
    }

    return lines;
  }

  @override
  Widget build(BuildContext context) {

    if (widget.colorActivy != null)
      _colorActivy = widget.colorActivy;

    if (widget.colorGrey != null)
      _colorGrey = widget.colorGrey;

    return _promotion();
  }
}