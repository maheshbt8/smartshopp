import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/ui/main/productsDetails/pagin1.dart';
import 'package:fooddelivery/widget/appbar1.dart';

class ImagesBigScreen extends StatefulWidget {
  final List<Widget> list;
  const ImagesBigScreen({Key key, this.list}) : super(key: key);
  @override
  _ImagesBigScreenState createState() => _ImagesBigScreenState();
}

class _ImagesBigScreenState extends State<ImagesBigScreen> with SingleTickerProviderStateMixin{
  TabController _tabController;
  var windowWidth;
  var windowHeight;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: widget.list.length);
    _tabController.addListener(_handleTabSelection);

    super.initState();
  }

  var _tabIndex = 0;
  _handleTabSelection() {
    _tabIndex = _tabController.index;
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: initScreen(context),
    );
  }

  initScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[

            Stack (
              children: [
                TabBarView(
                    controller: _tabController,
                    children: widget.list
                )
              ],
            ),

            if (widget.list.length > 1)
              Container(
                alignment: Alignment.bottomCenter,
                child: pagination1(widget.list.length, _tabIndex, theme.colorPrimary),
                margin: EdgeInsets.only(bottom: 30),
              ),

            appbar1(Colors.transparent, Colors.white, "", context, () {Navigator.pop(context);})

          ],
        )
    );
  }

}


