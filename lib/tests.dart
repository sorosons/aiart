import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'app/helpers/firebase_remote.dart';
import 'app/logger_settings.dart';

main() async {
  FirebaseRemoteConfig _firebaseRemoteConfig =
      await FirebaseRemoteConfig.instance;
  FiBaseRemoteConfig _f = FiBaseRemoteConfig(_firebaseRemoteConfig);
  var xx = _f.getValue();
  logger.e("mm");
  logger.e(xx);
}
