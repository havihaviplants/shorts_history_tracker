import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  static BannerAd? _bannerAd;

  static void initialize() {
    MobileAds.instance.initialize();
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // 테스트 광고 ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print('✅ 광고 로드 완료: ${ad.adUnitId}'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('❌ 광고 로드 실패: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  static Widget showBannerAd() {
    if (_bannerAd == null) {
      return SizedBox.shrink(); // 광고가 없을 경우 빈 공간 반환
    }
    return Container(
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
    );
  }
}
