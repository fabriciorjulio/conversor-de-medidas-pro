import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

abstract class AdManagerInterface {
  Future<BannerAd?> createBannerAd();
  Future<InterstitialAd?> loadInterstitialAd();
  void showInterstitialAd(InterstitialAd ad);
}

class AdManager implements AdManagerInterface {
  static const String _testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  
  String get _bannerAdUnitId {
    const appId = String.fromEnvironment('ADMOB_APP_ID');
    if (appId.isEmpty || kDebugMode) {
      return _testBannerAdUnitId;
    }
    return const String.fromEnvironment('ADMOB_BANNER_ID', defaultValue: _testBannerAdUnitId);
  }
  
  String get _interstitialAdUnitId {
    const appId = String.fromEnvironment('ADMOB_APP_ID');
    if (appId.isEmpty || kDebugMode) {
      return _testInterstitialAdUnitId;
    }
    return const String.fromEnvironment('ADMOB_INTERSTITIAL_ID', defaultValue: _testInterstitialAdUnitId);
  }

  @override
  Future<BannerAd?> createBannerAd() async {
    try {
      final bannerAd = BannerAd(
        adUnitId: _bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) => debugPrint('Banner ad loaded'),
          onAdFailedToLoad: (ad, error) {
            debugPrint('Banner ad failed to load: $error');
            ad.dispose();
          },
        ),
      );
      
      await bannerAd.load();
      return bannerAd;
    } catch (e) {
      debugPrint('Erro ao criar banner ad: $e');
      return null;
    }
  }

  @override
  Future<InterstitialAd?> loadInterstitialAd() async {
    try {
      InterstitialAd? interstitialAd;
      
      await InterstitialAd.load(
        adUnitId: _interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
            debugPrint('Interstitial ad loaded');
          },
          onAdFailedToLoad: (error) {
            debugPrint('Interstitial ad failed to load: $error');
          },
        ),
      );
      
      return interstitialAd;
    } catch (e) {
      debugPrint('Erro ao carregar interstitial ad: $e');
      return null;
    }
  }

  @override
  void showInterstitialAd(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('Interstitial ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('Interstitial ad dismissed');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial ad failed to show: $error');
        ad.dispose();
      },
    );
    
    ad.show();
  }
}