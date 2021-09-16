import 'package:flutter/material.dart';

class LoadingInformation extends ChangeNotifier{
  LoadingInformation(this._value);
  bool _value;
  bool get value => _value;

  void setValue (bool value) {
    _value = value;
    notifyListeners();
  }
}