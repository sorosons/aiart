import 'dart:io' show Platform;

import 'package:complete_advanced_flutter/app/logger_settings.dart';

class Constant {
  static const String baseUrl = "https://lexica.art/api/v1/search";
  static const String token = "get api token here";

  static const String privacyUrl =
      "your_privacy_url";
  static const String termOfUsUrl =
      "term_of_us_url";
  static const String emailSupport = "support@gmail.com";
  // add the API key for your app from the RevenueCat dashboard: https://app.revenuecat.com
  // static const apiKey = 'revenuecatApiKEy';

  static String get apiKey {
    if (Platform.isAndroid) {
      return "Apikey_Android";
    } else {
      
      return "Apikey_IOS";
    }
  }

  static String get entitlementID {
    if (Platform.isAndroid) {
      return "monthly";
    } else {
      return "monthly";
    }
  }

  static String get appUrl {
    logger.e("isAndroid");
    logger.e(Platform.isAndroid);
    if (Platform.isAndroid) {
      return "google_play_url";
    } else {
      return "apple_store_url";
    }
  }
}

class AppData {
  static final AppData _appData = AppData._internal();

  bool entitlementIsActive = false;
  String appUserID = '';

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();

class CustomException implements Exception {
  String cause;
  CustomException(this.cause);
}
