
import 'package:shopping/config/api.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/foods.dart';
import 'package:shopping/model/pref.dart';
import 'package:shopping/model/server/favorites.dart';
import 'package:shopping/model/server/fcbToken.dart';
import 'package:shopping/model/server/getBasket.dart';
import 'package:shopping/model/server/login.dart';
import 'package:shopping/model/server/mainwindowdata.dart';
import 'package:shopping/ui/main/mainscreen.dart';

class Account {

  String _fcbToken;
  String userName = "";
  String email = "";
  String phone = "";
  String userAvatar = "";
  String token = "";
  double walletBalance = 0;
  int inBasket = 10;
  bool _initUser = false;
  bool _init = false;
  String typeReg = "";

  List<FavoritesData> _favorites;

  okUserEnter(String name, String password, String avatar, String _email, String _token,
        String _phone, int unreadNotify, String _typeReg){
    typeReg = _typeReg;
    _init = true;
    _initUser = true;
    userName = name;
    userAvatar = avatar;
    if (userAvatar == null)
      userAvatar = serverImgNoUserPath;
    if (userAvatar.isEmpty)
      userAvatar = serverImgNoUserPath;
    email = _email;
    if (_phone != "null") phone = _phone; else phone = "";
    token = _token;
    notifyCount = unreadNotify;
    pref.set(Pref.userEmail, _email);
    pref.set(Pref.userPassword, password);
    pref.set(Pref.userAvatar, avatar);
    dprint("User Auth! Save email=$email pass=$password");
    _callAll(true);
    getBasket(account.token, _load, (String x){
      dprint("error $x");
    });
    if (_fcbToken != null)
      addNotificationToken(account.token, _fcbToken);
    getFavorites(account.token, _loadFavorites, (String _){});
  }

  _loadFavorites(List<FavoritesData> list, List<DishesData> food, String currency){
    _favorites = list;
    userFavorites.clear();
    // favorites
    userFavorites = food;
    redraw();
  }

  // _load(OrderData order, List<OrderDetailsData> orderdetails, String currency, double defaultTax, String fee, String percentage){
  _load(BasketResponse ret){
    // basket.init(order, orderdetails, currency, defaultTax, fee, percentage);
    basket.init(ret);
    _callAll(true);
  }

  logOut(){
    _initUser = false;
    pref.clearUser();
    userName = "";
    userAvatar = "";
    email = "";
    token = "";
    _callAll(false);
  }

  var callbacks = Map<String, Function(bool)>();

  addCallback(String name, Function(bool) callback){
    callbacks.addAll({name: callback});
  }

  removeCallback(String name){
    callbacks.remove(name);
  }

  redraw(){
    _callAll(_initUser);
  }

  _callAll(bool value){
    for (var callback in callbacks.values) {
      try {
        callback(value);
      } catch(ex){}
    }
  }

  isAuth(){
    if (!_init){
      var email = pref.get(Pref.userEmail);
      var pass = pref.get(Pref.userPassword);
      dprint("Login: email=$email pass=$pass");
      if (email.isNotEmpty && pass.isNotEmpty) {
        _init = true;
        login(email, pass, okUserEnter, (String err) {

        });
      }
    }
    return _initUser;
  }

  setUserAvatar(String _avatar){
    userAvatar = _avatar;
    _callAll(true);
  }

  getFavoritesState(String id){
    if (_favorites == null)
      return false;
    for (var item in _favorites)
      if (item.food == id)
        return true;
      return false;
  }

  revertFavoriteState(String id){
    var action = "favoritesAdd";
    var state = getFavoritesState(id);
    if (state) {
      action = "favoritesDelete";
      FavoritesData data;
      for (var item in _favorites)
        if (item.food == id)
          data = item;
      if (data != null)
        _favorites.remove(data);
      //
      DishesData data2;
      for (var item in userFavorites)
        if (item.id == id)
          data2 = item;
      if (data2 != null)
        userFavorites.remove(data2);
    }else {
      _favorites.add(FavoritesData(food: id));
      DishesData temp = loadFood(id);
      if (temp != null)
        userFavorites.add(temp);
      //
      var food = loadFood(id);
      if (!userFavorites.contains(food))
        userFavorites.add(food);
    }
    favorites(account.token, action, id, (){}, (String _){});
    _callAll(_initUser);
    return !state;
  }



  //
  // chat
  //
  int chatCount = 0;

  chatRefresh(){
    if (callbackChatReload != null)
      callbackChatReload();
  }

  addChat(){
    chatCount++;
    _callAll(_initUser);
    if (callbackChatReload != null)
      callbackChatReload();
  }

  Function() callbackChatReload;

  addChatCallback(Function() callback){
    callbackChatReload = callback;
  }

  //
  // Notifications
  //

  int notifyCount = 0;

  setFcbToken(String token){
    _fcbToken = token;
    if (_initUser)
      addNotificationToken(account.token, _fcbToken);
  }

  addNotify(){
    notifyCount++;
    _callAll(_initUser);
    if (callbackNotifyReload != null)
      callbackNotifyReload();
  }

  notifyRefresh(){
    _callAll(_initUser);
    if (callbackNotifyReload != null)
      callbackNotifyReload();
  }

  Function() callbackNotifyReload;
  addNotifyCallback(Function() callback){
    callbackNotifyReload = callback;
  }

}
