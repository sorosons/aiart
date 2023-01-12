import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/data/responses/init_response.dart';
import 'package:dartz/dartz.dart';

import '../model/image_model.dart';
import '../model/init_model.dart';
import '../model/model.dart';

abstract class Repository {
  Future<Either<Failure, InitModel>> initUser(InitUserRequest initUserRequest);
  Future<Either<Failure, ImageModel>> getArt(String art);
}
