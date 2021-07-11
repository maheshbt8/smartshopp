// import 'package:flutter/material.dart';
// import 'package:fooddelivery/main.dart';
//
// import 'cacheImageWidget.dart';
//
// //
// // v2.0 08.10.2020
// //      17.10.2020 - radius shadow
// //
//
// class ICard14FileCaching extends StatefulWidget {
//   final Color color;
//   final double width;
//   final double height;
//   final String image;
//   final String id;
//   final Color colorProgressBar;
//   final Function(String id, String hero) callback;
//   final String text;
//   final TextStyle textStyle;
//   final String text2;
//   final TextStyle textStyle2;
//   final String text3;
//   final TextStyle textStyle3;
//   final String text4;
//   final TextStyle textStyle4;
//   final String text5;
//   final TextStyle textStyle5;
//   final String text6;
//   final TextStyle textStyle6;
//   final String heroId;
//   final double radius;
//   final int shadow;
//
//   ICard14FileCaching({this.color = Colors.white, this.width = 100, this.height = 100,
//     this.id = "", this.callback, this.image = "",
//     this.text = "",this.textStyle,
//     this.text2 = "", this.textStyle2,
//     this.text3 = "", this.textStyle3,
//     this.text4 = "", this.textStyle4,
//     this.text5 = "", this.textStyle5,
//     this.text6 = "", this.textStyle6,
//     this.heroId, this.colorProgressBar,
//     this.radius = 15, this.shadow = 10
//   });
//
//   @override
//   _ICard14FileCachingState createState() => _ICard14FileCachingState();
// }
//
// class _ICard14FileCachingState extends State<ICard14FileCaching>{
//
//   var _textStyle = TextStyle(fontSize: 16);
//   var _textStyle2 = TextStyle(fontSize: 16);
//   var _textStyle3 = TextStyle(fontSize: 16);
//   var _textStyle4 = TextStyle(fontSize: 16);
//   var _textStyle5 = TextStyle(fontSize: 16);
//   var _textStyle6 = TextStyle(fontSize: 16);
//
//   @override
//   Widget build(BuildContext context) {
//     var _id = widget.heroId == null ? UniqueKey().toString() : widget.heroId;
//     if (widget.textStyle != null)
//       _textStyle = widget.textStyle;
//     if (widget.textStyle2 != null)
//       _textStyle2 = widget.textStyle2;
//     if (widget.textStyle3 != null)
//       _textStyle3 = widget.textStyle3;
//     if (widget.textStyle4 != null)
//       _textStyle4 = widget.textStyle4;
//     if (widget.textStyle5 != null)
//       _textStyle5 = widget.textStyle5;
//     if (widget.textStyle6 != null)
//       _textStyle6 = widget.textStyle6;
//
//     return InkWell(
//         onTap: () {
//       if (widget.callback != null)
//         widget.callback(widget.id, _id);
//     }, // needed
//     child: Container(
//           width: widget.width-10,
//           height: widget.height-20,
//           decoration: BoxDecoration(
//               color: widget.color,
//               borderRadius: new BorderRadius.circular(widget.radius),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withAlpha(widget.shadow),
//                   spreadRadius: 2,
//                   blurRadius: 2,
//                   offset: Offset(2, 2), // changes position of shadow
//                 ),
//               ]
//           ),
//           child: Row(
//             children: <Widget>[
//             Hero(
//             tag: _id,
//             child: Container(
//                 width: widget.width*0.3,
//                 height: widget.height,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.only(topLeft: Radius.circular(widget.radius), bottomLeft: Radius.circular(widget.radius)),
//                       child: cacheImageWidgetCover(widget.image, theme.colorPrimary)
//                   ),
//                 )
//               ),
//         SizedBox(width: 10,),
//         InkWell(
//                 onTap: () {
//                   if (widget.callback != null)
//                     widget.callback(widget.id, _id);
//                 }, // needed
//                 child: Container(
//                   width: widget.width*0.6,
//                   height: widget.height,
//                   //margin: EdgeInsets.only(top: 5, left: widget.width*0.3+5),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     mainAxisSize: MainAxisSize.max,
//                     children: <Widget>[
//                       SizedBox(height: 5,),
//                       Row(children: [
//                         Expanded(child: Text(widget.text, style: _textStyle, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)),  // name
//                         Text(widget.text5, style: _textStyle5, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)
//                       ],),
//                       Text(widget.text2, style: _textStyle2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,),
//                       Text(widget.text3, style: _textStyle3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,),
//                       Row(children: [
//                         Expanded(child: Text(widget.text6, style: _textStyle6, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)),  // name
//                         Text(widget.text4, style: _textStyle4, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,),
//                       ],),
//                       SizedBox(height: 5,)
//                     ],
//                   ),
//                   )),
//
//             ],
//           ),
//     ));
//   }
// }