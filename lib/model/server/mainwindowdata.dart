import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shopping/config/api.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/pref.dart';
import 'dart:convert';

import '../utils.dart';

class MainWindowDataAPI {

  MainWindowData _data;

  get(Function(MainWindowData) callback, Function(String) callbackError) async {

    if (_data != null) {
      return callback(_data);
    }

    try {
      var url = "${serverPath}getMain";
      var response = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
        'Accept': "application/json",
        // 'Host' : "madir.com.ng"
      }).timeout(const Duration(seconds: 30));

      dprint(url);
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        MainWindowData ret = MainWindowData.fromJson(jsonResult);
        _data = ret;
        callback(ret);
      } else
        callbackError("statusCode=${response.statusCode}");
    } on Exception catch (ex) {
      callbackError(ex.toString());
    }
  }
}

class MainWindowData {
  bool success;
  List<Restaurants> restaurants;
  List<Restaurants> toprestaurants;
  List<CategoriesData> categories;
  List<DishesData> favorites;
  List<DishesData> topFoods;
  List<RestaurantsReviewsData> restaurantsreviews;
  List<Coupon> coupons;
  PaymentsMethods payments;
  String currency;
  double defaultTax;
  AppSettings settings;
  MainWindowData({this.success, this.restaurants, this.categories, this.favorites, this.restaurantsreviews, this.currency,
    this.defaultTax, this.payments, this.settings, this.topFoods, this.toprestaurants, this.coupons});
  factory MainWindowData.fromJson(Map<String, dynamic> json){
    var _restaurants;
    if (json['restaurants'] != null) {
      var items = json['restaurants'];
      var t = items.map((f)=> Restaurants.fromJson(f)).toList();
      _restaurants = t.cast<Restaurants>().toList();
    }
    var _toprestaurants;
    if (json['toprestaurants'] != null) {
      var items = json['toprestaurants'];
      var t = items.map((f)=> Restaurants.fromJson(f)).toList();
      _toprestaurants = t.cast<Restaurants>().toList();
    }
    var _categories;
    if (json['categories'] != null) {
      var items = json['categories'];
      var t = items.map((f)=> CategoriesData.fromJson(f)).toList();
      _categories = t.cast<CategoriesData>().toList();
    }
    var _favorites;
    if (json['favorites'] != null) {
      var items = json['favorites'];
      var t = items.map((f)=> DishesData.fromJson(f)).toList();
      _favorites = t.cast<DishesData>().toList();
    }
    var _top;
    if (json['top_foods'] != null) {
      var items = json['top_foods'];
      var t = items.map((f)=> DishesData.fromJson(f)).toList();
      _top = t.cast<DishesData>().toList();
    }
    var _restaurantsreviews;
    if (json['restaurantsreviews'] != null) {
      var items = json['restaurantsreviews'];
      var t = items.map((f)=> RestaurantsReviewsData.fromJson(f)).toList();
      _restaurantsreviews = t.cast<RestaurantsReviewsData>().toList();
    }
    var _coupons;
    if (json['coupons'] != null) {
      var items = json['coupons'];
      var t = items.map((f)=> Coupon.fromJson(f)).toList();
      _coupons = t.cast<Coupon>().toList();
    }
    var _payments = PaymentsMethods.fromJson(json['payments']);
    var _settings = AppSettings.fromJson(json['settings']);
    return MainWindowData(
      currency: json['currency'].toString(),
      success: toBool(json['success'].toString()),
      restaurants: _restaurants,
      toprestaurants: _toprestaurants,
      categories: _categories,
      favorites: _favorites,
      topFoods: _top,
      restaurantsreviews: _restaurantsreviews,
      defaultTax: toDouble(json['default_tax'].toString()),
      payments: _payments,
      settings: _settings,
      coupons: _coupons,
    );
  }
}

class Coupon{
  String id;
  String name;
  String dateStart;
  String dateEnd;
  double discount;
  String inpercents;
  double amount;

  String allRestaurants;
  String allCategory;
  String allFoods;
  List<String> restaurantsList;
  List<String> categoryList;
  List<String> foodsList;

