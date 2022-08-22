import 'dart:io';

class AdDevice {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4222385572650413/3334831819";
    } else if (Platform.isIOS) {
      return "ca-app-pub-4222385572650413/9282552242";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
