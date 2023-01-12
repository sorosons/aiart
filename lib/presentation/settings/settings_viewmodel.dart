import 'package:complete_advanced_flutter/app/constant.dart';
import 'package:mailto/mailto.dart';
import 'package:open_url/open_url.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../base/baseviewmodel.dart';

class SettingsViewModel extends BaseViewModel
    with SettingsVmInput, SettingsVmOutPut {
  @override
  void start() {
    // TODO: implement start
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
}

abstract class SettingsVmInput {
  shareAiArt();
  likeRateUs();
  termOfUs();
  privacyPolicy();
  sendEmail();
}

abstract class SettingsVmOutPut {}
