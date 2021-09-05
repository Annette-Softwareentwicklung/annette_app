import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO: implement textThemes

class Design {
  static double standardPagePadding = 10.0;


  static ThemeData darkTheme = ThemeData(
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),

          textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(
            fontSize: 17,
          )),

        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.lightBlueAccent),
          foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black),
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
      buttonTheme: ButtonThemeData(buttonColor: Colors.lightBlueAccent),
      accentColor: Colors.lightBlueAccent,
      snackBarTheme: SnackBarThemeData(
          contentTextStyle: TextStyle(
            color: Colors.white,
          )
      ),
    );

  static ThemeData lightTheme = ThemeData(
      snackBarTheme: SnackBarThemeData(
          contentTextStyle: TextStyle(
            color: Colors.white,
          )
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.black87),

          textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(
            fontSize: 17,
          )),

        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
        ),
      ),
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