import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Service to manage Google AdMob ads
class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  // Production Ad IDs (App ID is configured in AndroidManifest.xml)
  static const String _androidInterstitialAdId =
      'ca-app-pub-2744970719381152/8855043572';
  static const String _androidBannerAdId =
      'ca-app-pub-2744970719381152/8591319698';

  // Test Ad IDs (for development)
  static const String _testInterstitialAdId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testBannerAdId =
      'ca-app-pub-3940256099942544/6300978111';

  // Use test ads during development, production ads in release
  static const bool _useTestAds = false; // Set to false for production

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  int _numInterstitialLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;

  /// Initialize the Mobile Ads SDK
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();

    // Set request configuration for test devices (optional)
    final RequestConfiguration requestConfiguration = RequestConfiguration(
      testDeviceIds: ['YOUR_TEST_DEVICE_ID'], // Add your test device ID here
    );
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);

    print('✅ AdMob SDK initialized successfully');
  }

  /// Get the appropriate interstitial ad unit ID based on platform and environment
  String get _interstitialAdUnitId {
    if (_useTestAds) {
      return _testInterstitialAdId;
    }

    if (Platform.isAndroid) {
      return _androidInterstitialAdId;
    }

    // iOS not configured yet
    throw UnsupportedError('Platform not supported');
  }

  /// Get the appropriate banner ad unit ID based on platform and environment
  String get bannerAdUnitId {
    if (_useTestAds) {
      return _testBannerAdId;
    }

    if (Platform.isAndroid) {
      return _androidBannerAdId;
    }

    // iOS not configured yet
    throw UnsupportedError('Platform not supported');
  }

  /// Load an interstitial ad
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('✅ Interstitial ad loaded successfully');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _isInterstitialAdReady = true;

          // Set up full screen content callback
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
                onAdShowedFullScreenContent: (InterstitialAd ad) {
                  print('📱 Interstitial ad showed full screen content');
                },
                onAdDismissedFullScreenContent: (InterstitialAd ad) {
                  print('❌ Interstitial ad dismissed');
                  ad.dispose();
                  _isInterstitialAdReady = false;
                  // Preload next ad
                  loadInterstitialAd();
                },
                onAdFailedToShowFullScreenContent:
                    (InterstitialAd ad, AdError error) {
                      print('⚠️ Interstitial ad failed to show: $error');
                      ad.dispose();
                      _isInterstitialAdReady = false;
                      // Preload next ad
                      loadInterstitialAd();
                    },
              );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('⚠️ Interstitial ad failed to load: $error');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          _isInterstitialAdReady = false;

          // Retry loading with exponential backoff
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            Future.delayed(
              Duration(seconds: _numInterstitialLoadAttempts * 2),
              loadInterstitialAd,
            );
          }
        },
      ),
    );
  }

  /// Show interstitial ad if ready
  Future<bool> showInterstitialAd() async {
    if (!_isInterstitialAdReady || _interstitialAd == null) {
      print('⚠️ Interstitial ad not ready yet');
      // Try to load ad for next time
      loadInterstitialAd();
      return false;
    }

    await _interstitialAd!.show();
    _isInterstitialAdReady = false;
    return true;
  }

  /// Check if interstitial ad is ready to show
  bool isInterstitialAdReady() {
    return _isInterstitialAdReady && _interstitialAd != null;
  }

  /// Dispose of ads when no longer needed
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdReady = false;
  }

  /// Preload ads for better user experience
  void preloadAds() {
    loadInterstitialAd();
  }
}
