
import 'package:shopping/main.dart';
import 'package:shopping/model/server/addToBasket.dart';
import 'package:shopping/model/server/basketReset.dart';
import 'package:shopping/model/server/deleteFromBasket.dart';
import 'package:shopping/model/server/getBasket.dart';
import 'package:shopping/model/server/mainwindowdata.dart';
import 'package:shopping/model/server/setCountinBasket.dart';
import 'package:shopping/model/topRestourants.dart';
import 'dprint.dart';
import 'homescreenModel.dart';

class Basket{
  List<DishesData> basket = [];
  double taxes = 0.0;
  String restaurant;
  String orderid;
  double fee = 0.0;
  String _percentage;
  String perkm;
  String defCurrency = "";
  Coupon _coupon;
  double distance = 0;
  bool curbsidePickup = false;

  init(BasketResponse ret){
    fee = ret.fee;
    defCurrency = ret.currency;
    _percentage = ret.percent; //percentage;
    perkm = ret.perkm;
    orderid = ret.order.id;
    restaurant = ret.order.restaurant;
    taxes = ret.defaultTax;
    basket.clear();
    for (var item in ret.orderdetails){
      if (item.count != 0)
        basket.add(DishesData(
          image: item.image,
          name: item.food,
          price: item.foodprice,
          id: item.foodid,
          desc: "",
          ingredients: null,
          nutritions: null,
          restaurantName: "",
          restaurant: ret.order.restaurant,
          restaurantPhone: "",
          restaurantMobilePhone: "",
          extras: [], //List<Extras>(),
          foodsreviews: null,
          // currency: currency,
          delivered: true,
          count: item.count,
          category: item.category,
        ));
      else{   // extras add
        var extras = Extras(id: item.id, desc: "", name: item.extras, image: item.image, price: double.parse(item.extrasprice), select: true);
        for (var i in basket)
          if (i.id == item.foodid)
            i.extras.add(extras);
      }
    }
  }

  bool restaurantCheck(String id){
    for (var item in basket)
      if (item.count != 0)
        if (item.restaurant != id)
          return false;
      return true;
  }

  bool dishInBasket(String id){
    for (var item in basket)
      if (item.count != 0)
        if (item.id == id)
          return true;
    return false;
  }


  int inBasket(){
    var lenght = 0;
    for (var item in basket)
      if (item.count != 0)
        lenght++;
    return lenght;
  }

  reset(Function callback){
    basketReset(account.token, () {
      basket.clear();
      _coupon = null;
      callback();
    }, (String _) {});
  }

  delete(DishesData item){
    deleteFromBasket(account.token, orderid, item.id, () {
        }, (String _) {});
  }

  add(DishesData item){
    // tax
    if (item.ver == '2')
      taxes = item.tax;
    //
    var _addedName = "";
    if (item.variants != null)
      for (var item in item.variants)
        if (item.select)
          _addedName = item.name;
    //
    var t = DishesData().from(item);
    t.name = "${t.name} $_addedName";
    basket.add(t);
    restaurant = t.restaurant;
    addToBasket(basket, account.token, taxes.toString(), "hint", restaurant, "Cash on Delivery", '0', "0",
        "", "",  0.0, "0.0", "0.0", "false", "",
        (String id, String _fee, String percent, String _perkm) {
          fee = double.parse(_fee);
          _percentage = percent;
          perkm = _perkm;
          orderid = id;
          for (var item in basket)
            item.delivered = true;
        }, (String _) {});
  }

  deleteFrmBasket(String id){
    DishesData _current;
    for (var d in basket)
      if (d.id == id) {
        delete(d);
        d.count = 0;
        _current = d;
        break;
      }
    if (_current != null)
      basket.remove(_current);
  }

  setCount(String id, int value){
    for (var d in basket)
      if (d.id == id) {
        d.count = value;
        setCountInBasket(account.token, orderid, d.id, value.toString(), () {
        }, (String _) {});
        break;
      }
  }

  double getShoppingCost(bool needCoupons){
    if (_percentage == '1') {
      double total = getSubTotal(needCoupons) * fee / 100;
      return total;
    }else {
      if (perkm == '1')
        return fee * distance;
      else
        return fee;
    }
  }

  getTaxes(bool needCoupons){
    double t = getSubTotal(needCoupons) * taxes/100;
    return t;
  }
  
  double getTotal(bool needCoupons){
    double _subTotal = getSubTotal(needCoupons);
    var _fee = 0.0;
    if (_percentage == '1')
      _fee = _subTotal * fee/100;
    else {
      if (perkm == '1')
        _fee = fee * distance;
      else
        _fee = fee;
    }
    if (_curbsidePickup == "true" || curbsidePickup)
      _fee = 0;
    var _taxes = _subTotal*(taxes/100);
    return _subTotal+_fee+_taxes;
  }

  setCoupon(Coupon coupon) {
    _coupon = coupon;
  }
  getCoupon() {
    return _coupon;
  }

  _getSubTotal(){
    double _total = 0;
    for (var item in basket)
      _total += getItemPrice(item);
    return _total;
  }

  getItemPrice(DishesData item){
    if (item == null)
      return 0;
    var t = item.price * item.count;
    if (item.discountprice != null && item.discountprice != 0)
      t = item.discountprice * item.count;
    if (item.extras != null)
      for (var ex in item.extras)
        if (ex.select)
          t += (ex.price * item.count);
    return t;
  }

