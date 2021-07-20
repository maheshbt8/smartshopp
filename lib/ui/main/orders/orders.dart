import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping/config/api.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/server/getOrders.dart';
import 'package:shopping/ui/login/needAuth.dart';
import 'package:shopping/ui/main/home/home.dart';
import 'package:shopping/widget/skinRoute.dart';
import '../mainscreen.dart';

class OrdersScreen extends StatefulWidget {
  final Function(String) onErrorDialogOpen;
  final Function(String) onBack;
  OrdersScreen({this.onErrorDialogOpen, this.onBack});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

List<OrdersData> ordersData;
String ordersCurrency;

class _OrdersScreenState extends State<OrdersScreen> {

  var windowWidth;
  var windowHeight;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  _onItemClick(String id, String heroId){
    print("User pressed item with id: $id");
    idOrder = id;
    idHeroes = heroId;
    widget.onBack("order_details");
  }

  @override
  void initState() {
    if (account.isAuth()) {
      _waits(true);
      getOrders(account.token, _success, _onError);
    }
    account.addCallback(this.hashCode.toString(), callback);
    super.initState();
  }

  _success(List<OrdersData> data, String currency){
    _waits(false);
    ordersData = data;
    ordersCurrency = currency;
    if (mounted)
      setState(() {
      });
  }

  bool _wait = false;

  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  _onError(String err){
    _waits(false);
    if (err != "401")
      widget.onErrorDialogOpen("${strings.get(128)} $err"); // "Something went wrong. ",
  }

  callback(bool reg){
    if (mounted)
      setState(() {
      });
  }

  @override
  void dispose() {
    account.removeCallback(this.hashCode.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    Widget _body = mustAuth(windowWidth, context);
    if (account.isAuth()) {
      if (ordersData != null && ordersData.isEmpty)
        _body = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                UnconstrainedBox(
                    child: Container(
                        height: windowHeight/3,
                        width: windowWidth/2,
                        child: Container(
                          child: Image.asset("assets/noorders.png",
                            fit: BoxFit.contain,
                          ),
                        )
                    )),
                SizedBox(height: 20,),
                Text(strings.get(180),    // "Not Have Orders",
                    overflow: TextOverflow.clip,
                    style: theme.text16bold
                ),
                SizedBox(height: 50,),
              ],
            )
        );
      else
        _body = Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50),
            child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _handleRefresh,
                child: ListView(
                padding: EdgeInsets.only(top: 0, left: 10, right: 10),
                shrinkWrap: true,
                children: _children()
            ))
        );
    }

    return Directionality(
        textDirection: strings.direction,
        child: Stack(children: [
            _body,
            if (_wait) skinWait(context, true),
    ],));
  }

  Future<Null> _handleRefresh() async{
    getOrders(account.token, _success, _onError);
    _refreshIndicatorKey.currentState.deactivate();
  }

  _children(){
    List<Widget> list = [];
    list.add(SizedBox(height: 10,));
    // list.add(Container(
    //   child: IList1(imageAsset: "assets/orders.png",
    //     text: strings.get(36),                      // "My Orders",
    //     textStyle: theme.text16bold,
    //     imageColor: theme.colorDefaultText,
    //   )
    // ));
    // list.add(SizedBox(height: 20,));
    _list(list);
    list.add(SizedBox(height: 200,));
    return list;
  }

  _list(List<Widget> list){
    var height = windowWidth*0.35;
    if (ordersData == null)
      return;
    for (var item in ordersData) {
      list.add(skinOrderCard(item.orderid, _onItemClick,
      windowWidth, height, "$serverImages${item.image}",
      item.name, item.restaurant, item.date, basket.makePriceString(item.total),
        "${strings.get(195)}${item.orderid}", item.statusName,));   // Id #

        //   Container(
        //   child: ICard14FileCaching(
        //     radius: appSettings.radius,
        //     shadow: appSettings.shadow,
        //     color: theme.colorBackground,
        //     colorProgressBar: theme.colorPrimary,
        //     text: item.name,
        //     textStyle: theme.text16bold,
        //     text2: item.restaurant,
        //     textStyle2: theme.text14,
        //     text3: item.date,
        //     textStyle3: theme.text14,
        //     text4: (appSettings.rightSymbol == "false") ? "$ordersCurrency${item.total.toStringAsFixed(appSettings.symbolDigits)}" :
        //     "${item.total.toStringAsFixed(appSettings.symbolDigits)}$ordersCurrency",
        //     textStyle4: theme.text18boldPrimary,
        //     width: windowWidth,
        //     height: height,
        //     image: "$serverImages${item.image}",
        //     id: item.orderid,
        //     text6: item.statusName,
        //     textStyle6: theme.text16Companyon,
        //     text5: "${strings.get(195)}${item.orderid}", // Id #
        //     textStyle5: theme.text16bold,
        //     callback: _onItemClick,
        // )));
      list.add(SizedBox(height: 20,));
    }
  }


}