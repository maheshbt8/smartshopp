import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping/ui/login/login.dart';
import 'package:shopping/ui/start/splash.dart';
import 'config/api.dart';
import 'config/lang.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config/theme.dart';
import 'model/account.dart';
import 'model/dprint.dart';
import 'model/homescreenModel.dart';
import 'model/pref.dart';
import 'route.dart';

//
// Theme
//
AppThemeData theme = AppThemeData();
//
// Language data
//
Lang strings = Lang();
//
// Routes
//
AppFoodRoute route = AppFoodRoute();
//
// Account
//
Account account = Account();
Pref pref = Pref();
// Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
// const _kShouldTestAsyncErrorOnInit = false;
// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runZonedGuarded(() {
    main2();
  }, FirebaseCrashlytics.instance.recordError);
}

main2(){
  pref.init().then((instance) {
    appSettings.bottomBarType = pref.get(Pref.bottomBarType);

    var dark = pref.get(Pref.uiDarkMode);
    if (dark == "true")
      theme.darkMode = true;
    theme.init();
    var colorMain = pref.get(Pref.uiMainColor);
    if (colorMain.isNotEmpty) {
      theme.colorPrimary = Color(int.parse(colorMain, radix: 16));
      Color _color2 = Color.fromARGB(80, theme.colorPrimary.red, theme.colorPrimary.green, theme.colorPrimary.blue);
      theme.colorsGradient = [_color2, theme.colorPrimary];
    }

    var id = pref.get(Pref.language);
    var lid = Lang.english;
    if (id.isNotEmpty)
      lid = int.parse(id);
    strings.setLang(lid);  // set default language - English
    runApp(AppFoodDelivery());
  });
}

// ignore: must_be_immutable
class AppFoodDelivery  extends StatelessWidget {

  /*
      https://firebase.flutter.dev/docs/crashlytics/usage/
      https://pub.dev/packages/firebase_crashlytics
      https://firebase.flutter.dev/docs/crashlytics/overview/
   */
  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    // Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };

  }

  @override
  Widget build(BuildContext context) {

   _initializeFlutterFire();
    // FirebaseCrashlytics.instance.log("Higgs-Boson detected! Bailing out");

    var _theme = ThemeData(
      fontFamily: 'Raleway',
      primarySwatch: theme.primarySwatch,
      accentColor: theme.colorPrimary,
      textTheme: TextTheme(
          button: TextStyle(color: Colors.black),
      ),
    );

    if (theme.darkMode){
      _theme = ThemeData(
        fontFamily: 'Raleway',
        brightness: Brightness.dark,
        unselectedWidgetColor:Colors.white,
        primarySwatch: theme.primarySwatch,
        textTheme: TextTheme(
        ).apply(
          bodyColor: Colors.white,
        ),
      );
    }

    dprint("Server path: $serverPath");
    dprint(theme.appTypePre);

    return MaterialApp(
      title: strings.get(10),  // "Food smartshopp customer Flutter App UI Kit",
      debugShowCheckedModeBanner: false,
      theme: _theme,
      initialRoute: '/splash',
      routes: {
        '/splash': (BuildContext context) => SplashScreen(),
        '/login': (BuildContext context) => LoginScreen(),
      },
    );
  }
}



