import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

/// Service to manage Google AdMob ads
class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  // Production Ad IDs
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
  static const bool _useTestAds = false;

  // Daily interstitial limit
  static const String _lastInterstitialDateKey = 'last_interstitial_date';
  static const String _interstitialCountKey = 'interstitial_count_today';
  static const int _maxInterstitialsPerDay = 1;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  int _numInterstitialLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;

  /// Initialize the Mobile Ads SDK
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
    debugPrint('AdMob SDK initialized successfully');
  }

  /// Get the appropriate interstitial ad unit ID
  String get _interstitialAdUnitId {
    if (_useTestAds) return _testInterstitialAdId;
    if (Platform.isAndroid) return _androidInterstitialAdId;
    throw UnsupportedError('Platform not supported');
  }

  /// Get the appropriate banner ad unit ID
  String get bannerAdUnitId {
    if (_useTestAds) return _testBannerAdId;
    if (Platform.isAndroid) return _androidBannerAdId;
    throw UnsupportedError('Platform not supported');
  }

  /// Check if we can show an interstitial ad today (max 1 per day)
  Future<bool> _canShowInterstitialToday() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final lastDate = prefs.getString(_lastInterstitialDateKey) ?? '';
      final count = prefs.getInt(_interstitialCountKey) ?? 0;

      if (lastDate != today) {
        // New day — reset counter
        await prefs.setString(_lastInterstitialDateKey, today);
        await prefs.setInt(_interstitialCountKey, 0);
        return true;
      }

      return count < _maxInterstitialsPerDay;
    } catch (e) {
      debugPrint('Error checking daily ad limit: $e');
      return false;
    }
  }

  /// Record that an interstitial ad was shown today
  Future<void> _recordInterstitialShown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await prefs.setString(_lastInterstitialDateKey, today);
      final count = prefs.getInt(_interstitialCountKey) ?? 0;
      await prefs.setInt(_interstitialCountKey, count + 1);
    } catch (e) {
      debugPrint('Error recording ad shown: $e');
    }
  }

  /// Load an interstitial ad
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('Interstitial ad loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _isInterstitialAdReady = true;

          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
                onAdDismissedFullScreenContent: (InterstitialAd ad) {
                  ad.dispose();
                  _isInterstitialAdReady = false;
                  loadInterstitialAd();
                },
                onAdFailedToShowFullScreenContent:
                    (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      _isInterstitialAdReady = false;
                      loadInterstitialAd();
                    },
              );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Interstitial ad failed to load: $error');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          _isInterstitialAdReady = false;

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

  /// Show interstitial ad if ready AND within daily limit (max 1/day)
  Future<bool> showInterstitialAd() async {
    // Check daily limit first
    final canShow = await _canShowInterstitialToday();
    if (!canShow) {
      debugPrint(
        'Interstitial ad daily limit reached (max $_maxInterstitialsPerDay/day)',
      );
      return false;
    }

    if (!_isInterstitialAdReady || _interstitialAd == null) {
      loadInterstitialAd();
      return false;
    }

    await _interstitialAd!.show();
    _isInterstitialAdReady = false;
    await _recordInterstitialShown();
    debugPrint('Interstitial ad shown — daily count updated');
    return true;
  }

  /// Check if interstitial ad is ready to show
  bool isInterstitialAdReady() {
    return _isInterstitialAdReady && _interstitialAd != null;
  }

  /// Dispose of ads
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
