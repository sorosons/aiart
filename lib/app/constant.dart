import 'dart:io' show Platform;

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
  static const apiKey = 'appl_szRiPgBrezlHZRSBqdYnGRqAnwC';

//TO DO: add the entitlement ID from the RevenueCat dashboard that is activated upon successful in-app purchase for the duration of the purchase.
//const entitlementID = 'week';
  static const entitlementID = 'monthly';

  static String get appUrl {
    if (Platform.isAndroid) {
      return "https://play.google.com/store/apps/details?id=com.instly";
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