  Coupon({this.id, this.name, this.discount, this.inpercents, this.amount,
    this.allRestaurants, this.allCategory, this.allFoods,
    this.restaurantsList, this.categoryList, this.foodsList, this.dateStart, this.dateEnd});
  factory Coupon.fromJson(Map<String, dynamic> jsons) {

    var _discount = 0.0;
    var _amount = 0.0;
    try{
      _discount = double.parse(jsons['discount']);
      _amount = double.parse(jsons['amount']);
    }catch(ex){
      dprint (ex.toString());
    }

    return Coupon(
      id: jsons['id'].toString(),
      name: jsons['name'].toString(),
      dateStart: jsons['dateStart'].toString(),
      dateEnd: jsons['dateEnd'].toString(),
      discount: _discount,
      amount: _amount,
      inpercents: jsons['inpercents'].toString(),
      allRestaurants : jsons['allRestaurants'].toString(),
      allCategory : jsons['allCategory'].toString(),
      allFoods : jsons['allFoods'].toString(),
      restaurantsList : jsons['restaurantsList'].toString().split(","),
      categoryList : jsons['categoryList'].toString().split(","),
      foodsList : jsons['foodsList'].toString().split(","),
    );
  }
}

class Restaurants {
  String id;
  String name;
  String address;
  String published;
  double lat;
  double lng;
  String image;
  String phone;
  String desc;
  String city;
  String mobilephone;

  String openTimeMonday;
  String closeTimeMonday;
  String openTimeTuesday;
  String closeTimeTuesday;
  String openTimeWednesday;
  String closeTimeWednesday;
  String openTimeThursday;
  String closeTimeThursday;
  String openTimeFriday;
  String closeTimeFriday;
  String openTimeSaturday;
  String closeTimeSaturday;
  String openTimeSunday;
  String closeTimeSunday;
  //
  int area;
  double distance;
  bool areaShowOnMap;
  double minimumAmount;

  Restaurants({this.id, this.name, this.address, this.published, this.lat, this.lng, this.image, this.phone, this.mobilephone, this.desc,
    this.openTimeMonday, this.closeTimeMonday,
    this.openTimeTuesday, this.closeTimeTuesday,
    this.openTimeWednesday, this.closeTimeWednesday,
    this.openTimeThursday, this.closeTimeThursday,
    this.openTimeFriday, this.closeTimeFriday,
    this.openTimeSaturday, this.closeTimeSaturday,
    this.openTimeSunday, this.closeTimeSunday, this.area, this.distance = 1, this.areaShowOnMap = false,
    this.minimumAmount, this.city
  });
  factory Restaurants.fromJson(Map<String, dynamic> json) {

    var _lat = 0.0;
    var _lng = 0.0;
    try{
      _lat = double.parse(json['lat']);
      _lng = double.parse(json['lng']);
    }catch(ex){
      dprint (ex.toString());
    }

    return Restaurants(
      id : json['id'].toString(),
      name: json['name'].toString(),
      desc: json['desc'].toString(),
      address: json['address'].toString(),
      published : json['published'].toString(),
      lat: _lat,
      lng: _lng,
      image: "$serverImages${json['image'].toString()}",
      phone: json['phone'].toString(),
      mobilephone: json['mobilephone'].toString(),
      openTimeMonday: json['openTimeMonday'].toString(),
      closeTimeMonday: json['closeTimeMonday'].toString(),
      openTimeTuesday: json['openTimeTuesday'].toString(),
      closeTimeTuesday: json['closeTimeTuesday'].toString(),
      openTimeWednesday: json['openTimeWednesday'].toString(),
      closeTimeWednesday: json['closeTimeWednesday'].toString(),
      openTimeThursday: json['openTimeThursday'].toString(),
      closeTimeThursday: json['closeTimeThursday'].toString(),
      openTimeFriday: json['openTimeFriday'].toString(),
      closeTimeFriday: json['closeTimeFriday'].toString(),
      openTimeSaturday: json['openTimeSaturday'].toString(),
      closeTimeSaturday: json['closeTimeSaturday'].toString(),
      openTimeSunday: json['openTimeSunday'].toString(),
      closeTimeSunday: json['closeTimeSunday'].toString(),
      area: toInt(json['area'].toString()),
      minimumAmount: (json['minAmount'] == null) ? toDouble("0.0") : toDouble(json['minAmount'].toString()),
      city: (json['city'] != null) ? json['city'].toString() : "",
    );
  }

  int compareTo(Restaurants b){
    if (distance > b.distance)
      return 1;
    if (distance < b.distance)
      return -1;
    return 0;
  }

}

