import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/admob_service.dart';

/// Widget to display AdMob banner ads
class AdMobBannerWidget extends StatefulWidget {
  final AdSize adSize;
  final EdgeInsets? margin;

  const AdMobBannerWidget({Key? key, this.adSize = AdSize.banner, this.margin})
    : super(key: key);

  @override
  State<AdMobBannerWidget> createState() => _AdMobBannerWidgetState();
}

class _AdMobBannerWidgetState extends State<AdMobBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  final AdMobService _adMobService = AdMobService();

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _adMobService.bannerAdUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('✅ Banner ad loaded successfully');
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          print('⚠️ Banner ad failed to load: $error');
          ad.dispose();
          if (mounted) {
            setState(() {
              _isAdLoaded = false;
              _bannerAd = null;
            });
          }
        },
        onAdOpened: (ad) {
          print('📱 Banner ad opened');
        },
        onAdClosed: (ad) {
          print('❌ Banner ad closed');
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded || _bannerAd == null) {
      // Show placeholder while ad loads
      return Container(
        margin: widget.margin,
        height: widget.adSize.height.toDouble(),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: widget.margin,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
