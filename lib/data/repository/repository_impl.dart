import 'package:complete_advanced_flutter/app/logger_settings.dart';
import 'package:complete_advanced_flutter/data/data_source/local_data_source.dart';
import 'package:complete_advanced_flutter/data/data_source/remote_data_source.dart';
import 'package:complete_advanced_flutter/data/mapper/mapper.dart';
import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/data/network/network_info.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/data/responses/init_response.dart';
import 'package:complete_advanced_flutter/domain/model/image_model.dart';
import 'package:complete_advanced_flutter/domain/model/init_model.dart';
import 'package:complete_advanced_flutter/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

import '../network/error_handler.dart';

class RepositoryImpl extends Repository {
  RemoteDataSource _remoteDataSource;
  LocalDataSource _localDataSource;
  NetworkInfo _networkInfo;

  RepositoryImpl(
      this._remoteDataSource, this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, InitModel>> initUser(
      InitUserRequest initUserRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.initUser(initUserRequest);
        if (response.dataResponse != null) {
          return Right(response.toDomain());
        }
        return Left(ErrorHandler.handle("error").failure);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, ImageModel>> getArt(String art) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getArts(art);
        if (response.images != null) return Right(response.toDomain());
        return Left(ErrorHandler.handle("error").failure);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, ImageModel>> getQualityArt(String art) async {
    logger.e("Repoir");
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getQualityArts(art);
        if (response.images.isNotEmpty) return Right(response);
        return Left(ErrorHandler.handle("error").failure);
      } catch (error) {
        logger.e(error.toString());
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
