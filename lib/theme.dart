import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.white))),
    brightness: Brightness.dark,
    cupertinoOverrideTheme: CupertinoThemeData(
      textTheme: CupertinoTextThemeData(
        dateTimePickerTextStyle: TextStyle(color: Colors.white),
      ),
    ),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(foregroundColor: Colors.black),
    //buttonTheme: ButtonThemeData(buttonColor: Colors.tealAccent),
    buttonTheme: ButtonThemeData(buttonColor: Colors.lightBlueAccent),
    accentColor: Colors.lightBlueAccent,
  );
}

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.black))),
    brightness: Brightness.light,
    accentColor: Colors.black54,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.blue, foregroundColor: Colors.white),
  );
}
