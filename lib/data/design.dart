import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO: implement textThemes

class Design {
  static Color annetteColor = Color.fromRGBO(72, 146, 151, 1);
  static Color annetteColorLight = Color.fromRGBO(0, 156, 170, 1);
  static double standardPagePadding = 15.0;
  static LinearGradient lightGradient =
      LinearGradient(colors: [annetteColor, annetteColor]);
  static LinearGradient darkGradient =
      LinearGradient(colors: [annetteColor, annetteColor]);

  static ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Colors.black38,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(fontSize: 20),
      // backgroundColor: Colors.black45,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith(
            (states) => annetteColorLight.withOpacity(0.1)),
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
            overlayColor: MaterialStateProperty.resolveWith(
                (states) => annetteColorLight.withOpacity(0.1)),
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
    buttonTheme: ButtonThemeData(
      buttonColor: annetteColor,
    ),
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: annetteColor, brightness: Brightness.dark),
    snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(
      color: Colors.white,
    )),
  );

  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: annetteColor, fontSize: 20, fontWeight: FontWeight.w600),
        iconTheme: IconThemeData(color: annetteColor)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: annetteColor,
    ),
    snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(
      color: Colors.white,
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith(
            (states) => annetteColorLight.withOpacity(0.1)),
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
            overlayColor: MaterialStateProperty.resolveWith(
                (states) => annetteColorLight.withOpacity(0.1)),
            foregroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.black))),
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: Brightness.light,
      secondary: Colors.black54,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: annetteColor, foregroundColor: Colors.white),
    cardColor: Colors.grey[200],
  );
}
