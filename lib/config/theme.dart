import 'package:flutter/material.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/pref.dart';

class AppThemeData{

  // String appTypePre = "restaurants";
  // String appTypePre = "market";
  // String appTypePre = "markets";
  String appTypePre = "multivendor";
  //
  String appSkin = "basic";
  // String appSkin = "smarter";
  //
  //
  bool vendor = false; // chat, category details
  bool multiple = true;
  //
  // Dark mode flag
  //
  bool darkMode = false;
  //
  // colors
  //
  Color colorGrey = Color.fromARGB(255, 209, 210, 205);
  Color colorPrimary = Color(0xff66b88c);
  Color colorCompanion = Color(0xff029600);
  var colorsVendorGradient = [Color(0xff98c7d8).withAlpha(100),  Color(0xff5794aa), Color(0xff306375), Color(0xff183843),];

  Color colorGrey2 = Color.fromARGB(255, 209, 210, 205).withOpacity(0.1);
  Color colorBackground;
  Color colorBackgroundGray;
  Color colorDefaultText;
  Color colorBackgroundDialog;
  MaterialColor primarySwatch;
  List<Color> colorsGradient = [];
  Color colorDarkModeLight = Color.fromARGB(255, 40, 40, 40); // for dialog background in dark mode
  //

  // Smarter
  Color sMenuColor = Color(0xff667482);
  Color sGreyColor = Color(0xffd3d3d6);
  Color sDarkBlueColor = Color(0xff000a32);
  double sMenuFontSize = 16;


  TextStyle text12grey;
  TextStyle text12bold;
  TextStyle text12Ubold;
  TextStyle text10white;
  TextStyle text14;
  TextStyle text14R;
  TextStyle text14l;
  TextStyle text14primary;
  TextStyle text14purple;
  TextStyle text14grey;
  TextStyle text14bold;
  TextStyle text14boldPimary;
  TextStyle text14boldWhite;
  TextStyle text14boldWhiteShadow;
  TextStyle text14link = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.underline,
      fontSize: 14,
  );
  TextStyle text16;
  TextStyle text16Red;
  TextStyle text16UI;
  TextStyle text16Ubold;
  TextStyle text16UIWhite;
  TextStyle text16Companyon;
  TextStyle text16bold;
  TextStyle text16boldWhite;
  TextStyle text18boldPrimary;
  TextStyle text18boldPrimaryUI;
  TextStyle text18boldPrimaryUIWhite;
  TextStyle text18bold;
  TextStyle text20;
  TextStyle text20bold;
  TextStyle text20boldPrimary;
  TextStyle text20boldWhite;
  TextStyle text20negative;
  TextStyle text22primaryShadow;
  TextStyle text60 = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontSize: 60,
  );

  changeDarkMode(){
    darkMode = !darkMode;
    init();
  }

  init(){
    if (appTypePre == "restaurants"){
      colorPrimary = Color(0xff668798); // restaurants
      colorCompanion = Color(0xff009688); // restaurants
    }
    if (appTypePre == "market"){
      multiple = false;
    }
    if (appTypePre == "multivendor"){
      vendor = true;
      multiple = true;
      colorPrimary = Color(0xff668798); // restaurants
      colorCompanion = Color(0xff009688); // restaurants
    }
    if (appTypePre == "markets"){
      multiple = true;
    }

    if (darkMode) {
      colorBackground = _backgroundDarkColor;
      colorDefaultText = _backgroundColor;
      primarySwatch = black;
      colorBackgroundGray = Colors.white.withOpacity(0.1);
      colorBackgroundDialog = colorDarkModeLight;
      Color _color2 = Color.fromARGB(80, 80, 80, 80);
      colorsGradient = [_color2, Colors.black];
    }else {
      Color _color2 = Color.fromARGB(80, colorPrimary.red, colorPrimary.green, colorPrimary.blue);
      colorsGradient = [_color2, colorPrimary];
      colorBackgroundGray = Colors.black.withOpacity(0.01);
      colorBackgroundDialog = _backgroundColor;
      colorBackground = _backgroundColor;
      colorDefaultText = _backgroundDarkColor;
      primarySwatch = black;//white;
    }

    if (appSkin == "smarter")
      colorBackground = Color(0xfffafafa);

    text10white = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 10,
    );

    text12grey = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );

    text12bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 12,
    );

    text12Ubold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      decoration: TextDecoration.lineThrough,
      fontSize: 12,
    );

    text14 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14l = TextStyle(
      decoration: TextDecoration.lineThrough,
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14R = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14primary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14purple = TextStyle(
      color: Colors.purple,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
    text14bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );

    text14boldPimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );

    text14grey = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14boldWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );

    text14boldWhiteShadow = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 14,
        shadows: [
          Shadow(
              offset: Offset(1, 1),
              color: Colors.black,
              blurRadius: 1
          ),
        ]
    );

    text16bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );

    text16Ubold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      decoration: TextDecoration.lineThrough,
      fontSize: 16,
    );

    text16boldWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );

    text16 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );

    text16Red = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );

    text16UI = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );
    text16UIWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );

    text16Companyon = TextStyle(
      color: colorCompanion,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );

    text18boldPrimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 18,
    );

    text18boldPrimaryUI = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 18,
    );
    text18boldPrimaryUIWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 18,
    );

    text18bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 18,
    );

    text20bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20boldPrimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );

    text20boldWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20negative = TextStyle(      // text negative color
      color: colorBackground,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );

    text22primaryShadow = TextStyle(      // text negative color
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 22,
        shadows: [
          Shadow(
              offset: Offset(1, 1),
              color: Colors.black,
              blurRadius: 1
          ),
        ]
    );
  }

  setAppSettings(){
    if (appSettings.mainColor != null){
      colorPrimary = appSettings.mainColor;
      pref.set(Pref.uiMainColor, appSettings.mainColor.value.toRadixString(16));
      Color _color2 = Color.fromARGB(80, colorPrimary.red, colorPrimary.green, colorPrimary.blue);
      colorsGradient = [_color2, colorPrimary];
    }
    text16UI = TextStyle(
      color: theme.colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: appSettings.restaurantCardTextSize-3,
    );
    text16UIWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: appSettings.restaurantCardTextSize-3,
    );
    theme.text18boldPrimaryUI = TextStyle(
      color: appSettings.restaurantCardTextColor,
      fontWeight: FontWeight.w800,
      fontSize: appSettings.restaurantCardTextSize,
    );
    theme.text18boldPrimaryUIWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: appSettings.restaurantCardTextSize,
    );

    var lid = int.parse(appSettings.appLanguage);
    var user = pref.get(Pref.userSelectLanguage);
    if (user != "true")
      strings.setLang(lid);  // set default language

    appSkin = appSettings.skin;
  }
}

//
// Colors
//
var _backgroundColor = Colors.white;
var _backgroundDarkColor = Colors.black;


const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

const MaterialColor black = const MaterialColor(
  0xFF000000,
  const <int, Color>{
    50: const Color(0xFF000000),
    100: const Color(0xFF000000),
    200: const Color(0xFF000000),
    300: const Color(0xFF000000),
    400: const Color(0xFF000000),
    500: const Color(0xFF000000),
    600: const Color(0xFF000000),
    700: const Color(0xFF000000),
    800: const Color(0xFF000000),
    900: const Color(0xFF000000),
  },
);


