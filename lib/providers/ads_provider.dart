import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ilearn_papiamento/config/config.dart';

class AdsProvider with ChangeNotifier {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  BannerAd? get bannerAd => _bannerAd;
  bool get isLoaded => _isLoaded;

  AdsProvider() {
    _initBannerAd();
  }

  void _initBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AppConfig.adsId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _isLoaded = true;
          notifyListeners();
          // print('ddddd');
          debugPrint('BannerAd loaded');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('BannerAd failed to load: $error');
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
