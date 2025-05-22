import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/Services/shared_prefrence.dart';
import 'package:ilearn_papiamento/config/config.dart';
// import 'shared_prefs_service.dart'; // make sure to import your prefs service

class AppSettingsProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  double _speedValue = 0.0;
  bool _isVoiceAuto = false;

  double get speedValue => _speedValue;
  Locale get locale => _locale;
  bool get isVoiceAuto => _isVoiceAuto;

  AppSettingsProvider() {
    fetchLocale();
    loadValue();
    loadAutoVoice();
  }
  //Language change
  Future<void> fetchLocale() async {
    final langCode = SharedPrefsService.getString(AppConfig.language) ?? 'en';
    _locale = Locale(langCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String langCode) async {
    _locale = Locale(langCode);
    await SharedPrefsService.setString(AppConfig.language, langCode);
    notifyListeners();
  }

  //Voice Speed

  Future<void> loadValue() async {
    final saved = SharedPrefsService.getString(AppConfig.voiceSpeed);
    _speedValue = double.tryParse(saved ?? '') ?? 1.0;
    notifyListeners();
  }

  Future<void> updateValue(double newValue) async {
    _speedValue = newValue;
    await SharedPrefsService.setString(
      AppConfig.voiceSpeed,
      newValue.toStringAsFixed(1),
    );
    notifyListeners();
  }

  // Auto Play

  Future<void> loadAutoVoice() async {
    _isVoiceAuto = SharedPrefsService.getBool(AppConfig.autoPlay) ?? true;
    notifyListeners();
  }

  Future<void> updateAutoVoice(bool newValue) async {
    _isVoiceAuto = newValue;
    await SharedPrefsService.setBool(AppConfig.autoPlay, newValue);
    notifyListeners();
  }
}