class CategoriesData {
  String id;
  String name;
  String image;
  String visible;
  String parent;
  String vendor;
  CategoriesData({this.id, this.name, this.visible, this.image, this.parent, this.vendor});
  factory CategoriesData.fromJson(Map<String, dynamic> json) {
    return CategoriesData(
      id : json['id'].toString(),
      name: json['name'].toString(),
      visible: json['visible'].toString(),
      image: "$serverImages${json['image'].toString()}",
      parent: json['parent'].toString(),
      vendor: (json['vendor'] == null) ? "0" : json['vendor'].toString(),
    );
  }
}

class Nutritions {
  String desc;
  String name;
  Nutritions({this.name, this.desc});
  factory Nutritions.fromJson(Map<String, dynamic> json) {
    return Nutritions(
      name: json['name'].toString(),
      desc: json['desc'].toString(),
    );
  }
}

class Extras {
  String id;
  String desc;
  String name;
  String image;
  double price;
  bool select;
  Extras({this.id, this.name, this.desc, this.price, this.image, this.select = false});

  factory Extras.fromJson(Map<String, dynamic> json) {
    return Extras(
      id: json['id'].toString(),
      name: json['name'].toString(),
      desc: json['desc'].toString(),
      price: toDouble(json['price'].toString()),
      image: json['image'].toString(),
    );
  }
}

class FoodsReviews {
  String id;
  String createdAt;
  String desc;
  int rate;
  String image;
  String userName;
  FoodsReviews({this.id, this.desc, this.createdAt, this.rate, this.image, this.userName});
  factory FoodsReviews.fromJson(Map<String, dynamic> json) {
    var _image = "$serverImages${json['image'].toString()}";
    return FoodsReviews(
      id: json['id'].toString(),
      desc: json['desc'].toString(),
      createdAt: json['created_at'].toString(),
      rate: toInt(json['rate'].toString()),
      userName: json['userName'].toString(),
      image: _image,
    );
  }
}

class DishesData {
  String id;
  String name;
  String image;
  double price;
  double discountprice;
  String discount; // %
  String desc;
  String ingredients;
  String published;
  List<Nutritions> nutritions;
  List<Extras> extras;
  List<FoodsReviews> foodsreviews;
  String restaurant;
  String restaurantName;
  String restaurantPhone;
  String restaurantMobilePhone;
  String category;
  String fee;
  String percent;
  String ver;
  double tax;
  //
  bool delivered;
  int count;
  List<VariantsData> variants;
  List<RProductsData> rproducts;
  //
  List<String> imagesFiles; // images_files

  //
  DishesData({this.id, this.name, this.published, this.image, this.restaurantName, this.desc, this.ingredients,
      this.nutritions, this.restaurantPhone, this.restaurantMobilePhone, this.extras, this.foodsreviews, this.price, this.restaurant,
      this.category, this.fee, this.percent, this.discountprice,
      this.delivered = false, this.count = 0, this.discount = "", this.variants, this.rproducts,
      this.ver, this.tax, this.imagesFiles
  });
  factory DishesData.fromJson(Map<String, dynamic> json) {
    var m;
    if (json['nutritionsdata'] != null) {
      var items = json['nutritionsdata'];
      var t = items.map((f) => Nutritions.fromJson(f)).toList();
      m = t.cast<Nutritions>().toList();
    }
    var n;
    if (json['extrasdata'] != null) {
      var items = json['extrasdata'];
      var t = items.map((f) => Extras.fromJson(f)).toList();
      n = t.cast<Extras>().toList();
    }
    var d;
    if (json['foodsreviews'] != null) {
      var items = json['foodsreviews'];
      var t = items.map((f) => FoodsReviews.fromJson(f)).toList();
      d = t.cast<FoodsReviews>().toList();
    }

    var _variants;
    if (json['variants'] != null) {
      var items = json['variants'];
      var t = items.map((f) => VariantsData.fromJson(f)).toList();
      _variants = t.cast<VariantsData>().toList();
    }
    var _price = toDouble(json['price'].toString());
    var _dprice = toDouble(json['discountprice'].toString());

    if (_variants != null && _variants.isNotEmpty){
      if (_variants[0].dprice != 0)
        _dprice = _variants[0].dprice;
      else
        _dprice = 0;
      if (_variants[0].price != 0)
        _price = _variants[0].price;
      _variants[0].select = true;
    }
    var _rproducts;
    if (json['rproducts'] != null) {
      var items = json['rproducts'];
      var t = items.map((f) => RProductsData.fromJson(f)).toList();
      _rproducts = t.cast<RProductsData>().toList();
    }
    // dprint("$_price    $_dprice");
    var _discountText = "";
    if (_price != 0 && _dprice != 0)
      _discountText = "-${((_price-_dprice)~/(_price/100)).toString()}%";
    // dprint(_discountText);

    List<String> _imagesFiles = [];
    if (json['images_files'] != null)
      for (dynamic key in json['images_files']){
        _imagesFiles.add(key.toString());
      }

    return DishesData(
      id : json['id'].toString(),
      name: json['name'].toString(),
      published: json['published'].toString(),
      restaurant: json['restaurant'].toString(),
      restaurantName: json['restaurantName'].toString(),
      image: json['image'].toString(),
      desc : json['desc'].toString(),
      ingredients: json['ingredients'].toString(),
      nutritions: m,
      extras: n,
      foodsreviews: d,
      variants: _variants,
      restaurantPhone: json['restaurantPhone'].toString(),
      restaurantMobilePhone: json['restaurantMobilePhone'].toString(),
      price: _price,
      discountprice: _dprice,
      category: json['category'].toString(),
      fee: json['fee'].toString(),
      //percent: json['percent'],
      discount: _discountText,
      rproducts: _rproducts,
      ver : (json['ver'] == null) ? '1' : json['ver'].toString(),
      tax : (json['tax'] == null) ? 0 :  toDouble(json['tax'].toString()),
      imagesFiles: _imagesFiles,
    );
  }

