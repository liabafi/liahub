import 'package:flutter/material.dart';
import 'sharedPref.dart';

class ThemeNotifier with ChangeNotifier {

  String thm = "B";

  static final ThemeData lightTheme = ThemeData(
    textTheme: TextTheme(
        headline4: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      headline1: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 15,
      )
    ),
    fontFamily: "SF",
    primarySwatch: Colors.blueGrey,
    backgroundColor: Colors.white.withOpacity(0.15), //Control Center
    cardColor: Colors.black.withOpacity(0.0), //Control Center item border, font color
    splashColor: Colors.black.withOpacity(0.2), //Control Center border
    shadowColor: Colors.black.withOpacity(0.15), //Control Center outer border
    accentColor: Colors.black.withOpacity(.15), //shadow color
    focusColor: Colors.white.withOpacity(0.4), //docker color
    canvasColor: Colors.blue.withOpacity(0.4), //fileMenu Color
    scaffoldBackgroundColor: Colors.white, //window Color
    hintColor: Colors.white.withOpacity(0.6), //window transparency Color
    dividerColor: Color(0xff3a383e), // Safari Window color

    primaryTextTheme: TextTheme(
      button: TextStyle(
        color: Colors.blueGrey,
        decorationColor: Colors.blueGrey[300],
      ),
      subtitle1: TextStyle(
        color: Colors.black,
      ),
    ),
    bottomAppBarColor: Colors.blueGrey[900],
    iconTheme: IconThemeData(color: Colors.blueGrey),
    buttonColor: Colors.black.withOpacity(0.13), //darkMode button

  );

  static final ThemeData darkTheme = ThemeData(
    textTheme: TextTheme(
      headline4: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        fontFamily: "SF"
      ),
        headline1: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        )

    ),
    fontFamily: "SF",
    primarySwatch: Colors.deepPurple,
      backgroundColor: Color(0xff2b2b2b).withOpacity(.05), //Control Center
    cardColor: Colors.white.withOpacity(0.15), //Control Center item border, font color

      splashColor: Colors.black.withOpacity(0.4), //Control Center border
      shadowColor: Colors.black.withOpacity(0.3), //Control Center outer border
      accentColor: Colors.black.withOpacity(.2), //shadow color
      focusColor: Color(0xff3e3232).withOpacity(0.2), //docker color
      canvasColor: Colors.black.withOpacity(0.3), //fileMenu Color
      scaffoldBackgroundColor: Color(0xff242127), //Finder window Color
      dividerColor: Color(0xff3a383e), // Safari Window color
      hintColor: Color(0xff242127).withOpacity(0.3), //window transparency Color
      primaryTextTheme: TextTheme(
      button: TextStyle(
        color: Colors.blueGrey[200],
        decorationColor: Colors.blueGrey[50],
      ),
      subtitle1: TextStyle(
        color: Colors.blueGrey[300],
      ),
    ),
    bottomAppBarColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.blueGrey[200]),
      buttonColor: Colors.white //darkMode button
  );

  ThemeData _themeData;
  ThemeNotifier(this._themeData);
  getTheme() => _themeData;
  String get findThm => thm;

  isDark() => _themeData==lightTheme?false:true;


  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    thm=(themeData==lightTheme)?"B":"B";
    notifyListeners();
  }

  // ThemeNotifier() {
  //   StorageManager.readData('themeMode').then((value) {
  //     print('value read from storage: ' + value.toString());
  //     themeMode = value ?? 'light';
  //     if (themeMode == 'light') {
  //       _themeData = lightTheme;
  //      // dark=false;
  //     } else {
  //       print('setting dark theme');
  //       _themeData = darkTheme;
  //      //dark=true;
  //     }
  //     notifyListeners();
  //   });
  // }
  //
  //
  //
  // void setDarkMode() async {
  //   _themeData = darkTheme;
  //   StorageManager.saveData('themeMode', 'dark');
  //   notifyListeners();
  // }
  //
  // void setLightMode() async {
  //   _themeData = lightTheme;
  //   StorageManager.saveData('themeMode', 'light');
  //   notifyListeners();
  //
  // }

}