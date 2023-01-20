import 'package:complete_advanced_flutter/app/logger_settings.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';

class FiBaseRemoteConfig {
  FirebaseRemoteConfig _fiBaseRemoteConfig;
  FiBaseRemoteConfig(this._fiBaseRemoteConfig);

  Future<void> SetRemoteConfigSettings() async {
    try {
      // Using zero duration to force fetching from remote server.
      await _fiBaseRemoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await _fiBaseRemoteConfig.fetchAndActivate();
    } on PlatformException catch (exception) {
      // Fetch exception.
      logger.e("fb Exception:" + exception.message.toString());
      print(exception);
    } catch (exception) {
      logger.e("exception Exception:" + exception.toString());
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
      print(exception);
      throw new FormatException();
    }

    await _fiBaseRemoteConfig.setDefaults(<String, bool>{
      'useApi': false,
    });
  }

  //"qrShareLinkFollowa"
  Future<bool> getValue() async {
    SetRemoteConfigSettings();
    return _fiBaseRemoteConfig.getBool("useApi");
  }
}
