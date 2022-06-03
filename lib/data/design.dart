import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO: implement textThemes

class Design {
  static Color annetteColor = Color.fromRGBO(0, 136, 148, 1);
  static double standardPagePadding = 10.0;
  static LinearGradient lightGradient = LinearGradient(colors: [
    Color.fromRGBO(0, 136, 148, 1),
    Color.fromRGBO(10, 91, 99, 1) //Color.fromRGBO(14, 46, 64, 1)
  ]);
  static LinearGradient darkGradient = LinearGradient(colors: [
    Color.fromRGBO(0, 136, 148, 1),
    Color.fromRGBO(10, 91, 99, 1) //Color.fromRGBO(14, 46, 64, 1)
  ]);

  static ThemeData darkTheme = ThemeData(
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.resolveWith((states) => Colors.white),
        textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(
              fontSize: 17,
            )),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
          (states) => annetteColor,
        ),
        foregroundColor:
            MaterialStateColor.resolveWith((states) => Colors.black),
      ),
    ),
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
    buttonTheme: ButtonThemeData(
      buttonColor: annetteColor,
    ),
    accentColor: annetteColor,
    snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(
      color: Colors.white,
    )),
  );

  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: annetteColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: annetteColor,
    ),
    snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(
      color: Colors.white,
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.resolveWith((states) => Colors.black87),
        textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(
              fontSize: 17,
            )),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
          (states) => annetteColor,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.black))),
    brightness: Brightness.light,
    accentColor: Colors.black54,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: annetteColor, foregroundColor: Colors.white),
  );
}
