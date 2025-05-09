import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

  AdsProvider() {
    _initBannerAd();
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  // ─── Banner Ad Init ─────────────────────────────────────────────────────────
  void _initBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AppConfig.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isBannerLoaded = true;
          notifyListeners();
          debugPrint('BannerAd loaded');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('BannerAd failed: $error');
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  // ─── Interstitial Ad ────────────────────────────────────────────────────────
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AppConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoaded = true;
          // set up lifecycle callbacks
          ad.setImmersiveMode(true);
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialLoaded = false;
              _loadInterstitialAd(); // preload next
              notifyListeners();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isInterstitialLoaded = false;
              _loadInterstitialAd();
              debugPrint('Interstitial failed to show: $error');
            },
          );
          notifyListeners();
          debugPrint('InterstitialAd loaded');
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: $error');
          _isInterstitialLoaded = false;
          // you might retry with a delay here
        },
      ),
    );
  }

  /// Call this to show an interstitial if loaded.
  void showInterstitialAd() {
    if (_isInterstitialLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      debugPrint('InterstitialAd is not ready yet.');
    }
  }

  // ─── Rewarded Ad ────────────────────────────────────────────────────────────
  void _loadRewardedAd() {
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
              debugPrint('RewardedAd failed to show: $error');
            },
          );
          notifyListeners();
          debugPrint('RewardedAd loaded');
        },
        onAdFailedToLoad: (error) {
          debugPrint('RewardedAd failed to load: $error');
          _isRewardedLoaded = false;
          // optional retry logic
        },
      ),
    );
  }

  /// Call this to show a rewarded ad.
  /// [onUserEarnedReward] is your callback to actually grant the user their reward.
  void showRewardedAd({
    required OnUserEarnedRewardCallback onUserEarnedReward,
  }) {
    if (_isRewardedLoaded && _rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: onUserEarnedReward);
    } else {
      debugPrint('RewardedAd is not ready yet.');
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }
}
