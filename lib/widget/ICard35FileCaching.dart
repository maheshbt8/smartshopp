import 'package:flutter/material.dart';

import '../main.dart';

class ICard35FileCaching extends StatefulWidget {
  final String id;
  final Color color;
  final String title;
  final Color colorProgressBar;
  final TextStyle titleStyle;
  final String text;
  final String type;
  final String work;
  final TextStyle textStyle;
  final Color balloonColor;
  final Function(String) callbackDelete;
  final Function(String) callback;
  final bool selected;

  ICard35FileCaching({Key key, this.id, this.color = Colors.grey, this.text = "", this.textStyle, this.title = "",
    this.titleStyle,  this.colorProgressBar = Colors.black, this.type,
    this.balloonColor = Colors.black, this.work = "", this.callback,
    this.callbackDelete, this.selected,
  }) : super(key: key);

  @override
  _ICard35FileCachingState createState() {
    return _ICard35FileCachingState();
  }
}

class _ICard35FileCachingState extends State<ICard35FileCaching>{

  var _progress = false;
  @override
  Widget build(BuildContext context) {
    var _color = widget.color;
    if (widget.selected)
      _color = theme.colorPrimary.withAlpha(120);
    return InkWell(
        splashColor: Colors.grey[400],
        onTap: (){
          widget.callback(widget.id);
    },
    child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        color: _color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Container(
            child: Row(
            children: [

              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                child: Text(widget.type, style: theme.text14boldWhite,)
              ),
              if (widget.work.isNotEmpty)
              Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(left: 20, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(widget.work, style: theme.text14boldWhite,)
              ),

              Expanded(child: Container()),

              Container(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: widget.balloonColor.withOpacity(0.2),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                        child: Stack(
                          children: [
                            Icon(Icons.delete, size: 25, color: widget.balloonColor.withOpacity(0.8)),
                            if (_progress)
                              UnconstrainedBox(child:
                              Container(
                                margin: EdgeInsets.only(top: 3, left: 3),
                                alignment: Alignment.center,
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(backgroundColor: widget.colorProgressBar, ),
                              )),
                          ],
                        ),
                      ),
                      Container(
                          width: 50,
                          height: 50,
                          child: Container(
                            alignment: Alignment.center,
                            child: Material(
                                color: Colors.transparent,
                                shape: CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  splashColor: Colors.grey[400],
                                  onTap: (){
                                    if (widget.callbackDelete != null && !_progress) {
                                      setState(() {
                                        _progress = true;
                                      });
                                      widget.callbackDelete(widget.id);
                                    }
                                  }, // needed
                                )),)
                      )
                    ],
                  )
              ),

            ],
          )),

        Text(widget.title, style: widget.titleStyle, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,),
        SizedBox(height: 5),
        Text(widget.text, style: widget.textStyle, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,),
      ],
    )));
  }
}