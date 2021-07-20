
import 'package:shopping/main.dart';
import 'package:shopping/model/categories.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/foods.dart';
import 'package:shopping/model/geolocator.dart';
import 'package:shopping/model/pref.dart';
import 'package:shopping/model/review.dart';
import 'package:shopping/model/server/mainwindowdata.dart';
import 'package:shopping/model/server/secondstep.dart';
import 'package:shopping/model/topRestourants.dart';
import 'package:shopping/ui/main/mainscreen.dart';

AppSettings appSettings = AppSettings();

class HomeScreenModel{
  MainWindowDataAPI _mainWindowDataServerApi = MainWindowDataAPI();
  MainWindowData mainWindowData;
  SecondStepData secondStepData;

  Function(String) _callbackError;
  Function() _callback;
  var location = MyLocation();

  _error(String error){
    dprint(error);
    _callbackError(error);
  }

  bool _init = false;
  _dataLoad(MainWindowData _data) async {
    if (!_data.success)
      return _error("_data = null");

    if (_init)
      return _callback();

    //
    appSettings = _data.settings;
    theme.setAppSettings();
    //

    basket.defCurrency = _data.currency;
    basket.taxes = _data.defaultTax;
    // top restaurants
    if (_data.toprestaurants != null)
      topRestaurants = _data.toprestaurants;

    // restaurants near your
    if (_data.restaurants != null)
          nearYourRestaurants = _data.restaurants;

    categories = _data.categories;

    // favorites
    mostPopular = _data.favorites;

    // top foods
    topFoods = _data.topFoods;

    // reviews
    if (_data.restaurantsreviews != null) {
      for (var review in _data.restaurantsreviews){
        if (review.name != "null")
          reviews.add(Reviews(image: "${review.image}", name: review.name,
            text: review.desc,
              date: review.updatedAt,
              id : review.id, star: review.rate),
            );
      }
    }

    mainWindowData = _data;
    _init = true;
    _callback();
    account.redraw();
    pref.set(Pref.bottomBarType, appSettings.bottomBarType);
  }

  load(Function() callback, Function(String) callbackError){
    _callbackError = callbackError;
    _callback = callback;
    if (mainWindowData != null)
      return _dataLoad(mainWindowData);
    _mainWindowDataServerApi.get(_dataLoad, _error);
    loadSecondStep(_secondDataLoad, _error);
  }

  _secondDataLoad(SecondStepData _secondStepData){
    if (_secondStepData.error == "0") {
      secondStepData = _secondStepData;
      addFoods(secondStepData.foods);
      account.redraw();
    }
  }

  distance() async {
    for (var item in nearYourRestaurants)
      item.distance = await location.distance(item.lat, item.lng);
    nearYourRestaurants.sort((a, b) => a.compareTo(b));
  }

}
