import 'package:flutter/material.dart';

class ControlAdsProvider extends ChangeNotifier {
  int numberOfCateOpen = 0;

  void incrementCatViews() {
    if (numberOfCateOpen >= 2) {
      numberOfCateOpen = 0;
    } else {
      numberOfCateOpen++;
    }
    notifyListeners();
  }
}
