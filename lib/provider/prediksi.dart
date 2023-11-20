import 'package:flutter/material.dart';

class PrediksiProvider extends ChangeNotifier {
  String _result = "";

  String get result => _result;

  void setResult(String newResult){
    _result = newResult;

    notifyListeners();
  }
}