  from(DishesData item){
    discount = item.discount;
    image = item.image;
    name = item.name;
    fee = item.fee;
    percent = item.percent;
    id = item.id;
    desc = item.desc;
    restaurantName = item.restaurantName;
    restaurant = item.restaurant;
    restaurantPhone = item.restaurantPhone;
    restaurantMobilePhone = item.restaurantMobilePhone;
    price = item.price;
    discountprice = item.discountprice;
    ingredients = item.ingredients;
    count = item.count;
    extras = [];
    category = item.category;
    if (item.extras != null)
      for (var extras in item.extras)
        this.extras.add(Extras(id: extras.id, desc: extras.desc, name: extras.name, image: extras.image, price: extras.price, select: extras.select ));
    return this;
  }

  String toJSON() {
    var t = json.encode(name);
    var t2 = json.encode(image);
    var discPrice = price;
    if (discountprice != null && discountprice != 0)
      discPrice = discountprice;

    var _text = '{"food": $t, "count": "$count", "foodprice": "$discPrice", "extras": "0", '
        '"extrascount" : "0", "extrasprice": "0", "foodid": "$id", "extrasid" : "0", "image" : $t2}';
    if (extras != null)
      for (var item in extras){
        if (item.select){
          var t = json.encode(item.name);
          _text = '$_text, {"food": "", "count": "0", "foodprice": "0", "extras": $t, '
              '"extrascount" : "$count", "extrasprice": "${item.price}", "foodid": "$id", "extrasid" : "${item.id}", '
              '"image" : ${json.encode(item.image)}}';
        }
      }
    return _text;
  }
}


class RProductsData {
  String rp;

  RProductsData({this.rp});
  factory RProductsData.fromJson(Map<String, dynamic> json) {
    return RProductsData(
      rp : json['rp'].toString(),
    );
  }
}


class VariantsData {
  String id;
  String name;
  String image;
  double price;
  double dprice;
  //
  bool select;

  VariantsData({this.id, this.price, this.dprice, this.image, this.name, this.select = false});
  factory VariantsData.fromJson(Map<String, dynamic> json) {
    return VariantsData(
      id : json['id'].toString(),
      name: json['name'].toString(),
      image: (json['image'] == null) ? null : "$serverImages${json['image'].toString()}",
      price: toDouble(json['price'].toString()),
      dprice: toDouble(json['dprice'].toString()),
    );
  }
}


class RestaurantsReviewsData {
  String id;
  String updatedAt;
  String image;
  String desc;
  String name;
  int rate;
  RestaurantsReviewsData({this.id, this.updatedAt, this.desc, this.image, this.name, this.rate});
  factory RestaurantsReviewsData.fromJson(Map<String, dynamic> json) {
    return RestaurantsReviewsData(
      id : json['id'].toString(),
      updatedAt: json['updated_at'].toString(),
      desc: json['desc'].toString(),
      name: json['name'].toString(),
      image: "$serverImages${json['image']}",
      rate: toInt(json['rate'].toString()),
    );
  }
}

