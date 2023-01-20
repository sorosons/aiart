import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/data/responses/image_response.dart';
import 'package:complete_advanced_flutter/domain/model/image_model.dart';
import 'package:complete_advanced_flutter/domain/repository/repository.dart';
import 'package:complete_advanced_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class CreateArtUseCase extends BaseUseCase {
  Repository _repository;
  CreateArtUseCase(this._repository);
  @override
  Future<Either<Failure, ImageModel>> execute(input) {
    return _repository.getArt(input);
  }

  Future<Either<Failure, ImageModel>> createQualityArtUseCase(input) {
    return _repository.getQualityArt(input);
  }
}
