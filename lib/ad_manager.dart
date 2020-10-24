import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2058901559705445~3867017300";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2058901559705445~8228579229";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2058901559705445/9634365211";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2058901559705445/7715325029";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2058901559705445/3428033601";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2058901559705445/3248949481";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