class PaymentsMethods {
  // stripe
  String stripeEnable;
  String stripeKey;
  String stripeSecretKey;
  // razorpay
  String razEnable;
  String razKey;
  String razName;
  // cache on delivery
  String cacheEnable;
  // paypal
  String payPalEnable;
  String payPalSandBoxMode;
  String payPalClientId;
  String payPalSecret;
  // payStack
  String payStackEnable;
  String payStackKey;
  // yandex.kassa
  String yandexKassaEnable;
  String yandexKassaShopId;
  String yandexKassaClientAppKey;
  String yandexKassaSecretKey;
  // Instamojo
  String instamojoEnable;
  String instamojoSandBoxMode;
  String instamojoApiKey;
  String instamojoPrivateToken;
  // PayMob
  String payMobEnable;
  String payMobApiKey;
  String payMobFrame;
  String payMobIntegrationId;
  // MercadoPago
  String mercadoPagoEnable;
  String mercadoPagoAccessToken;
  String mercadoPagoPublicKey;
  // FlutterWave
  String flutterWaveEnable;
  String flutterWaveEncryptionKey;
  String flutterWavePublicKey;

  // currency code
  String code;
  PaymentsMethods({this.stripeEnable, this.stripeKey, this.stripeSecretKey, this.razEnable, this.razKey, this.razName, this.cacheEnable,
      this.code, this.payPalClientId, this.payPalEnable, this.payPalSecret, this.payPalSandBoxMode,
      this.payStackEnable, this.payStackKey, this.yandexKassaEnable, this.instamojoEnable, this.yandexKassaShopId,
      this.yandexKassaClientAppKey, this.yandexKassaSecretKey, this.instamojoSandBoxMode, this.instamojoApiKey,
      this.instamojoPrivateToken, this.payMobEnable, this.payMobApiKey, this.payMobFrame, this.payMobIntegrationId,
      this.mercadoPagoEnable, this.mercadoPagoAccessToken, this.mercadoPagoPublicKey,
      this.flutterWaveEnable, this.flutterWaveEncryptionKey, this.flutterWavePublicKey
  });
  factory PaymentsMethods.fromJson(Map<String, dynamic> json) {
    return PaymentsMethods(
        // stripe
        stripeEnable : json['StripeEnable'].toString(),
        stripeKey : json['stripeKey'].toString(),
        stripeSecretKey : json['stripeSecretKey'].toString(),
        // razorpay
        razEnable : json['razEnable'].toString(),
        razKey : json['razKey'].toString(),
        razName : json['razName'].toString(),
        // cache on delivery
        cacheEnable : json['cashEnable'].toString(),
        // payPal
        payPalEnable : json['payPalEnable'].toString(),
        payPalSandBoxMode : json['payPalSandBox'].toString(),
        payPalClientId : json['payPalClientId'].toString(),
        payPalSecret : json['payPalSecret'].toString(),
        // PayStack (Africa)
        payStackEnable : json['payStackEnable'].toString(),
        payStackKey : json['payStackKey'].toString(),
        // Yandex Kassa
        yandexKassaEnable : json['yandexKassaEnable'].toString(),
        yandexKassaShopId : json['yandexKassaShopId'].toString(),
        yandexKassaClientAppKey : json['yandexKassaClientAppKey'].toString(),
        yandexKassaSecretKey : json['yandexKassaSecretKey'].toString(),
        // instamojo
        instamojoEnable : json['instamojoEnable'].toString(),
        instamojoSandBoxMode : json['instamojoSandBoxMode'].toString(),
        instamojoApiKey : json['instamojoApiKey'].toString(),
        instamojoPrivateToken : json['instamojoPrivateToken'].toString(),
        // PayMob
        payMobEnable : (json['payMobEnable'] != null) ? json['payMobEnable'].toString() : "false",
        payMobApiKey : json['payMobApiKey'].toString(),
        payMobFrame : json['payMobFrame'].toString(),
        payMobIntegrationId : json['payMobIntegrationId'].toString(),
        // MercadoPago
        mercadoPagoEnable : (json['MercadoPagoEnable'] != null) ? json['MercadoPagoEnable'].toString() : "true",
        mercadoPagoAccessToken : (json['MercadoPagoAccessToken'] != null) ? json['MercadoPagoAccessToken'].toString() : "",
        mercadoPagoPublicKey : (json['MercadoPagoPublicKey'] != null) ? json['MercadoPagoPublicKey'].toString() : "",
        // FlutterWave
        flutterWaveEnable : (json['FlutterWaveEnable'] != null) ? json['FlutterWaveEnable'].toString() : "true",
        flutterWaveEncryptionKey : (json['FlutterWaveEncryptionKey'] != null) ? json['FlutterWaveEncryptionKey'].toString() : "",
        flutterWavePublicKey : (json['FlutterWavePublicKey'] != null) ? json['FlutterWavePublicKey'].toString() : "",
        // currency code
        code : json['code'].toString(),
    );
  }
}

