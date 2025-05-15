import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:ilearn_papiamento/config/config.dart';

class AdsProvider with ChangeNotifier {
  // ─── Banner Ad ─────────────────────────────────────────────────────────────
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  BannerAd? get bannerAd => _bannerAd;
  bool get isBannerLoaded => _isBannerLoaded;

  // ─── Interstitial Ad ────────────────────────────────────────────────────────
  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoaded = false;
  bool get isInterstitialLoaded => _isInterstitialLoaded;

  // ─── Rewarded Ad ────────────────────────────────────────────────────────────
  RewardedAd? _rewardedAd;
  bool _isRewardedLoaded = false;
  bool get isRewardedLoaded => _isRewardedLoaded;

  // ─── Connectivity ───────────────────────────────────────────────────────────
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connSub;

  AdsProvider() {
    _connSub = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
    _attemptLoadIfOnline();
  }

  Future<void> _onConnectivityChanged(List<ConnectivityResult> result) async {
    if (result[0] != ConnectivityResult.none) {
      await _attemptLoadIfOnline();
    }
  }

  /// Returns true only if we can reach a real endpoint.
  Future<bool> _hasInternet({int timeoutSeconds = 3}) async {
    try {
      final uri = Uri.https('www.google.com', '/');
      final resp = await http
          .head(uri)
          .timeout(Duration(seconds: timeoutSeconds));
      return resp.statusCode == HttpStatus.ok ||
          resp.statusCode == HttpStatus.found;
    } catch (_) {
      return false;
    }
  }

  Future<void> _attemptLoadIfOnline() async {
    if (await _hasInternet()) {
      _tryLoadAllAds();
    } else {
      debugPrint('No actual Internet—skipping ad load/retry');
    }
  }

  void _tryLoadAllAds() {
    if (!_isBannerLoaded) _initBannerAd();
    if (!_isInterstitialLoaded) _loadInterstitialAd();
    if (!_isRewardedLoaded) _loadRewardedAd();
  }

  void _initBannerAd() {
    _bannerAd?.dispose();
    _isBannerLoaded = false;
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AppConfig.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isBannerLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _isBannerLoaded = false;
          debugPrint('Banner failed: $error');
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  void _loadInterstitialAd() {
    _interstitialAd?.dispose();
    _isInterstitialLoaded = false;
    InterstitialAd.load(
      adUnitId: AppConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoaded = true;
          ad.setImmersiveMode(true);
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialLoaded = false;
              _loadInterstitialAd();
              notifyListeners();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isInterstitialLoaded = false;
              _loadInterstitialAd();
            },
          );
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          _isInterstitialLoaded = false;
          debugPrint('Interstitial failed: $error');
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isInterstitialLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
    }
  }

  void _loadRewardedAd() {
    _rewardedAd?.dispose();
    _isRewardedLoaded = false;
    RewardedAd.load(
      adUnitId: AppConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoaded = true;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isRewardedLoaded = false;
              _loadRewardedAd();
              notifyListeners();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isRewardedLoaded = false;
              _loadRewardedAd();
            },
          );
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          _isRewardedLoaded = false;
          debugPrint('Rewarded failed: $error');
        },
      ),
    );
  }

  void showRewardedAd({
    required OnUserEarnedRewardCallback onUserEarnedReward,
  }) {
    if (_isRewardedLoaded && _rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: onUserEarnedReward);
    }
  }

  @override
  void dispose() {
    _connSub?.cancel();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }
}
