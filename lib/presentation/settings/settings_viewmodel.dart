import 'package:complete_advanced_flutter/app/constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mailto/mailto.dart';
import 'package:open_url/open_url.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/di.dart';
import '../../app/helpers/revenue_cat.dart';
import '../../app/logger_settings.dart';
import '../base/baseviewmodel.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../common/state_renderer/state_renderer.dart';

class SettingsViewModel extends BaseViewModel
    with SettingsVmInput, SettingsVmOutPut {
  RevenueCatHelper _revenueCatHelper = instance<RevenueCatHelper>();

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  likeRateUs() {
    _openUrl(Constant.appUrl);
  }

  @override
  privacyPolicy() {
    _openUrl(Constant.privacyUrl);
  }

  @override
  sendEmail() async {
    print("Send mail");
    final mailtoLink = Mailto(
      to: ['test@gmail.com'],
      subject: '',
      body: '',
    );
    final Uri params = Uri(
      scheme: 'mailto',
      path: Constant.emailSupport,
      query: '', //add subject and body here
    );

    if (!await launchUrl(params, mode: LaunchMode.platformDefault)) {
      throw 'Could not launch $params';
    }
  }

  @override
  shareAiArt() {
    // a link or just text if is an invalid url
    Share.share('check out my ai app', subject: Constant.appUrl);
  }

  @override
  termOfUs() {
    _openUrl(Constant.termOfUsUrl);
  }

  _openUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  restore() async {
    _revenueCatHelper.restoreSubscription().then((purchaseInfo) async {
      if (purchaseInfo.activeSubscriptions.length > 0) {
        logger.i(purchaseInfo.activeSubscriptions.last);
        logger.i(purchaseInfo.latestExpirationDate);
        DateTime latestsExpDate = DateTime.parse(
            purchaseInfo.latestExpirationDate ?? DateTime.now().toString());

        String formattedDate = DateFormat.yMMMEd().format(latestsExpDate);
        print(formattedDate);

        inputState.add(SuccessState(
            "Your Subscription is 6 Month\n renews on$formattedDate"));
        // _subscriptionViewModel.showAlert("Succces");
      } else {
        inputState.add(ErrorState(StateRendererType.POPUP_ERROR_STATE,
            "You dont Have Active Subscription"));
        // _subscriptionViewModel.subScribeFail();
      }
    });
  }
}

abstract class SettingsVmInput {
  shareAiArt();
  likeRateUs();
  termOfUs();
  privacyPolicy();
  sendEmail();
  restore();
}

abstract class SettingsVmOutPut {}