class AppSettings {
  String currency;
  String darkMode;
  String rightSymbol;
  int symbolDigits;
  double radius;
  int shadow;
  List<String> rows;
  Color mainColor;
  Color iconColorWhiteMode;
  Color iconColorDarkMode;
  int restaurantCardWidth;
  int restaurantCardHeight;
  Color restaurantBackgroundColor;
  Color restaurantCardTextColor;
  Color dishesTitleColor;
  int dishesCardHeight;
  String oneInLine;
  int categoryCardWidth;
  int categoryCardHeight;
  double restaurantCardTextSize;
  Color dishesBackgroundColor;
  Color searchBackgroundColor;
  Color restaurantTitleColor;
  Color reviewTitleColor;
  Color reviewBackgroundColor;
  Color categoriesTitleColor;
  Color categoriesBackgroundColor;
  String categoryCardCircle;
  int topRestaurantCardHeight;
  String bottomBarType;
  Color bottomBarColor;
  Color titleBarColor;
  String mapapikey;
  String walletEnable;
  String typeFoods;
  String distanceUnit;
  String appLanguage;
  int banner1CardHeight;
  int banner2CardHeight;
  //
  String copyright;
  String copyrightText;
  String about;
  String delivery;
  String privacy;
  String terms;
  String refund;
  String faq;
  String refundTextName;
  String aboutTextName;
  String deliveryTextName;
  String privacyTextName;
  String termsTextName;
  //
  double defaultLat;
  double defaultLng;
  double defaultZoom;
  //
  String googleLogin;
  String facebookLogin;
  //
  String otp;
  String curbsidePickup;
  String coupon;
  String deliveringTime;
  String deliveringDate;
  String delivering;

  String skin;
  String shareAppGooglePlay;
  String shareAppAppStore;

  String city;
  // List<AdditionFields> additionFields;

