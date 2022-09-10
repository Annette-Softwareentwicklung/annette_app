import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PreferredTheme extends ChangeNotifier {
  PreferredTheme(this._value);
  int _value;
  int get value => _value;

  void setValue (int value) {
    _value = value;
    GetStorage().write('preferredTheme', value);
    notifyListeners();
  }
}