  getItemPriceText(DishesData item) {
    var t = item.price * item.count;
    if (item.discountprice != null && item.discountprice != 0)
      t = item.discountprice * item.count;
    var text = "${makePriceString(item.price)} x ${item.count} = ${makePriceString(t)}";
    if (item.extras != null)
      for (var ex in item.extras)
        if (ex.select) {
          t += (ex.price * item.count);
          text = "$text \n\n + ${ex.name} \n \t\t\t${makePriceString(ex.price)} * ${item.count} = ${makePriceString(ex.price*item.count)}";
        }

    return text;
  }

  _getItemPriceDEBUG(DishesData item){
    var t = item.price * item.count;
    String td = "price*count (${item.price}*${item.count}=$t)";
    for (var ex in item.extras)
      if (ex.select) {
        t += (ex.price * item.count);
        td = "$td and Extras ${ex.id}:${ex.name} price*count (${ex.price}*${item.count}=${ex.price * item.count})";
      }
    return "$td. TOTAL: $t";
  }

  String couponComment = "";

  getSubTotal(bool needCoupons){
    var _total = _getSubTotal();
    if (!needCoupons)
      return _total;
    if (_coupon != null){
      dprint("getSubTotal coupon present");
      couponComment = "";
      if (_total > _coupon.amount){
        //
        var total = 0.0;
        for (var food in basket){
          var price = getItemPrice(food);
          var priceCoupon = price;

          if (_coupon.allRestaurants == '1') {
            priceCoupon = _couponCalculate(price);
            if (_coupon.allCategory != '1' && !_coupon.categoryList.contains(food.category)) {
              priceCoupon = price;
              dprint("getSubTotal not present in category list=${_coupon.categoryList} need=${food.category}");
            }else
              dprint("getSubTotal present in category list=${_coupon.categoryList} need=${food.category}");

            if (_coupon.allFoods != '1' && !_coupon.foodsList.contains(food.id)) {
              priceCoupon = price;
              dprint("getSubTotal not present in foods list=${_coupon.foodsList} need=${food.id}");
            }else
              dprint("getSubTotal present in foods list=${_coupon.foodsList} need=${food.id}");

          }else{
            if (_coupon.restaurantsList.contains(food.restaurant)) {
              priceCoupon = _couponCalculate(price);
              if (_coupon.allCategory != '1' && !_coupon.categoryList.contains(food.category)) {
                priceCoupon = price;
                dprint("getSubTotal not present in category list=${_coupon.categoryList} need=${food.category}");
              }else
                dprint("getSubTotal present in category list=${_coupon.categoryList} need=${food.category}");

              if (_coupon.allFoods != '1' && !_coupon.foodsList.contains(food.id)){
                priceCoupon = price;
                dprint("getSubTotal not present in foods list=${_coupon.foodsList} need=${food.id}");
              }else
                dprint("getSubTotal present in foods list=${_coupon.foodsList} need=${food.id}");

            }else
              priceCoupon = price;
          }
          if (priceCoupon != price)
            dprint("getSubTotal food ${food.id}:${food.name} IN ACTION. ${_getItemPriceDEBUG(food)} WITH COUPON=${_couponCalculateDEBUG(price)}");
          else{
            dprint("getSubTotal food ${food.id}:${food.name} NO IN ACTION. ${_getItemPriceDEBUG(food)}");
            couponComment = "$couponComment${strings.get(262)} ${food.name} ${strings.get(263)}\n"; // Food does not participate in the promotion",
          }
          total += priceCoupon;
        }
        if (total != _total)
          if (_coupon.inpercents != '1')
            total = _total - _coupon.discount;
        return total;
      }else{
        couponComment = "${strings.get(264)} ${_coupon.amount}\n";  // "The minimum purchase amount must be",
      }
    }
    return _total;
  }

  _couponCalculate(var _total){
    if (_coupon.inpercents == '1')
      _total = (100-_coupon.discount)/100*_total;
    else
      _total -= _coupon.discount;
    return _total;
  }

  _couponCalculateDEBUG(var _total){
    if (_coupon.inpercents == '1')
      return "$_total-${_coupon.discount}% = ${(100-_coupon.discount)/100*_total}";
    else
      return "$_total-${_coupon.discount} = ${_total - _coupon.discount}";
  }

  getDesc(){
    var _text = "";
    for (var item in basket) {
      _text = "${item.name} and other";
      break;
    }
    return _text;
  }

  String _curbsidePickup = "";
  String _paymentid = "";
  createOrder(String id, String addr, String phone, String hint, String lat, String lng, String curbsidePickup,
      String couponName,
      Function() _success, Function(String) _error){
    _paymentid = id;
    for (var item in basket)
      item.delivered = false;
      basketReset(account.token, (){
      _curbsidePickup = curbsidePickup;
      var _total = getTotal(true);
      _curbsidePickup = "";
      addToBasket(basket, account.token, taxes.toString(), hint, restaurant,
          _paymentid,   // method = Cash on Delivery
          getShoppingCost(true).toString(), "1", addr, phone,
          _total, lat, lng, curbsidePickup, couponName,
              (String id, String _fee, String percent, String _perkm) {
            fee = double.parse(_fee);
            _percentage = percent;
            perkm = _perkm;
            orderid = id;
            _success();
            basket.clear();
          }, _error);
    }, _error);
  }

  getCount(String id){
    for (var item in basket)
      if (item.id == id)
        if (item.count != 0)
          return item.count;
  }
  // basket.makePriceString(item.price),
  makePriceString(double price){
    return (appSettings.rightSymbol == "false") ? "$defCurrency${price.toStringAsFixed(appSettings.symbolDigits)}" :
        "${price.toStringAsFixed(appSettings.symbolDigits)}$defCurrency";
  }

  getShopInfo(){
    for (var rest in nearYourRestaurants)
      if (rest.id == restaurant)
        return rest;
  }

}

