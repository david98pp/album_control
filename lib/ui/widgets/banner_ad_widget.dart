import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../utils/ad_device.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  @override
  void didChangeDependencies() {
    // Create the ad objects and load ads.
    _bannerAd = BannerAd(
      size: AdSize.banner,
      request: const AdRequest(),
      adUnitId: AdDevice.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() => _bannerAdIsLoaded = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    )..load();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BannerAd? bannerAd = _bannerAd;
    if (_bannerAdIsLoaded && bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        child: AdWidget(ad: bannerAd),
        width: bannerAd.size.width.toDouble(),
        height: bannerAd.size.height.toDouble(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
