import 'package:flutter/material.dart';

ThemeData darktheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xff212224),
    textTheme: TextTheme(
      headline4: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
      headline5: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w200),
    ),
  );
}

ThemeData lighttheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      headline4: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
      headline5: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w200),
    ),
  );
}