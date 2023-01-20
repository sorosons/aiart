import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../constant.dart';
import '../logger_settings.dart';

class RevenueCatHelper {
  //Init RevenueCat
  Future<void> initRevenueCat() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setDebugLogsEnabled(true);
    print("AA");
    // PurchasesConfiguration(Constant.apiKey);
    await Purchases.setup(Constant.apiKey,
        appUserId: null, observerMode: false);

    appData.appUserID = await Purchases.appUserID;
  }

  // Get Available Package List
  Future<Offerings?> getOfferings() async {
    Offerings? offerings;
    Purchases.addCustomerInfoUpdateListener((purchaserInfo) async {
      appData.appUserID = await Purchases.appUserID;
      CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();

      (purchaserInfo.entitlements.all[Constant.entitlementID] != null &&
              purchaserInfo.entitlements.all[Constant.entitlementID]!.isActive)
          ? appData.entitlementIsActive = true
          : appData.entitlementIsActive = false;
    });
    CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();

    if (purchaserInfo.entitlements.all[Constant.entitlementID] != null &&
        purchaserInfo.entitlements.all[Constant.entitlementID]!.isActive ==
            true) {
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        print(e.message.toString());
      }
    } else {
      // Offerings? offerings;

      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        print(e.message.toString());
      }

      if (offerings == null || offerings!.current == null) {
        // offerings are empty, show a message to your user
        print("offer is empty");
      } else {
        // current offering is available, show paywall

      }
    }

    return offerings;
  }

  Future<CustomerInfo> restoreSubscription() async {
    late CustomerInfo purchaserInfo;
    try {
      //purchaserInfo = await Purchases.getCustomerInfo();
      purchaserInfo = await Purchases.restorePurchases();

      //logger.wtf(xxx.activeSubscriptions.length);
      // access latest purchaserInfo
      logger.i("active Subs");
      logger.i(purchaserInfo.activeSubscriptions.toString() +
          "expiration date" +
          purchaserInfo.latestExpirationDate.toString());
    } on PlatformException catch (e) {
      // Error fetching purchaser info
      logger.e("active Subs Error:" + e.message.toString());
    }

    return purchaserInfo;
  }
}
