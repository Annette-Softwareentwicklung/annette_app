import 'package:flutter/material.dart';

class ProgressPercentage extends ChangeNotifier{
  ProgressPercentage(this._value);
  int _value;
  int get value => _value;

  void setValue (int value) {
    _value = value;
    notifyListeners();
  }
}