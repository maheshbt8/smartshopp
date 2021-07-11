import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IVerifySMS extends StatefulWidget {
  final Function(String) callback;
  final Color color;
  IVerifySMS({this.color = Colors.black, this.callback});

  @override
  _IVerifySMSState createState() => _IVerifySMSState();
}

class _IVerifySMSState extends State<IVerifySMS> {

  final editControllerCode = TextEditingController();
  String _textCode = "";

  @override
  void dispose() {
    editControllerCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[

        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          width: double.maxFinite,
          height: 70,
          child: CustomPaint(painter: CodePainter(textCode: _textCode, color: widget.color)),
        ),

        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 70,
          child: TextField(
            controller : editControllerCode,
            style: TextStyle(color: Colors.black, fontSize: 1),
            keyboardType: TextInputType.number,
            onChanged: (String value) async {
              if (value.length > 6)
                value = value.substring(0,6);
              setState(() {
                _textCode = value;
                if (widget.callback != null)
                  widget.callback(_textCode);
              });
            },
            cursorWidth: 0,
            maxLength: 6,
            maxLines: 1,
            inputFormatters: [
              //WhitelistingTextInputFormatter(RegExp("[0-9]")),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),


          ),
        ),


      ],
    );
  }
}



class CodePainter extends CustomPainter {
  final String textCode;
  final Color color;
  CodePainter({this.textCode, this.color = Colors.black});

  List<Offset> points = [];
  void paint(Canvas canvas, Size size) {

    var paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    var t = size.width / 13;

    // 1
    points.add(Offset(t, size.height));
    points.add(Offset(t+t, size.height));
    // 2
    points.add(Offset(t*3, size.height));
    points.add(Offset(t*3+t, size.height));
    // 3
    points.add(Offset(t*5, size.height));
    points.add(Offset(t*5+t, size.height));
    // 4
    points.add(Offset(t*7, size.height));
    points.add(Offset(t*7+t, size.height));
    // 5
    points.add(Offset(t*9, size.height));
    points.add(Offset(t*9+t, size.height));
    // 6
    points.add(Offset(t*11, size.height));
    points.add(Offset(t*11+t, size.height));

    canvas.drawLine(points[0], points[1], paint);
    canvas.drawLine(points[2], points[3], paint);
    canvas.drawLine(points[4], points[5], paint);
    canvas.drawLine(points[6], points[7], paint);
    canvas.drawLine(points[8], points[9], paint);
    canvas.drawLine(points[10], points[11], paint);

    if (textCode != null) {
      for (int i = 0; i < textCode.length; i++){
        if (i == 0) _printNumber(textCode[i], t, canvas, Offset(points[0].dx, size.height/2));
        if (i == 1) _printNumber(textCode[i], t, canvas, Offset(points[2].dx, size.height/2));
        if (i == 2) _printNumber(textCode[i], t, canvas, Offset(points[4].dx, size.height/2));
        if (i == 3) _printNumber(textCode[i], t, canvas, Offset(points[6].dx, size.height/2));
        if (i == 4) _printNumber(textCode[i], t, canvas, Offset(points[8].dx, size.height/2));
        if (i == 5) _printNumber(textCode[i], t, canvas, Offset(points[10].dx, size.height/2));
      }
    }
  }

  _printNumber(String _text, double t, var canvas, Offset x){
    TextSpan span4 = new TextSpan(style: new TextStyle(color: color, fontSize: 30), text: _text);
    final textPainter4 = TextPainter(text: span4, textDirection: TextDirection.ltr, textAlign: TextAlign.center);
    textPainter4.layout(minWidth: t, maxWidth: t);
    textPainter4.paint(canvas, x);
  }

  bool shouldRepaint(CodePainter other) => other.points != points;
}
