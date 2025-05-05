import 'package:flutter/material.dart';

class AppLanguage extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  void changeLanguage(String langCode) {
    _locale = Locale(langCode);
    notifyListeners();
  }
}
