import 'package:shared_preferences/shared_preferences.dart';

class Pref{

  SharedPreferences _prefs;

  static String userEmail = "userEmail";
  static String userPassword = "userPassword";
  static String userAvatar = "userAvatar";

  static String deliveryAddressInit = "deliveryAddressInit";
  static String deliveryAddress = "deliveryAddress";
  static String deliveryCurbsidePickup = "deliveryCurbsidePickup";
  static String deliveryLatitude = "deliveryLatitude";
  static String deliveryLongitude = "deliveryLongitude";
  static String deliveryPhone = "deliveryPhone";
  static String deliveryHint = "deliveryHint";

  static String language = "language";
  static String userSelectLanguage = "userSelectLanguage";

  // ui
  static String uiMainColor = "uiMainColor";
  static String uiDarkMode = "uiDarkMode";
  static String bottomBarType = "bottomBarType";

  // maps
  static String mainMapLat = "mainMapLat";
  static String mainMapLng = "mainMapLng";
  static String mainMapZoom = "mainMapZoom";

  // city
  static String city = "city";
  static String allCity = "allCity";

  init() async {
    await _init2();
  }

  _init2() async {
    _prefs = await SharedPreferences.getInstance();
  }

  set(String key, String value)  async {
    if (_prefs == null)
      await _init2();
    _prefs.setString(key, value);
  }

  String get(String key)  {
    String text = "";
    try{
      text = _prefs.getString(key);
      if (text == null)
        text = "";
    }catch(ex){}
    return text;
  }

  clearUser(){
    set(Pref.userEmail, "");
    set(Pref.userPassword, "");
    set(Pref.userAvatar, "");
    //set(Pref.userToken, "");
  }
}