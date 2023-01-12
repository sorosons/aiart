import 'package:complete_advanced_flutter/app/di.dart';
import 'package:complete_advanced_flutter/presentation/main/main_view.dart';
import 'package:complete_advanced_flutter/presentation/onboarding/onboarding.dart';

import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter/presentation/resultpage/result_page.dart';
import 'package:complete_advanced_flutter/presentation/settings/settings_view.dart';
import 'package:complete_advanced_flutter/presentation/splash/splash.dart';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../app/logger_settings.dart';
import '../premium/prmeium_view.dart';

class Routes {
  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onBoarding";
  static const String mainPage = "/mainview";
  static const String resultPage = "/resultPage";
  static const String settingsPage = "/settings";
  static const String premiumPage = "/premiumPage";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        initSplashModule();
        return MaterialPageRoute(builder: (_) => SplashView());

      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => OnBoardingView());

      case Routes.mainPage:
        initMainView();
        return MaterialPageRoute(builder: (_) => MainView());

      case Routes.resultPage:
        logger.wtf("initRESULTTTT");

        initResultModule();
        return MaterialPageRoute(builder: (_) => ResultPage());

      case Routes.settingsPage:
        initSettingsModule();
        return MaterialPageRoute(builder: (_) => SettingsView());

      case Routes.premiumPage:
        initPremiumModule();
        return MaterialPageRoute(builder: (_) => PremiumView());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(AppStrings.noRouteFound).tr(),
              ),
              body: Center(child: Text(AppStrings.noRouteFound).tr()),
            ));
  }
}
