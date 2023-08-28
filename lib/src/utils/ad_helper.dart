import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6292940785583509/6364326663';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
