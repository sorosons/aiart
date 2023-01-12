import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/domain/model/init_model.dart';
import 'package:complete_advanced_flutter/domain/repository/repository.dart';
import 'package:complete_advanced_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../app/functions.dart';
import '../model/model.dart';

class InitUserUseCase extends BaseUseCase {
  Repository _repository;
  InitUserUseCase(this._repository);

  @override
  Future<Either<Failure, InitModel>> execute(void input) async {
    DeviceInfo deviceInfo = await getDeviceDetails();
    print("Device Info:" + deviceInfo.toString());

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("Device token:" + fcmToken.toString());

    return _repository.initUser(
        InitUserRequest(deviceInfo.identifier, fcmToken ?? "token is null"));
  }
}
