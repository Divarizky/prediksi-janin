import 'package:flutter/material.dart';

class IconKataSandi extends ChangeNotifier{
  bool isvisible = false;

  void changeVisible(bool a)  {
    isvisible = !a;
    print(a);
    notifyListeners();
  }
}