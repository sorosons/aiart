import 'dart:io' show Platform;

import 'package:complete_advanced_flutter/app/logger_settings.dart';

class Constant {
  static const String baseUrl = "https://lexica.art/api/v1/search";
  static const String token = "get api token here";

  static const String privacyUrl =
      "https://docs.google.com/document/d/1w98rDEJ9xMGs4m_DOZrOJQAIz42gfznpV8prAG8M3go";
  static const String termOfUsUrl =
      "https://docs.google.com/document/d/1w98rDEJ9xMGs4m_DOZrOJQAIz42gfznpV8prAG8M3go";
  static const String emailSupport = "gumuseyhmus@gmail.com";
  // add the API key for your app from the RevenueCat dashboard: https://app.revenuecat.com
  // static const apiKey = 'hGEbeLEdMxaYTpuEotstStjNdjBicAwq';

  static String get apiKey {
    if (Platform.isAndroid) {
      return "goog_dtVTIOFMByyHOTYaGopresvajHT";
    } else {
      logger.i("I AM IOS");
      return "appl_szRiPgBrezlHZRSBqdYnGRqAnwC";
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
      return "https://play.google.com/store/apps/details?id=com.sorosons.airart";
    } else {
      return "https://apps.apple.com/us/app/ai-art-draw-picture/id6444043389";
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