  AppSettings({
    this.currency,
    this.darkMode = "false",
    this.rightSymbol = "false",
    this.walletEnable,
    this.symbolDigits = 2,
    this.radius = 15,
    this.shadow = 40,
    this.rows = const ["search", "nearyou", "cat", "pop", "review"],
    this.mainColor,
    this.iconColorWhiteMode = Colors.black,
    this.iconColorDarkMode = Colors.white,
    // restaurants
    this.restaurantCardWidth = 60,
    this.restaurantCardHeight = 40,
    this.restaurantBackgroundColor,
    this.restaurantCardTextSize,
    this.restaurantCardTextColor,
    this.restaurantTitleColor,
    // top restaurants
    this.topRestaurantCardHeight,
    // dishes - most popular
    this.dishesTitleColor,
    this.dishesBackgroundColor,
    this.dishesCardHeight = 80,
    this.oneInLine = "false",
    this.typeFoods = "",
    // categories
    this.categoryCardCircle,
    this.categoriesTitleColor,
    this.categoriesBackgroundColor,
    this.categoryCardWidth = 60,
    this.categoryCardHeight = 40,
    // search
    this.searchBackgroundColor,
    // review
    this.reviewTitleColor,
    this.reviewBackgroundColor,
    // bottomBar
    this.bottomBarType,
    this.bottomBarColor,
    // title bar
    this.titleBarColor,
    // map api key
    this.mapapikey,
    // km or miles
    this.distanceUnit,
    // app language
    this.appLanguage,
    // banners
    this.banner1CardHeight,
    this.banner2CardHeight,
    // documents
    this.copyright,
    this.copyrightText,
    this.about,
    this.delivery,
    this.privacy,
    this.terms,
    this.refund,
    this.faq,
    this.refundTextName,
    this.aboutTextName,
    this.deliveryTextName,
    this.privacyTextName,
    this.termsTextName,
    //
    this.defaultLat,
    this.defaultLng,
    this.defaultZoom,
    //
    this.googleLogin,
    this.facebookLogin,
    //
    this.otp,
    this.curbsidePickup,
    this.coupon,
    this.deliveringTime,
    this.deliveringDate,
    this.delivering,
    // this.additionFields,
    this.skin,
    this.shareAppGooglePlay,
    this.shareAppAppStore,
    //
    this.city,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    var _rows;
    if (json['rows'] != null) {
      _rows = json['rows'].cast<String>().toList();
    }else
      _rows = const ["search", "banner1", "topf", "nearyou", "cat", "pop", "review", "topr"];

    // debug
    //_rows = const ["search", "categoryDetails", "banner1", "topf", "banner2", "nearyou", "cat", "pop", "topr", "review", "copyright"];

    if (json['darkMode'] != null){
      if (json['darkMode'] == "true")
        theme.darkMode = true;
      else
        theme.darkMode = false;
      theme.init();
      pref.set(Pref.uiDarkMode, json['darkMode']);
    }

    return AppSettings(
      currency: json['currency'].toString(),
      darkMode : json['darkMode'].toString(),
      rightSymbol : json['rightSymbol'].toString(),
      symbolDigits: toInt(json['symbolDigits'].toString()),
      walletEnable : (json['walletEnable'] == null) ? "true" : json['walletEnable'].toString(),
      radius : (json['radius'] == null) ? 3 : toDouble(json['radius'].toString()),
      shadow : (json['shadow'] == null) ? 10 : toInt(json['shadow'].toString()),
      rows : _rows,
      iconColorWhiteMode : (json['iconColorWhiteMode'] == null) ? theme.colorDefaultText : Color(int.parse(json['iconColorWhiteMode'].toString(), radix: 16)),
      iconColorDarkMode : (json['iconColorDarkMode'] == null) ? Colors.white : Color(int.parse(json['iconColorDarkMode'].toString(), radix: 16)),
      mainColor : (json['mainColor'] == null) ? theme.colorPrimary : Color(int.parse(json['mainColor'].toString(), radix: 16)),
      // restaurant
      restaurantTitleColor :  (json['restaurantTitleColor'] == null) ? theme.colorBackground : Color(int.parse(json['restaurantTitleColor'].toString(), radix: 16)),
      restaurantCardWidth : (json['restaurantCardWidth'] == null) ? 60 : toInt(json['restaurantCardWidth'].toString()),
      restaurantCardHeight :  (json['restaurantCardHeight'] == null) ? 40 : toInt(json['restaurantCardHeight'].toString()),
      restaurantBackgroundColor : (json['restaurantBackgroundColor'] == null) ? theme.colorBackground : Color(int.parse(json['restaurantBackgroundColor'].toString(), radix: 16)),
      restaurantCardTextSize :  (json['restaurantCardTextSize'] == null) ? 14 : toDouble(json['restaurantCardTextSize'].toString()),
      restaurantCardTextColor : (json['restaurantCardTextColor'] == null) ? theme.colorDefaultText : Color(int.parse(json['restaurantCardTextColor'].toString(), radix: 16)),
      // top restaurants
      topRestaurantCardHeight :  (json['topRestaurantCardHeight'] == null) ? 60 : toInt(json['topRestaurantCardHeight'].toString()),
      // dishes
      dishesTitleColor : (json['dishesTitleColor'] == null) ? theme.colorBackground : Color(int.parse(json['dishesTitleColor'].toString(), radix: 16)),
      dishesBackgroundColor : (json['dishesBackgroundColor'] == null) ? theme.colorBackground : Color(int.parse(json['dishesBackgroundColor'].toString(), radix: 16)),
      dishesCardHeight : (json['dishesCardHeight'] == null) ? 70 : toInt(json['dishesCardHeight'].toString()),
      oneInLine : (json['oneInLine'] == null) ? "false" : json['oneInLine'].toString(),
      typeFoods : (json['typeFoods'] == null) ? "type2" : json['typeFoods'].toString(),
      // search
      searchBackgroundColor : (json['searchBackgroundColor'] == null) ? theme.colorBackground : Color(int.parse(json['searchBackgroundColor'].toString(), radix: 16)),
      // review
      reviewTitleColor : (json['reviewTitleColor'] == null) ? theme.colorBackground : Color(int.parse(json['reviewTitleColor'].toString(), radix: 16)),
      reviewBackgroundColor : (json['reviewBackgroundColor'] == null) ? theme.colorBackground : Color(int.parse(json['reviewBackgroundColor'].toString(), radix: 16)),
      // categories
      categoriesTitleColor : (json['categoriesTitleColor'] == null) ? theme.colorBackground : Color(int.parse(json['categoriesTitleColor'].toString(), radix: 16)),
      categoriesBackgroundColor: (json['categoriesBackgroundColor'] == null) ? theme.colorBackground : Color(int.parse(json['categoriesBackgroundColor'].toString(), radix: 16)),
      categoryCardWidth : (json['categoryCardWidth'] == null) ? 30 : toInt(json['categoryCardWidth'].toString()),
      categoryCardHeight : (json['categoryCardHeight'] == null) ? 30 : toInt(json['categoryCardHeight'].toString()),
      categoryCardCircle : (json['categoryCardCircle'] == null) ? "true" : json['categoryCardCircle'].toString(),
      // bottom bar
      bottomBarType : (json['bottomBarType'] == null) ? "type1" : json['bottomBarType'].toString(),
      bottomBarColor : (json['bottomBarColor'] == null) ? theme.colorBackground : Color(int.parse(json['bottomBarColor'].toString(), radix: 16)),
      titleBarColor :  (json['titleBarColor'] == null) ? theme.colorBackground : Color(int.parse(json['titleBarColor'].toString(), radix: 16)),
      // map api key
      mapapikey : (json['mapapikey'] == null) ? "" : json['mapapikey'].toString(),
      // km or miles
      distanceUnit : (json['distanceUnit'] == null) ? "" : json['distanceUnit'].toString(),
      // app language
      appLanguage: (json['appLanguage'] == null) ? "1" : json['appLanguage'].toString(), // default english
      //
      banner1CardHeight : (json['banner1CardHeight'] == null) ? 40 : toInt(json['banner1CardHeight'].toString()),
      banner2CardHeight : (json['banner2CardHeight'] == null) ? 40 : toInt(json['banner2CardHeight'].toString()),
      //
      copyright : json['copyright'].toString(),
      copyrightText : json['copyright_text'].toString(),
      about : json['about'].toString(),
      delivery : json['delivery'].toString(),
      privacy : json['privacy'].toString(),
      terms : json['terms'].toString(),
      refund : json['refund'].toString(),
      faq : json['faq'].toString(),
      refundTextName : json['refund_text_name'].toString(),
      aboutTextName : json['about_text_name'].toString(),
      deliveryTextName : json['delivery_text_name'].toString(),
      privacyTextName : json['privacy_text_name'].toString(),
      termsTextName : json['terms_text_name'].toString(),
      //
      googleLogin : (json['googleLogin_ca'] == null) ? "true" : json['googleLogin_ca'].toString(),
      facebookLogin : (json['facebookLogin_ca'] == null) ? "true" : json['facebookLogin_ca'].toString(),
      // Paris  48.836010 2.331359
      // London 51.511680332118786, -0.12748138132489592
      defaultLat : (json['defaultLat'] == null) ? 48.836010 : toDouble(json['defaultLat'].toString()),
      defaultLng : (json['defaultLng'] == null) ? 2.331359 : toDouble(json['defaultLng'].toString()),
      defaultZoom : (json['defaultZoom'] == null) ? 12 : toDouble(json['defaultZoom'].toString()),
      //
      otp : (json['otp'] == null) ? "false" : json['otp'],
      curbsidePickup : (json['curbsidePickup'] == null) ? "true" : json['curbsidePickup'],
      coupon : (json['coupon'] == null) ? "true" : json['coupon'],
      deliveringTime : (json['deliveringTime'] == null) ? "true" : json['deliveringTime'],
      deliveringDate : (json['deliveringDate'] == null) ? "true" : json['deliveringDate'],
      delivering : (json['delivering'] == null) ? "true" : json['delivering'],
      //
      skin : (json['skin'] == null) ? "basic" : json['skin'],
      // share
      shareAppGooglePlay : (json['shareAppGooglePlay'] == null) ? "" : json['shareAppGooglePlay'],
      shareAppAppStore : (json['shareAppAppStore'] == null) ? "" : json['shareAppAppStore'],
      // city
      city : (json['city'] == null) ? "" : json['city'].toString(),
    );
  }

  Color getIconColorByMode(bool darkMode){
    if (darkMode)
      return iconColorDarkMode;
    else
      return iconColorWhiteMode;
  }
}




// AdditionFields
