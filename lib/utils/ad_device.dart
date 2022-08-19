import 'dart:io';

class AdDevice {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4222385572650413/4639911296";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/2934735716";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
